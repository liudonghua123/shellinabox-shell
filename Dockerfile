FROM ubuntu:latest

MAINTAINER liudonghua123 <liudonghua123@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

# install build prerequisites
RUN apt-get -y install git build-essential cmake python

# build cling
RUN mkdir -p /code
RUN cd /code  && git clone http://root.cern.ch/git/llvm.git src
RUN cd /code/src/ && git checkout cling-patches
RUN mkdir -p /code/src/tools
RUN cd /code/src/tools && git clone http://root.cern.ch/git/cling.git
RUN cd /code/src/tools && git clone http://root.cern.ch/git/clang.git
RUN cd /code/src/tools/clang && git checkout cling-patches
RUN mkdir -p /code/build
WORKDIR /code/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release ../src
RUN cmake --build .
RUN cmake --build . --target install

# install shellinabox
RUN apt-get -y install shellinabox
# copy shellinabox themes
COPY ["shellinabox-themes", "/usr/local/share/shellinabox"]

# install other utilities
RUN apt-get -y install python python3 ipython ipython3

# do some cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# create non-root user and change WORKDIR
RUN useradd -ms /bin/bash shell
RUN echo "root:root" | chpasswd
RUN echo "shell:shell" | chpasswd

# set default user and cwd
USER root
WORKDIR /home/shell

CMD ["shellinaboxd", "-t", "-s", "/:LOGIN", \
"-s", "/python:shell:shell:HOME:/usr/bin/python", \
"-s", "/ipython:shell:shell:HOME:/usr/bin/ipython", \
"-s", "/python3:shell:shell:HOME:/usr/bin/python3", \
"-s", "/ipython3:shell:shell:HOME:/usr/bin/ipython3", \
"-s", "/cling:shell:shell:HOME:/usr/local/bin/cling", \
"--static-file=styles.css:/usr/local/share/shellinabox/shellinabox.css", \
"--user-css=Tomorrow Light:+/usr/local/share/shellinabox/theme-tomorrow-light.css,Tomorrow Dark:-/usr/local/share/shellinabox/theme-tomorrow-dark.css"]

