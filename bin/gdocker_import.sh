#!/vin/bash
source constants.sh
source parse_args.sh "$@"

echo ${container_name}
echo ${image_name}

if [[ -z ${container_name} && -z ${image_name} ]]; then
   error "Neither container name nor image name were supplied"
   exit 1
fi

if [[  -z ${container_name} && ! -z ${image_name} ]]; then
   echo "Container name was not supplied. Setting container name as image name..."
   container_name=$image_name
fi

if [[ ! -z ${container_name} && -z ${image_name} ]]; then
   echo "Image name was not supplied. Setting image name as container name"
   image_name=$container_name
fi

if [[ ! -f ${images_dir}${image_name}.tar ]]; then
    echo "Gaga image named ${image_name} does not exist (expected to find ${images_dir}${image_name}.tar)". 
    exit 1 
fi

if [[ $(udocker ps | cut -f 4 -d " " | grep "'"${container_name}"'") ]]; then
    read -p "The container ${container_name} already exists. Do you wish to replace it? (Y/N): " confirm &&  [[ $confirm == [yY] ]] || (echo "Aborted..." && exit 1)
    udocker rm ${container_name}
fi

cmd="udocker import --tocontainer --clone --name=${container_name} ${images_dir}${image_name}.tar"
echo "run $cmd"
eval ${cmd}


