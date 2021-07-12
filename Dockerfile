FROM openjdk:8-jre-alpine

ARG VERSION="0.13.2"

# The user that runs the minecraft server and own all the data
# you may want to change this to match your local user
ENV USER=minecraft
ENV UID=1000

# Memory limits for the java VM that can be overridden via env.
ENV JAVA_XMS=1G
ENV JAVA_XMX=4G
# Additional args that are appended to the end of the java command.
ENV JAVA_ADDITIONAL_ARGS=""

# the tekxit server files are published as .7z archive so we need something to unpack it.
RUN apk add p7zip curl

# add rcon-cli to be able to interact with the console using rcon
RUN curl -sSL https://github.com/itzg/rcon-cli/releases/download/1.4.8/rcon-cli_1.4.8_linux_amd64.tar.gz -o rcon-cli.tar.gz \
    && tar -xzf rcon-cli.tar.gz rcon-cli \
    && mv rcon-cli /usr/local/bin \
    && rm rcon-cli.tar.gz

# add entrypoint
ADD ./scripts/entrypoint.sh /entrypoint
RUN chmod +x /entrypoint

# create a new user to run our minecraft-server
RUN adduser \
    --disabled-password \
    --gecos "" \
    --uid "${UID}" \
    "${USER}"

# declare a directory for the data directory
# survives a container restart
RUN mkdir /tekxit-server && chown -R "${USER}" /tekxit-server

# swicht to the minecraft user since we don't need root at this point
USER ${USER}
WORKDIR /tekxit-server

# download server files
RUN curl -sSL "https://www.tekx.it/downloads/${VERSION}Tekxit3Server.7z" -o tekxit-server.7z

# unpack server files
RUN \
    p7zip -d tekxit-server.7z \
    && mv ${VERSION}Tekxit3Server/* . \
    && rmdir ${VERSION}Tekxit3Server

WORKDIR /data

EXPOSE 25565
EXPOSE 25575
ENTRYPOINT /entrypoint
