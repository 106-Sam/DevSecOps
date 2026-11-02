# Docker

Index of Content

1. [Day 1 - Docker Introduction](https://github.com/106-Sam/DevSecOps/tree/dockerbranch/Docker#day-1---docker-introduction)
2. [Day 2 - Container Operations](https://github.com/106-Sam/DevSecOps/tree/dockerbranch/Docker#day-2---container-operations)
3. [Day 3 - Docker Networks](https://github.com/106-Sam/DevSecOps/tree/dockerbranch/Docker#day-3---docker-networks)
4. [Day 4 - ](https://github.com/106-Sam/DevSecOps/tree/dockerbranch/Docker#day-3---)



## Day 1 - Docker Introduction 

**Docker** is a containeriztion tool


### History

1. Physical server --> Windows/Linux OS --> Apps on the Windows/Linux machine
2. Bare-metal Hypervisor | Physical server --> VMware ESXI --> App1 (linux), App2 (windows), App3 (linux)...
   
   Based on hardware specification, we can install multiple operating system.

3. Non Bare Metal Hypervisor | Physical server --> Windows Server --> Hyper-V enabled --> App1 (linux), App2 (windows), App3 (linux)...

Hypervisor virtualizes at Operating System layer

4. Microservices | For every application (App), we need many virtual machine to overcome this we use Docker 
5. Docker | Linux VM (EC2 with docker software installed it becomes docker host) --> We can run multiple application

- We can run different software with different version in the a single OS using docker.

- ![alt text](files/image.png)

What are issue that Docker is solving ?

- We can run multiple application and even the same kind applications with different versions.
- Docker is solving environmental issues.
- We can any docker image to any operating system.
- Docker mainly supports microservice applications (monolith)
- monolith is all the application is made into a single package and we installed it. 


SOA - Service oriented Architecture

Docker Registory - [hub.docker.com](hub.docker.com)

### Installation of Docker 

`apt install docker.io`

#### to run docker without sudo by adding user to docker group

``` bash
sudo usermod -aG docker $USER
newgrp docker 
```

- `docker info` - it displays the information about the docker hosts
- `docker images` - to list all the images that are present locally on the system
- `docker ps` - to list out the running containers ()
- `docker pull <containerName>` - to pull the image locally.

Docker runs in a server-client concept. In backend, `dockerd` services are running. 
`dockerd` is a daemon which acts as a server.
docker cli commands are called as a client.

- by default, the images are taken or pulled from docker hub
- Azure - ACR for container and ECR for AWS
- `docker search <containerName>` - To search container from docker hub via CLI.
- `docker inspect image <containerName>` - To view the layers and updates of an Docker image
- `docker image prune -a` - 

Docker runs linux image if using Linux machine as a host
Docker runs windows image if using windows machne as a host.


## Day 2 - Container Operations

The difference between `locate` and `find` command 
- `find` command goes into all the path in the system and searches for it.
- `locate` command update the new file or directory in the cache and finds it quickly.

Whenever, we inspect a docker image using `docker inspect image <containerName>` we will see `cmd` path which is run by default when we start/execute the images.


#### What is image?

Docker Image is immutable, we can't change anything in an image, image doesn't have any runtime where as container has a runtime and which can be accessible outside and is similar to a Virtual Machine (VM)

- `docker create <imageName>` - To create a container
- `docker create --name <customName> <imageName>` - To create a container with custom name
- `docker create --name <customName> -it <imageName>` - To create ubuntu or operating system related image in interactive mode for /bin/bash 
- `docker attach <contName>` - To attach into the container like operating system but when we exit the contianer also exits 
- `docker run <contName/ImageName>` - run command is a combination of [pull, create, start, attach/detach, stop] docker cli.

- `docker rm <contID/contName` - To delete a container
- `docker rm -f <contID/contName> ` - To stop and delete the container at once (normally force 
delete)
- `docker rmi <imageName>` - To delete the docker images
  
- `docker ps` - this command is to list out the running containers
- `docker ps -a` - this command is to list out all the running/stopped/created (any state) containers
  
- `docker start <contID/contName>` - TO start a container 
- `docker stop <contID/contName>` - TO stop a container 


To run an container in detach mode without exiting 
`docker run -d -it --name ubuntu111 ubuntu`


## Day 3 - Docker Networks

- `docker events` - it displays all the events occured in the backend in docker cli.
- `docker top <contName/ID>` - it displays information related to PPID (processIDs) etc.
- `docker exec -it <contName/ID>` - it login to the container via shell 


#### Difference between attach and exec docker command

- when we use `docker attach` command the docker container gets killed when we exit.
- whereas in `docker exec` command the docker container still runs even after we exit.

#### Requirement in interview if asked we need to use attach command only but when I exit the container must not be killed

- In that scenario we use `docker attach --detach-keys="ctrl-z" <contName/ID>` it takes us to container cli but instead of typing exit we need to press `ctrl+z` button to get out of it without killing the container.


### Networks

- `docker network ls` - To list out the docker host networks

We can see the bridge, host and none networks over there, all the containers by default are created in the bridge network.

- `docker inspect network bridge` - to inspect the bridge network

it shows the subnets cidr range /16 

#### To check if the two docker container are able to communicate with each other or not.

- by default, `ping` command isn't present as many package are removed to reduce the size of the image.
- hence, we need to install the packages for the command.
- `docker run --dit cont1 ubuntu`
- `docker run --dit cont2 ubutnu`
- `docker exec -it cont1 /bin/bash` > `apt update` > `apt install iputils-ping -y`
- `docker exec -it cont2 /bin/bash` > ...
- `docker inspect network bridge` > ping x.x.x.x 

_Note_: Here, we have noticed that we are able to communicate with ip address but not with the container name


#### To create own network bridge

- `docker network create <bridgeName>` - To create the our own bridge network

#### To create docker image in the custom bridge

`docker run -dit --name cont1 --network=<bridgeName> ubuntu`

_Note:_ Now, we are able to communicate with the ip address and also the container name.

> In default network, the name isn't resolve but in the custom bridge network name is resolved

#### Container Port mapping to Host ports

`docker run -d -p8080:80 --name cont1 nginx`
`docker run -d -p8081:80 --name cont2 httpd`

we can access the nginx/httpd server via public ip with the specified ports.

#### Host Network

`docker run -d -p8080:80 --name cont1 --network=host nginx`

*Note: While using host network we can't map the ports to external ports. Hence we can't run two container using same internal ports* 

We can connect to it by using our Host IP address with the default port

- We use `host network` for the database related containers and it doesn't have ip address
- we use `bridge network` for the applications related containers
- we use `none network` if we doesn't need any networks for the containers.


## Day 4 - 