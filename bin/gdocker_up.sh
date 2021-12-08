#!/bin/bash

skip_param=false
gdocker_params=""
udocker_params=""
echo "$@"
for input in "$@"; do
    echo $input
    if [[ ${input%%=*} == "--container_name" || ${input%%=*} == "--container_port" || ${input%%=*} == "--host_port" ]]; then
        gdocker_params=$gdocker_params" "$input
    else
        udocker_params=$udocker_params" "$input
    fi
done

if [[ ! -z $gdocker_params ]]; then
    source parse_args.sh $gdocker_params
fi

if [[ -z $container_name  ]]; then container_name="primary"; fi

if [[ -z $host_port ]]; then 
    n=$(md5sum <<< "$USER")
    n_prefix=$((100+($((0x${n%% *})) % 900)))
    n_suffix=$((RANDOM % 10))
    host_port=${n_prefix#-}${n_suffix}
    echo "Assigning port by username: Ports for user ${USER} starts with starts with ${n_prefix#-})" 
fi

if [[ -z $container_port  ]]; then container_port=$host_port; fi


home_dir=/specific/a/home/cc/students/cs/$USER/
if [[ ! -d $home_dir ]]; then
    home_dir=/specific/a/home/cc/students/csguests/$USER/
fi
if [[ ! -d $home_dir ]]; then
    home_dir=/specific/a/home/cc/cs/$USER/
fi

echo ${udocker_params}
echo $DISPLAY
cmd="udocker run --containerauth --volume /specific:/mnt/specific --volume /home/gaga:/home/gaga --volume /run/shm:/dev/shm --volume $home_dir:/root --publish=${host_port}:${container_port} ${container_name} ${udocker_params} bash -c 'export DISPLAY=$DISPLAY && bash'"
echo "Executing ${cmd}"
eval ${cmd}



