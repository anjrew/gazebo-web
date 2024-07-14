# Gazebo Web

Gazebo Web is a web front-end for Gazebo. It allows you to run and interact with Gazebo simulations from a web browser. Gazebo Web is a thin client with a web server that communicates with the Gazebo server using a RESTful interface.

## Build

To build the gazebo web from the docker file run the following command:

```bash
docker build -t gazebo-web .
```

## Run

To run the gazebo web from the docker image run the following command:

```bash
docker run -it --rm -p 8080:8080 gazebo-web
```


## Run directly from premade image

```bash
docker run -t -d -p 8080:8080 vasilescur/gzweb-rosssh
```

## Environment Variables

Gazebo uses a number of environment variables to locate files, and set up communications between the server and clients. Default values that work for most cases are compiled in. This means you don't need to set any variables.

Here are the variables:

- GAZEBO_MODEL_PATH: colon-separated set of directories where Gazebo will search for models
- GAZEBO_RESOURCE_PATH: colon-separated set of directories where Gazebo will search for other resources such as world and media files.
- GAZEBO_MASTER_URI: URI of the Gazebo master. This specifies the IP and port where the server will be started and tells the clients where to connect to.
- GAZEBO_PLUGIN_PATH: colon-separated set of directories where Gazebo will search for the plugin shared libraries at runtime.
- GAZEBO_MODEL_DATABASE_URI: URI of the online model database where Gazebo will download models from.