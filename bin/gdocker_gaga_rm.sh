#!/bin/bash
source constants.sh
source parse_args.sh "$@"

if [[ -z ${image_names} ]]; then
   echo "Please supply image names (comma delimited)"
   exit 1
fi

image_names=${image_names/,/ }

for image_name in ${image_names[@]}; do 
    rm ${images_dir}$image_name".tar"
done
