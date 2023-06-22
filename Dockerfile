FROM ubuntu:18.04

LABEL Description="Amber and Amber Tool 23"

# Mount Point
RUN mkdir -p /data
VOLUME /data

# Instalol c++ Chain
RUN apt-get update && apt-get install -y cmake wget csh flex patch gfortran g++ make xorg-dev libbz2-dev zlib1g-dev libboost-dev libboost-thread-dev libboost-system-dev bash xorg lightdm

# Install OpenMPI
#RUN apt-get install -y openmpi-bin libopenmpi-dev


# Amber source code
RUN mkdir /amber_source && mkdir /amber
COPY Amber18.tar.bz2 /amber_source/
COPY AmberTools18.tar.bz2 /amber_source/

   
WORKDIR /amber_source

RUN tar -jxvf AmberTools18.tar.bz2 && \
    tar -jxvf Amber18.tar.bz2 && \
    rm -rf AmberTools18.tar.bz2 && \
    rm -rf Amber18.tar.bz2

# CMake
RUN cd amber18 && \
 	mkdir build && \
	cd build && \
	cmake .. -DAPPLY_UPDATES=TRUE -DCMAKE_INSTALL_PREFIX=/amber -DBUILD_GUI=TRUE -DBUILD_PERL=TRUE -DCOMPILER=GNU -DCUDA=FALSE -DDOWNLOAD_MINICONDA=TRUE -DMINICONDA_USE_PY3=TRUE && \
	make && \
	make install

ENV AMBERHOME=/amber
ENV PATH=/amber/bin:$PATH
ENV LD_LIBRARY_PATH=/amber/lib:$LD_LIBRARY_PATH
RUN rm -rf /amber_source

###### VNC #######

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

### Envrionment config
ENV HOME=/headless \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/headless/install \
    NO_VNC_HOME=/headless/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false
WORKDIR $HOME

### Add all install scripts for further steps
ADD ./src/common/install/ $INST_SCRIPTS/
ADD ./src/ubuntu/install/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

### Install some common tools
RUN $INST_SCRIPTS/tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh
RUN $INST_SCRIPTS/no_vnc.sh

### Install firefox
RUN $INST_SCRIPTS/firefox.sh
RUN $INST_SCRIPTS/chrome.sh

### Install xfce UI
RUN $INST_SCRIPTS/xfce_ui.sh
ADD ./src/common/xfce/ $HOME/

### configure startup
RUN $INST_SCRIPTS/libnss_wrapper.sh
ADD ./src/common/scripts $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME


### Other tools (xmgrace and vmd)
RUN mkdir -p /othertools
WORKDIR /othertools
RUN apt-get install -y grace
COPY vmd-1.9.3.tar.gz /othertools/
RUN ls -l 
RUN tar xvf vmd-1.9.3.tar.gz
RUN cd vmd-1.9.3 && \
    ./configure && \
    cd src && \
    make install
RUN cd / && rm -rf /othertools

USER 1000

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]
