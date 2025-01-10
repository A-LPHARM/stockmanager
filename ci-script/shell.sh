#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo yum update -y

# Install Git, wget, and unzip
echo "Installing Git, wget, and unzip..."
sudo yum install -y git wget unzip

# Install Java (OpenJDK 17)
echo "Installing Java (OpenJDK 17)..."
sudo yum install -y fontconfig java-17-openjdk

# Install Maven
echo "Installing Maven..."
sudo yum install -y maven

# Install Docker
echo "Installing Docker..."
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl start docker
sudo systemctl enable docker


# Install Jenkins
echo "Installing Jenkins..."
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
# Add required dependencies for the jenkins package
sudo yum update -y
sudo yum install -y jenkins
# Start Jenkins service and enable it to start on boot
echo "Starting Jenkins..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Echo the Jenkins security key that is required upon initialisation
printf "\n\nJENKINS KEY\n*********************************"
# Add the Jenkins user to the Docker group
usermod -aG docker jenkins
# Wait until the initialAdminPassword file is generated via Jenkins startup
while [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]
do
    sleep 2
done
cat /var/lib/jenkins/secrets/initialAdminPassword
printf "*********************************"
# restart the Jenkins service so that the usermod command above takes effect
service jenkins restart


# Install Docker Compose
echo "Installing Docker Compose..."
DOCKER_COMPOSE_VERSION="1.29.2"
sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


# End of script
echo "Installation complete. Jenkins and Docker are installed. Docker Compose is also ready to use."
