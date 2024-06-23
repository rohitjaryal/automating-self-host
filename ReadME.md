# Setup on Debian system with docker and Ansible: -

Docker Build debian
``` bash
docker build -t my-debian-with-ssh .
```

Docker run container debian
``` bash
docker run -d -p 2222:22 --name my-debian-with-ssh-container my-debian-with-ssh
```

SSH login 
``` bash
ssh dockeruser@localhost -p 2222
``` 

##### Run ansible playbook via inventory

``` bash
ansible-playbook -i inventory.ini setup_raspberry_pi.yml
```

##### Currently some issues with environment setup. Mainly because of NPM. When npm is installed it installed under different pretext. Need to investgate more.