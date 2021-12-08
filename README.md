Welcome to gdocker - a wrapper around udocker for gaga users :)

gdocker encapsulates all necessary (and annoying) flags to facilitate your routine usage. 
In addition, gdocker extends udocker functionality for more complex use cases such as setting-up packages for a new container and local gaga-dockerhub manager

To start using udocker, please add it to your PATH env:
For tcsh users: echo "setenv PATH /specific/netapp5/gaga/tools/gdocker/bin:$PATH" >> ~/.tcshrc && source ~/.tcshrc
or 
For bash users: echo "export PATH=/specific/netapp5/gaga/tools/gdocker/bin:$PATH" >> ~/.bashrc && source ~/.bashrc

gdocker can seamlessly run every udocker functionality (e.g. gdocker run, gdocker create etc.).  In addition it contains the following commands (flags values can be replaced):

*** gdocker setup --image_name="ubuntu:latest" --container_name=primary --package_files="ubuntu:latest.packages.txt"
Create a new container named using the image "ubuntu:latest" (image is fetched from dockerhub). After creating the container, gdocker will install the packages listed in "ubuntu:latest.packages.txt" 
(1) Package files reside in /specific/netapp5/gaga/tool/gdocker/packages
(2) gdocker will install all packges listed in the specified package file
(3) in each file package names are linebreak delimited
(4) lines that starts with hashtag (#) are ignored as comments
(5) you can specifit multiple packge files for a single setup command using comma delimited format. (e.g. --package_files=a.txt,b.txt)

*** gdocker up --container_name=primary --host_port=2222 --container_port=1111 *
starts the container named "primary" This command encapsulates several udocker flags:
(1) --volume /specific:/mnt/specific --volume /home/gaga:/home/gaga: binds /specific/ and /home/gaga dirs to the containers  
(2) --containerauth: uses container's encapsulated users/group policy (required for some installations)
(3) --publish 2222:1111 opens a tunnel from container port (1111) to host port (2222). This option enables intercating the container from outside (e.g. for remote debugging C++/Java code).
(4) * denotes additional native udocker options of "udocker run" command you may way to add.

*** gdocker gaga-import --container_name=primary_ctnr --image_name=primary_img 
(1) Creates primary_ctnr from a tar image file in gaga-dockerhub primary_img
(2) Image files reside in /specific/netapp5/gaga/tool/gdocker/images 
(3) primary_img is a tar file (primary_img.tar)

*** gdocker gaga-export --container_name=primary_ctnr --image_name=primary_img 
(1) Creates a tar image from the container primary_ctnr file in gaga-dockerup
(2) Image files are saved in /specific/netapp5/gaga/tool/gdocker/images 

*** gdocker gaga-rm --container_name=primary_ctnr
(1) Deletes the container named "primary_ctnr"

*** gdocker gaga-ls
(1) list all available tar images under gaga-dockerhub

Cheers!


