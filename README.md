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


# Run directly from premade image

```bash
docker run -t -d -p 8080:8080 vasilescur/gzweb-rosssh
```