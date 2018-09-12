## Docker for Amber and AmberTool 18 (included VMD and xmgrace)


### Prerequisite

* Windows 10 / linux / MacOS
* [Docker](https://www.docker.com/products/docker-desktop)
* [Git](https://git-scm.com/download/win) 
* [VNC Viewer](https://www.realvnc.com/en/connect/download/viewer/)
* Manually donwload Amber18.tar.bz2, AmberTools18.tar.bz2, and vmd-1.9.3.tar.gz

### Build Amber Image

Open command line, then type:

* **(windows only)** git config --global core.autocrlf false 
* git clone https://github.com/yylonly/AmberDocker.git
* cd Amberdocker
* manually download Amber18.tar.bz2 and AmberTools18.tar.bz2 into this folder 
* manually download VMD-1.9.3(linux-OpenGL Version), then rename as vmd-1.9.3.tar.gz and paste into this folder
* docker build . -t amber18:cpu (~1 hours)

### Run Docker Container

* docker run --rm -p 5901:5901 -p 6901:6901 -v {SharedFolder}:/data --user 0  amber18:cpu

You host shared foleder will be mounted on /data in the container

### Connect to Container

* VNC viewer via 127.0.0.1:5901 (default password `vncpassword`)
* Your favour web brower http://127.0.0.1:6901/vnc.html 

Note that: this image have already been tested through Amber Tutorials (B0-B2)
