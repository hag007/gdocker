# gdocker - a wrapper around udocker 
##### gdocker encapsulates udocker's flags to facilitate your routine usage, and extends udocker functionality for more complex use cases such as setting-up packages for a new container and managing a local tar repository.  
##### In addition, gdocker can seamlessly run udocker commands (e.g. gdocker run, gdocker ps etc.).  In addition it contains the following commands (flags values can be replaced):
```diff 
- Note that gdocker work only in Linux OS!
```

- [Installation](#installation)
- [Commands](#commands)
  - [setup](#setup)
  - [up](#up)
  - [gaga-import](#gaga-import)
  - [gaga-export](#gaga-export)
  - [gaga-rm](#gaga-rm)
  - [gaga-ls](#gaga-ls)

### Installation
To install gdocker, execute the following steps:

1. clone the projec and change the  bin/constant.sh file as follows:
    - root_dir="/path/to/gdocker/folder/
    - packages_dir="/path/to/gdocker/package_files" (see below [`gdocker setup`](#setup)))
    - images_dir="/path/to/gdocker/local_repo/"  

2. Add gdocker to your PATH env:
For tcsh users: `echo "setenv PATH /specific/netapp5/gaga/tools/gdocker/bin:$PATH" >> ~/.tcshrc && source ~/.tcshrc`
or 
For bash users: `echo "export PATH=/specific/netapp5/gaga/tools/gdocker/bin:$PATH" >> ~/.bashrc && source ~/.bashrc`

Now you are all set to go!

### Commands
#### setup
`gdocker setup --image_name="ubuntu:latest" --container_name=primary --package_files="ubuntu:latest.packages.txt"`
Create a new container named using the image "ubuntu:latest" (image is fetched from dockerhub). After creating the container, gdocker will install the packages listed in "ubuntu:latest.packages.txt" 
- Package files reside in /specific/netapp5/gaga/tool/gdocker/packages
- gdocker will install all packges listed in the specified package file 
- In each file package names are linebreak delimited
- Lines starting with hashtag (#) are ignored as comments
- You can specifit multiple packge files for a single setup command using comma delimited format. (e.g. --package_files=a.txt,b.txt)

#### up
`gdocker up --container_name=primary --host_port=2222 --container_port=1111`
starts the container named "primary" This command encapsulates several udocker flags:
-  `--volume` /specific:/mnt/specific --volume /home/gaga:/home/gaga: binds /specific/ and /home/gaga dirs to the containers  
-  `--containerauth` uses container's encapsulated users/group policy (required for some installations)
-  `--publish` 2222:1111 opens a tunnel from `container_port` (1111) to `host_port` (2222). This option enables intercating the container from outside (e.g. for remote debugging C++/Java code).
-  You can add additional native udocker options of "udocker run" command you may way to add.

#### gaga-import
`gdocker gaga-import --container_name=primary_ctnr --image_name=primary_img` 
- Creates primary_ctnr from a tar image file in gaga-dockerhub primary_img
- Image files reside in /specific/netapp5/gaga/tool/gdocker/images 
- primary_img is a tar file (primary_img.tar)

#### gaga-export
`gdocker gaga-export --container_name=primary_ctnr --image_name=primary_img` 
- Creates a tar image from the container primary_ctnr file in gaga-dockerup
- Image files are saved in /specific/netapp5/gaga/tool/gdocker/images 

#### gaga-rm
`gdocker gaga-rm --container_name=primary_ctnr`
- Deletes the container named "primary_ctnr"

#### gaga-ls
`gdocker gaga-ls`
- Lists all available tar images under gaga-dockerhub
