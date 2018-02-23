# Install or upgrade Docker
[Mac](https://docs.docker.com/docker-for-mac/install/)  
[Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)  
[Debian](https://docs.docker.com/install/linux/docker-ce/debian/)

# Intro to Docker Compose
Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application’s services. Then, with a single command, you create and start all the services from your configuration.

[Detail](https://docs.docker.com/compose/overview/).

## Example
> **Note:** We use official python image. [Detail](https://hub.docker.com/_/python/).
For a complete list of official images, please click on the [link](https://hub.docker.com/explore/).

### Minimal docker-compose.yml
```yaml
version: "3" # (1)
services:
  example: # (2)
    image: python:3 # (3)https://docs.docker.com/compose/reference/build/
```

**1.** Compose file format version. Last version 3.6. [Detail](https://docs.docker.com/compose/compose-file/).

**2.** The name of our service. We can use it as a dns name inside other containers described in our file.

**3.** Name image and tag (or digest). If no tag is specified, `latest` will be used.  
An image can have multiple tags. Example: `3.6.4`, `3.6`, `3`, `latest`.  
The tag is unique and can only be assigned to one image (within the unique name of the image). If the tag is assigned, it will be untagged from the current image and assigned to new.  
Default use [hub.docker.com](http://hub.docker.com) as [registry](https://docs.docker.com/registry/introduction/). Example use custom host: `hub.ds.inprogress.rocks/djangostars-site/django:v4.0.15-14-gb7cc56e`

# Intro to Dockerfile
Dockerfile defines what goes on in the environment inside your container. Access to resources like networking interfaces and disk drives is virtualized inside this environment, which is isolated from the rest of your system, so you need to map ports to the outside world, and be specific about what files you want to “copy in” to that environment. However, after doing that, you can expect that the build of your app defined in this Dockerfile behaves exactly the same wherever it runs.

[Detail](https://docs.docker.com/engine/reference/builder/).

## Basic commands

### FROM
The FROM instruction initializes a new build stage and sets the Base Image for subsequent instructions.

[Detail](https://docs.docker.com/engine/reference/builder/#from).

### RUN
The RUN instruction will execute any commands in a new layer on top of the current image and commit the results. The resulting committed image will be used for the next step in the Dockerfile.

[Detail](https://docs.docker.com/engine/reference/builder/#run).

### CMD
The main purpose of a CMD is to provide defaults for an executing container. There can only be one CMD instruction in a Dockerfile. If you list more than one CMD then only the last CMD will take effect.

[Detail](https://docs.docker.com/engine/reference/builder/#cmd)

### EXPOSE
The EXPOSE instruction informs Docker that the container listens on the specified network ports at runtime. You can specify whether the port listens on TCP or UDP, and the default is TCP if the protocol is not specified.
> **Note:** It does not open ports.  
If you do not specify this command, then in our case nothing will change

[Detail](https://docs.docker.com/engine/reference/builder/#expose)

### ENV
The ENV instruction sets the environment variable `<key>` to the value `<value>`. This value will be in the environment of all “descendant” Dockerfile commands and can be replaced inline in many as well.
```
ENV <key> <value>
ENV <key>=<value> ...
```

[Detail](https://docs.docker.com/engine/reference/builder/#env)

### ADD
The ADD instruction copies new files, directories or remote file URLs from `<src>` and adds them to the filesystem of the image at the path `<dest>`.
```
ADD requirements.txt /usr/local/code/requirements.txt
```
or you can copy the folder 
```
ADD . /usr/local/docker
```
[Detail](https://docs.docker.com/engine/reference/builder/#add)


### COPY
The COPY instruction copies new files or directories from `<src>` and adds them to the filesystem of the container at the path `<dest>`.
[Detail](https://docs.docker.com/engine/reference/builder/#copy)

### ENTRYPOINT
An ENTRYPOINT allows you to configure a container that will run as an executable.
[Detail](https://docs.docker.com/engine/reference/builder/#entrypoint)

[Understand how CMD and ENTRYPOINT interact](https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact)

### VOLUME
The VOLUME instruction creates a mount point with the specified name and marks it as holding externally mounted volumes from native host or other containers. 
[Detail](https://docs.docker.com/engine/reference/builder/#volume)


In the beginning, we will setup your containers to development in the docker

# Please, create Dockerfile for Django application
You need to create an image for our application in which all the dependencies from the `requirements.txt` file will be installed.
> **Note:** The commands you need FROM, ADD and RUN

# Let's build our image 
Build our image using the [build](https://docs.docker.com/compose/compose-file/#build) section in the `docker-compose.yml`.
## Example:
```yaml
version: "3"
services:
  django:
    image: chat-django:dev
    build: .
```
or
```yaml
version: "3"
services:
  django:
    image: chat-django:dev
    build:
      context: .
      dockerfile: path/to/Dockerfile
```

Use command [build](https://docs.docker.com/compose/reference/build/) for running build process:
```bash
$ docker-compose build
```
or 
```bash
$ docker-compose build <name-our-service-name>
```
> **Note:** When the value supplied is a relative path, it is interpreted as relative to the location of the Compose file. This directory is also the build context that is sent to the Docker daemon.

> **Warning:** Add files and folders to the [.dockerignore](https://docs.docker.com/engine/reference/builder/#dockerignore-file) file if you do not need them in the context of the assembly (especially if these files take up a lot of space).

## Example for .dockeringore
```
.git/
*.pyc
```

# Make sure that the image was built and assigned to the correct tag
In order to see our image, use the command [image](https://docs.docker.com/engine/reference/commandline/image_ls/).
```bash
$ docker image ls
```

# Add services for postgres and redis in the docker-compote.yml
To do this, use the official image [postgres](https://hub.docker.com/_/postgres/) and [redis](https://hub.docker.com/_/redis/).
Change the default settings (user, database name and password) for Postgres container.
> **Note:** To do this, find out what environment variables you need to change.
> Add section [environment](https://docs.docker.com/compose/environment-variables/) to docker-compose.yml

> **Note:** We do not need to expose ports because we will use these services inside the network docker

# Check services postgres and redis
Start the services postgres and redis use command [up](https://docs.docker.com/compose/reference/up/) for docker-compose.
> **Note:** Only services postgres and redis

# Update environment for django service
Add in environment section specify settings that depend on Postgres and Redis

# Add section volumes for django service
We collected our image, but we need to add the code of our project at the start of the container.
To do this, the docker compose have section [volumes](https://docs.docker.com/compose/compose-file/#volumes).

## Example:
```yaml
version: "3"
services:
  django:
    image: chat-django:dev
    volumes:
      '.:/usr/local/code' # (1)
```

**1.** Mount the current folder inside the container.
> **Note:** Don't use the folder name in the current directory. Docker compose will think that this is the name of volume
## Do not do this
```yaml
version: "3"
services:
  django:
    image: chat-django:dev
    volumes:
      'name_folder:/usr/local/code' # (1)
```

# Add depends for services
Since our services are related and before we running the container for django we need to running postgres and redis, we need to describe this in docker-compose.yml
> **Note:** Use section [depends_on](https://docs.docker.com/compose/compose-file/#depends_on) for this.

# Add the command that will be used to start the container
We need to set the default command in the Dockerfile
> **Note:** Use command CMD

> **Note:** Our command `python manage.py runserver 0.0.0.0:8000`

# Publish ports for the django service
Make the port from the container locally available
> **Note:** Use section [ports](https://docs.docker.com/compose/compose-file/#ports)

> **Warning** Use 80 port for local. The application is configured for this port to work with WebSockets.

# Up all services and check how they work
Use command `up` for `docker-compose`
