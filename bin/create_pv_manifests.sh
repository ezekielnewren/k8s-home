NAMESPACE="$1"

if [ "$NAMESPACE" == "" ]; then
    echo "you must supply a namespace"
    exit 1
fi

host="pm1 pm2 pm3"

data=$(echo "$host" | tr ' ' '\n' | xargs -I {} vault kv get kv/machine/{} | jq .data.data | jq -sMc .)

template=$(dirname $0)/pv-template.yaml

if [ ! -f $template ]; then
    echo "$template: No such file or directory"
    exit 1
fi

create_manifest() {
  NODE=$1
  CLASS=$2
  MNSN=$3
  DESIGNATION=$(echo $MNSN | tr '[[:upper:]]' '[[:lower:]]' | tr '_' '-')
  SIZE=$(ssh metal@$NODE sudo blockdev --getsize64 /dev/mapper/$MNSN)
  filename=pv-$NODE-$CLASS.$DESIGNATION.yaml
  echo $filename
  < $template sed -e "s/NODE/$NODE/g" -e "s/CLASS/$CLASS/g" -e "s/MNSN/$MNSN/g" -e "s/DESIGNATION/$DESIGNATION/g" -e "s/SIZE/$SIZE/g" -e "s/NAMESPACE/$NAMESPACE/g" > $filename
}


for name in $host; do
    class="hdd"
    for mnsn in $(echo "$data" | jq ".[] | select(.hostname == \"$name\")" | jq -r .fde.hdd[].mnsn); do
        create_manifest $name $class $mnsn
    done

    class="ssd"
    for mnsn in $(echo "$data" | jq ".[] | select(.hostname == \"$name\")" | jq -r .fde.ssd[].mnsn); do
        create_manifest $name $class $mnsn
    done

    class="nvme"
    for mnsn in $(echo "$data" | jq ".[] | select(.hostname == \"$name\")" | jq -r .fde.nvme[].mnsn); do
        create_manifest $name $class $mnsn
    done
done


