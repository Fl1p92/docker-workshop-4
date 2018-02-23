# Intro to Docker Compose

Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application’s services. Then, with a single command, you create and start all the services from your configuration.
[Detail](https://docs.docker.com/compose/overview/)

## Example
> **Note:** We use official python image. [Detail](https://hub.docker.com/_/python/)

```yaml
version: "3" # (1)
services:
  example: # (3)
    image: python:3 # (2)
  example2:
    image: python:2
```

**1.** Compose file format version. Last version 3.6 [Detail](https://docs.docker.com/compose/compose-file/).
**2.** Name image and tag. Default use [hub.docker.com](http://hub.docker.com). Example for custom host: `hub.ds.inprogress.rocks/djangostars-site/django`
**3.** The name of our service. We can use it as a dns name inside other containers described in our file.
```bash
```


# Intro to Dockerfile
Dockerfile defines what goes on in the environment inside your container. Access to resources like networking interfaces and disk drives is virtualized inside this environment, which is isolated from the rest of your system, so you need to map ports to the outside world, and be specific about what files you want to “copy in” to that environment. However, after doing that, you can expect that the build of your app defined in this Dockerfile behaves exactly the same wherever it runs.
[Detail](https://docs.docker.com/engine/reference/builder/)

## FROM

The FROM instruction initializes a new build stage and sets the Base Image for subsequent instructions.
```
FROM <image> [AS <name>]
```
Or
```
FROM <image>[:<tag>] [AS <name>]
```
Or
```
FROM <image>[@<digest>] [AS <name>]
```
Detail: https://docs.docker.com/engine/reference/builder/#from
