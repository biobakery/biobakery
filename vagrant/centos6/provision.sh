sudo yum update -y
sudo yum groupinstall -y 'Development Tools' && \
    sudo yum install -y curl git irb python-setuptools ruby \
	                man java-1.8.0-openjdk

sudo -u vagrant bash /vagrant/user_install.sh

