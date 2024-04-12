FROM ubuntu:16.04
WORKDIR /root
# Install required packages
RUN apt update && \
    apt install -y curl git gcc make libxaw7-dev xfonts-utils python-pip ipython python-colorama locales
# Generate and set en_US.UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
# Download birp, py3270 and x3270 source files
RUN git clone https://github.com/sensepost/birp && \
    git clone https://github.com/singe/py3270 && \
    curl -O 'http://x3270.bgp.nu/download/03.06/suite3270-3.6ga4-src.tgz'
# Install custom py3270
RUN pip2 install /root/py3270
# Uncompress x3270 source files
RUN tar -xvzf suite3270-3.6ga4-src.tgz && rm suite3270-3.6ga4-src.tgz
# Compile x3270 with birp patch
WORKDIR /root/suite3270-3.6
RUN patch -p1 < ../birp/suite3270-full.patch && \
    ./configure --enable-x3270 && \
    make && \
    cp obj/x86_64-unknown-linux-gnu/x3270/x3270 /root/birp
# Run birp
WORKDIR /root/birp
CMD python birp.py
