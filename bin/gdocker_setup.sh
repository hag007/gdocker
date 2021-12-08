#!/bin/bash
set -e 
source constants.sh
source parse_args.sh "$@"


if [[ -z $image_name  ]]; then image_name="ubuntu:18.04"; fi
if [[ -z $container_name  ]]; then container_name="primary"; fi
if [[ -z $package_files ]]; then package_files="${image_name}.packages.txt"; fi


echo "udocker pull ${image_name}"
udocker pull ${image_name}

if [[ $(udocker ps | cut -f 4 -d " " | grep "'"${container_name}"'") ]]; then
    read -p "The container ${container_name} already exists. Do you wish to replace it? (Y/N): " confirm &&  [[ $confirm == [yY] ]] || (echo "Aborted..." && exit 1)
    udocker rm ${container_name}
fi 
 

echo "udocker create --name=${container_name} ${image_name}"
udocker create --name=${container_name} ${image_name}

udocker run ${container_name} cp /etc/apt/sources.list /etc/apt/sources.list~
udocker run ${container_name} sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

udocker run ${container_name} apt-get update -y -o APT::Sandbox::User=root

udocker run ${container_name} apt-get install -y -o APT::Sandbox::User=root curl
udocker run ${container_name} ln -snf /usr/share/zoneinfo/$(curl https://ipapi.co/timezone) /etc/localtime 

udocker run ${container_name} ln -s /mnt/specific /specific

for package_file in ${package_files//,/ }; do 
    readarray -t lines < "${packages_dir}${package_file}"
    for line in "${lines[@]}"; do
        if [[ ! -z  ${line// } && ! ${line} =~ ^\#.*$ ]]; then
            echo "### installing ${line}... ###"
            udocker run --containerauth ${container_name} apt-get install -y -o APT::Sandbox::User=root $line
        fi
    done;
done; 

