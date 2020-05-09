# minecraft-tekxit-docker

Dockerfiles to run a minecraft [tekxit](https://www.technicpack.net/modpack/tekxit-3-official-1122.1253751) server.

## Usage

### Setting up the server

```sh
git clone https://github.com/j-brn/minecraft-tekxit-docker.git
cd minecraft-tekxit-docker

# server data will be written to ./data by default. You might want to change the volume before you continue.
# memory limits can be set by changing the environment variables in the compose file.
# if you want to start the JVM with custom args (i.e. GC tuning or similar) you can add them using the JAVA_ADDTIONAL_ARGS environment variable.

docker-compose up
```

The server will now be installed to the data volume. 

### Accessing the console

This image comes with [rcon-cli](https://github.com/itzg/rcon-cli) preinstalled. To enable rcon, open the `server.properties` file in the data
volume and change/add the following lines:

(you can set any password since the rcon port is not exposed by default. If you want to change that, you need to add a port binding docker-compose.yml)

```
enable-rcon=true
rcon.port=25575
rcon.password=foobar
```

Save the file and restart the container. Once the server is restarted you can exec into the contianer and use the rcon-cli tool to access the console.

```sh
docker-compose exec tekxit rcon-cli --host localhost --port 25575 --password foobar
```
