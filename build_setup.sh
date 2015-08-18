sudo apt-get update; sudo apt-get install -y curl git s3cmd
sudo curl -sSL https://get.docker.com/ | sh && sudo usermod -aG docker vagrant
ln -s /home/vagrant/dd-agent-omnibus/build /home/vagrant/build
sudo docker build -t fastly/docker-dd-agent-build-rpm-i386 /home/vagrant/docker-dd-agent-build-rpm-i386
