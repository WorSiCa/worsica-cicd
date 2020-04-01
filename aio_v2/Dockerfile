FROM centos:7.6.1810

MAINTAINER Ricardo Martins <rjmartins@lnec.pt>

ENV HOME /usr/local
ENV PYTHON_VERSION 3.6.3
ENV GDAL_VERSION 2.3.2
ENV SNAP_VERSION 6
ENV LD_LIBRARY_PATH /usr/lib:/usr/local/lib:/usr/local/lib64

#Install Python Virtual Environment (venv)
#Install ALL required centos dependencies to run this docker
#epel-release must be installed first to be able to grab the geos package
RUN yum update -y
RUN yum install -y epel-release
RUN yum install -y unzip wget make zlib-devel bzip2-devel openssl-devel readline-devel ncurses-devel sqlite-devel gdbm-devel db4-devel expat-devel libpcap-devel xz-devel pcre-devel libffi-devel gcc libXext libSM libXrender tar gcc-c++ proj geos nano

RUN cd $HOME \
    && curl -kL https://raw.githubusercontent.com/saghul/pythonz/master/pythonz-install | bash \
    && $HOME/pythonz/bin/pythonz install ${PYTHON_VERSION} \
    && $HOME/pythonz/pythons/CPython-${PYTHON_VERSION}/bin/python -m venv worsica_web-py363_venv

#grab the repository and use the requirements pip file, remove that folder, since we will run the portal from host
RUN cd $HOME \
    && wget https://github.com/WorSiCa/worsica-portal/archive/master.zip \
    && unzip master.zip \
    && cd worsica-portal-master \
    && $HOME/worsica_web-py363_venv/bin/pip3 install -r requirements-pip-test.txt \
    && $HOME/worsica_web-py363_venv/bin/pip3 install opencv-python==4.0.0.21 \
    && cd .. \
    && rm -rf worsica-portal-master

#Install GDAL for geodjango
#GDAL Binaries from source and pip
#this must be done on this way to avoid possible module errors with _gdal_array
RUN cd /var/tmp \
    && wget http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz \
    && tar xzvf gdal-${GDAL_VERSION}.tar.gz \
    && rm -rf gdal-${GDAL_VERSION}.tar.gz \
    && cd gdal-${GDAL_VERSION}/ \
    && ./configure \
    && make -j 4 \
    && make install \
    && cd .. \
    && rm -rf gdal-${GDAL_VERSION}
RUN cd /var/tmp \
    && $HOME/worsica_web-py363_venv/bin/pip3 download GDAL==${GDAL_VERSION} \
    && tar xzvf GDAL-${GDAL_VERSION}.tar.gz \
    && rm -rf GDAL-${GDAL_VERSION}.tar.gz \
    && cd GDAL-${GDAL_VERSION}/ \
    && $HOME/worsica_web-py363_venv/bin/python3 setup.py build_ext --include-dirs=/usr/local/include \
    && $HOME/worsica_web-py363_venv/bin/python3 setup.py install \
    && rm -rf GDAL-${GDAL_VERSION}

#ESA SNAP 6.0
#Derived from https://github.com/schwankner/docker-esa-snap/blob/eb68fb3a4dd33e6e6e74c35679665f759063590b/Dockerfile
RUN cd $HOME \
    && wget http://step.esa.int/downloads/${SNAP_VERSION}.0/installers/esa-snap_sentinel_unix_${SNAP_VERSION}_0.sh \
    && chmod +x $HOME/esa-snap_sentinel_unix_${SNAP_VERSION}_0.sh \
    && yum install -y gzip which \
    && $HOME/esa-snap_sentinel_unix_${SNAP_VERSION}_0.sh -q \
    && $HOME/snap/bin/snap --nosplash --nogui --modules --update-all


#Install dependencies to run functional tests (browsers)
RUN yum install -y firefox
RUN cd /var/tmp \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm \
    && yum install -y google-chrome-stable_current_x86_64.rpm \
    && rm -rf google-chrome-stable_current_x86_64.rpm

#install docker
#RUN yum install -y yum-utils device-mapper-persistent-data lvm2 \
#    && yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
#    && yum install -y docker-ce docker-ce-cli containerd.io

RUN cd $HOME \
    && mkdir worsica_web \
    && mkdir worsica_web_products

#set the path env variable and cwd
RUN ln -s /usr/lib64/libproj.so.0 /usr/lib/libproj.so \
    && ln -s /usr/lib64/libproj.so.0 /usr/local/lib64/libproj.so
ENV PATH /usr/local/worsica_web-py363_venv/bin:${PATH}
WORKDIR /usr/local/worsica_web
EXPOSE 8001

