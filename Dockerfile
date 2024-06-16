# Use the official Debian base image
FROM debian:latest

# Set environment variables to non-interactive mode to avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages, including OpenSSH server, sudo, and sshpass
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    sshpass \
    && rm -rf /var/lib/apt/lists/*

# Create a directory for the SSH daemon to run
RUN mkdir /var/run/sshd

# Create a new user (e.g., 'dockeruser') with password 'password' (change as needed)
RUN useradd -rm -d /home/dockeruser -s /bin/bash -g root -G sudo -u 1001 dockeruser
RUN echo 'dockeruser:password' | chpasswd

# Allow password authentication (uncomment the line in sshd_config)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Install Python 3 and necessary dependencies
RUN apt-get update && apt-get install -y \
    python3 \
#    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \

# Expose the SSH port
EXPOSE 22

# Add a script to start SSH service and keep the container running
CMD ["/usr/sbin/sshd", "-D"]


# Install dependencies
#RUN apt-get update && apt-get install -y \
#    curl \
#    gnupg \
#    lsb-release \
#    supervisor \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/*
#
## Add Ollama's GPG key and repository
##RUN curl -sSL https://ollama.com/gpg.key | apt-key add - \
##    && echo "deb https://ollama.com/debian stable main" > /etc/apt/sources.list.d/ollama.list
#
## Install Ollama
#RUN curl -fsSL https://ollama.com/install.sh | sh
##RUN apt-get update && apt-get install -y ollama
#
#RUN which supervisord
#
## Copy supervisord configuration
#COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#
##RUN ollama --version
#
## Expose the default port for Ollama API
#EXPOSE 11434
#
## Command to run Ollama on tinyllama
##CMD ["ollama", "serve"]
##CMD ["ollama", "run", "tinyllama"]
#
## Run supervisord
#CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

#docker build -t my-debian-with-ssh .
#docker run -d -p 2222:22 --name my-debian-with-ssh-container my-debian-with-ssh
#ssh dockeruser@localhost -p 2222

#ansible-playbook -i inventory.ini setup_raspberry_pi.yml