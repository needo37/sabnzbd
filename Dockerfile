FROM phusion/baseimage:0.9.11
MAINTAINER needo <needo@superhero.org>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody
RUN usermod -g 100 nobody

RUN add-apt-repository ppa:jcfp/ppa
RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse"
RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse"
RUN add-apt-repository ppa:jon-severinsson/ffmpeg
RUN apt-get update -q
RUN apt-get install -qy unrar par2 sabnzbdplus wget ffmpeg

# Install multithreaded par2
RUN apt-get remove --purge -y par2
RUN wget -P /tmp http://www.chuchusoft.com/par2_tbb/par2cmdline-0.4-tbb-20100203-lin64.tar.gz
RUN tar -C /usr/local/bin -xvf /tmp/par2cmdline-0.4-tbb-20100203-lin64.tar.gz --strip-components 1

# Path to a directory that only contains the sabnzbd.conf
VOLUME /config
VOLUME /downloads

EXPOSE 8080

# Add sabnzbd to runit
RUN mkdir /etc/service/sabnzbd
ADD sabnzbd.sh /etc/service/sabnzbd/run
RUN chmod +x /etc/service/sabnzbd/run
