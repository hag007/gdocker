#!/bin/bash
set -e 

source parse_args.sh "$@"

if [[ -z $image  ]]; then image="ubuntu:latest"; fi
if [[ -z $container_name  ]]; then container_name="testme"; fi
if [[ -z $docker_folder ]]; then docker_folder='/specific/netapp5/gaga/hagailevi/udocker_test'; fi
if [[ -z $username ]]; then username='hagailevi'; fi
if [[ -z $force ]]; then force=true; fi


# Remove previously existing folder
rm -fr ${docker_folder}

# create the local Docker folder:
udocker mkrepo ${docker_folder}

# Append your local Docker repository to your environment variables    
echo "export UDOCKER_DIR=${docker_folder}" >> ~/.bashrc && source ~/.bashrc

# Pull an image from Dockerhub
udocker pull ${image}

# Spawn a new container
udocker create --name=${container_name} ${image}

# Link "specific" folder to the container
udocker run ${container_name} ln -s /mnt/specific /specific

./udocker_setup.sh

# run the newly created container 
udocker run --bindhome --volume /specific:/mnt/specific --containerauth ${container_name} 



