FROM debian:latest

RUN apt-get update

# install prerequisites
RUN apt-get -qq -y install git
RUN apt-get -qq -y install shellinabox
RUN apt-get -qq -y install build-essential cmake

# build cling
RUN mkdir -p /code
WORKDIR /code
RUN git clone http://root.cern.ch/git/llvm.git src
WORKDIR /code/src
RUN git checkout cling-patches
RUN mkdir -p /code/src/tools
WORKDIR /code/src/tools
RUN git clone http://root.cern.ch/git/cling.git
RUN git clone http://root.cern.ch/git/clang.git
WORKDIR /code/src/tools/clang
RUN git checkout cling-patches
WORKDIR /code/
RUN mkdir build
WORKDIR /code/build
RUN apt-get -qq -y install python
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release ../src
RUN cmake --build .
RUN cmake --build . --target install

# copy shellinabox themes
COPY ["shellinabox-themes", "/usr/local/share/shellinabox"]

# install other utilities
RUN apt-get -y install python3 ipython

# create non-root user and change WORKDIR
RUN useradd -ms /bin/bash shell
USER root
WORKDIR /home/shell

# change user password
RUN echo "root:root" | chpasswd
RUN echo "shell:shell" | chpasswd

CMD ["shellinaboxd", "-t", "-s", "/:LOGIN", "-s", "/python:shell:shell:HOME:/usr/bin/python", "-s", "/ipython:shell:shell:HOME:/usr/bin/ipython", "-s", "/python3:shell:shell:HOME:/usr/bin/python3", "-s", "/ipython3:shell:shell:HOME:/usr/bin/ipython3", "-s", "/cling:shell:shell:HOME:/usr/local/bin/cling", "--static-file=styles.css:/usr/local/share/shellinabox/shellinabox.css", "--user-css=Tomorrow Light:+/usr/local/share/shellinabox/theme-tomorrow-light.css,Tomorrow Dark:-/usr/local/share/shellinabox/theme-tomorrow-dark.css"]

