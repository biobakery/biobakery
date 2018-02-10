# Use the latest linuxbrew container, based on ubuntu xenial
FROM sjackman/linuxbrew

# Add image version and date
RUN echo "Image version 1.2, "$(date) > $HOME/image_version.txt

USER root
# Update all installed packages
RUN apt-get -qq update && apt-get dist-upgrade -y
# Install packges for formula installation and dependencies 
RUN apt-get -qq update &&\
    apt-get install -y mercurial git python-pip\
    python2.7-dev pkg-config\
    openjdk-8-jre\
    software-properties-common\
    apt-transport-https\
    libfreetype6-dev
RUN pip install setuptools --upgrade

# Install the latest R
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu xenial/'
RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9
RUN gpg -a --export E084DAB9 | apt-key add -
RUN apt-get -qq update && apt-get install r-base -y

# Symlink freetype so matplotlib can find the install
RUN ln -s /usr/include/freetype2/ft2build.h /usr/include/

# Install editor
RUN apt-get install vim -y

# Add fix for dist-upgrade that breaks locals (used by brew)
RUN locale-gen en_US.UTF-8

# Add the biobakery tool formulas
USER linuxbrew
RUN brew tap biobakery/biobakery

# Tap dependencies
RUN brew tap brewsci/science
RUN brew tap homebrew/dupes

# Install demos for automated testing
RUN brew install biobakery_demos

