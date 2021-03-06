FROM scratch
ADD centos-7-docker.tar.xz /

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="CentOS Base Image" \
    org.label-schema.vendor="CentOS" \
    org.label-schema.license="GPLv2" \
    org.label-schema.build-date="20181204"

CMD ["/bin/bash"]

#update yum repository and install openssh server
# RUN yum update -y
RUN yum install wget -y 
RUN yum install -y openssh-server

#generate ssh key
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN sed -ri 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd
RUN mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh

#change root password to 123456
RUN echo 'root:123456' | chpasswd

#RUN curl https://git.oschina.net/feedao/Docker_shell/raw/start/ali-centos.sh | sh
#ENV LANG en_US.UTF-8
#ENV LC_ALL en_US.UTF-8

# install ipsec
#RUN curl https://raw.githubusercontent.com/lhpmain/setup-ipsec-vpn/master/vpnsetup_centos.sh -O vpnsetup.sh && sudo sh vpnsetup.sh | sh
RUN wget https://raw.githubusercontent.com/lhpmain/setup-ipsec-vpn/master/vpnsetup_centos.sh -O vpnsetup.sh && sh vpnsetup.sh


EXPOSE 22
CMD /usr/sbin/sshd -D
