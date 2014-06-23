FROM debian:jessie
MAINTAINER needo <needo@superhero.org>
ENV DEBIAN_FRONTEND noninteractive

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody
RUN usermod -g 100 nobody

RUN sed -i 's/main$/main contrib non-free/' /etc/apt/sources.list
RUN apt-get update -q
RUN apt-get install -qy unrar par2 sabnzbdplus wget

# Install multithreaded par2
RUN apt-get remove --purge -y par2
RUN wget -P /tmp http://www.chuchusoft.com/par2_tbb/par2cmdline-0.4-tbb-20100203-lin64.tar.gz
RUN tar -C /usr/local/bin -xvf /tmp/par2cmdline-0.4-tbb-20100203-lin64.tar.gz --strip-components 1

#Path to a directory that only contains the sabnzbd.conf
VOLUME /config
VOLUME /downloads

EXPOSE 8080

# Let's not run sabnzbd as root
USER nobody
ENTRYPOINT ["/usr/bin/sabnzbdplus"]
CMD ["--config-file", "/config", "--server", "0.0.0.0:8080"]
