FROM perl:5.20

# Needed to avoid "debconf: unable to initialize frontend:"
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# === Add a few utility apps for interactive use ===
RUN apt-get update && \
    apt-get install -y apt-utils && \
    apt-get install -y mc less vim lsof htop

# Reset debconf-set-selections
RUN echo 'debconf debconf/frontend select readline' | debconf-set-selections

RUN cpan -i "DBI" && \
	cpan -i "DBD::Pg" && \
	cpan -i "Module::Pluggable"

#COPY . /usr/src/tdms
RUN git clone https://buildtools.bisnode.com/stash/scm/qa/tdms.git /usr/src/tdms
WORKDIR /usr/src/tdms

CMD [ "/bin/bash" ]
