FROM archlinux:latest

LABEL maintainer="A³-Project <a3project@gmail.com>"

# Update repository
RUN pacman -Syy

# Install openssh
RUN pacman -S --noconfirm openssh

# Generate host keys
RUN /usr/bin/ssh-keygen -A

# Add password to root user
RUN (echo '@RootPwdNo1'; echo '@RootPwdNo1') | passwd root

# Fix sshd
RUN echo 'UsePAM no' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Add user
RUN useradd -m -s /bin/bash ibnuridwan -c "Abu Abdillah"
RUN (echo 'Cuma123kok'; echo 'Cuma123kok') | passwd ibnuridwan

# Install development packages
RUN sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
RUN pacman -Syyu --noconfirm --needed multilib-devel base-devel vim nano git curl wget

# Installing Android building prerequisites
RUN git clone https://aur.archlinux.org/ncurses5-compat-libs
RUN cd ncurses5-compat-libs || exit
RUN makepkg -si --skippgpcheck --noconfirm --needed
RUN cd - || exit
RUN rm -rf ncurses5-compat-libs

RUN git clone https://aur.archlinux.org/lib32-ncurses5-compat-libs
RUN cd lib32-ncurses5-compat-libs || exit
RUN makepkg -si --skippgpcheck --noconfirm --needed
RUN cd - || exit
RUN rm -rf lib32-ncurses5-compat-libs

RUN git clone https://aur.archlinux.org/aosp-devel
RUN cd aosp-devel || exit
RUN makepkg -si --skippgpcheck --noconfirm --needed
RUN cd - || exit
RUN rm -rf aosp-devel

RUN git clone https://aur.archlinux.org/xml2
RUN cd xml2 || exit
RUN makepkg -si --skippgpcheck --noconfirm --needed
RUN cd - || exit
RUN rm -rf xml2

RUN git clone https://aur.archlinux.org/lineageos-devel
RUN cd lineageos-devel || exit
RUN makepkg -si --skippgpcheck --noconfirm --needed
RUN cd - || exit
RUN rm -rf lineageos-devel

RUN git clone https://aur.archlinux.org/lineageos-devel
RUN cd lineageos-devel || exit
RUN makepkg -si --skippgpcheck --noconfirm --needed
RUN cd - || exit
RUN rm -rf lineageos-devel

# Installing adb convenience tools
RUN pacman -S --noconfirm --needed android-tools android-udev

# Expose tcp port
EXPOSE 22

# Run openssh daemon
CMD ["/usr/sbin/sshd", "-D"]

