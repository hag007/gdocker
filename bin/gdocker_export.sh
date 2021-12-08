#!/vin/bash
source constants.sh
source parse_args.sh "$@"

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

if [[ -f ${images_dir}${image_name}.tar ]]; then
    echo "Gaga image named ${image_name} already exists." 
    read -p "Do you wish to replace it? (Y/N): " confirm &&  [[ $confirm == [yY] ]] || (echo "Aborted..." && exit 1)
fi

cmd="udocker export --clone ${images_dir}${image_name}.tar ${container_name}"
echo run $cmd
eval ${cmd}
chmod 775 ${images_dir}${image_name}.tar
