## Docker for Amber and AmberTool 18


### Prequest

* Docker
* git
* Amber 

### Build Amber Image

* git clone https://github.com/yylonly/AmberDocker.git
* cd Amberdocker
* put Amber18.tar.bz2 and AmberTools18.tar.bz2 into this folder 
* docker build . -t amber18:cpuonly (~1 hours)

### Run Docker Container

* docker run -it -p 5901:5901 -p 6901:6901 -v {SharedFolder}:/data --user 0  amber18:cpuonly

You host shared foleder will be mounted on /data in the container

### Connect to Container

* VNC viewer via 127.0.0.1:5901 (default password `vncpassword`)
* Your favour web brower http://127.0.0.1:6901/vnc.html 


