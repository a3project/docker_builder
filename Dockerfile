FROM archlinux:latest

LABEL maintainer="A³-Project <a3project@gmail.com>"

# Update repository
RUN pacman -Syy

# Install openssh
RUN pacman -S --noconfirm openssh

# Generate host keys
RUN /usr/bin/ssh-keygen -A

# Add password to root user
#RUN echo 'root:roottoor' | chpasswd
RUN (echo 'roottoor'; echo 'roottoor') | passwd root

# Fix sshd
#RUN sed -i -e 's/^UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN echo 'UsePAM no' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Expose tcp port
EXPOSE 22

# Run openssh daemon
CMD ["/usr/sbin/sshd", "-D"]

