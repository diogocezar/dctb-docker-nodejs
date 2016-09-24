FROM ubuntu:14.04

MAINTAINER diogocezar/nodejs Diogo Cezar <diogo@diogocezar.com>

######################
# UPDATE AND UPGRADE #
######################

RUN apt-get clean all
RUN apt-get update && apt-get -y upgrade

###########
# INSTALL #
###########

# GIT #
RUN apt-get install -y git

# SSH #
RUN apt-get install -y openssh-server

# NANO #
RUN apt-get install -y nano

# UNZIP #
RUN apt-get install -y unzip

# BASH-COMPLETION #
RUN apt-get install -y bash-completion

# CURL #
RUN apt-get install -y curl

# COMMON #
RUN apt-get -y install software-properties-common

# NODEJS #
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs

# SUPERVISOR #
RUN apt-get install -y nano supervisor

##################
# CONFIGURATIONS #
##################

ENV TERM xterm

RUN mkdir /var/www

RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

ADD . /data

##############
# SUPERVISOR #
##############

RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#######
# SSH #
#######

RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

#########
# PORTS #
#########
EXPOSE 22 8888

##########
# VOLUME #
##########
VOLUME ["/data"]

########
# EXEC #
########
CMD ["/usr/bin/supervisord"]