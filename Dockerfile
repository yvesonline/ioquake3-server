FROM ubuntu:20.04

# Install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y ioquake3-server && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy baseq3
WORKDIR /root/.q3a/baseq3
COPY baseq3 .

# Copy config
COPY autoexec.cfg .
COPY bots.cfg .
COPY levels.cfg .
COPY server.cfg .

# Set PATH
ENV PATH="${PATH}:/usr/lib/ioquake3"

# Ports
EXPOSE 27950/tcp 27952/tcp 27960/tcp 27965/tcp 27950/udp 27952/udp 27960/udp 27965/udp

# Run
CMD ["ioq3ded", "+exec", "server.cfg", "+exec", "bots.cfg", "+exec", "levels.cfg"]