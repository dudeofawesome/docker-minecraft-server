# docker-minecraft-server

A Minecraft server Docker image

## Configuration

### Environment variables
- `MINECRAFT_VERSION` **required!**
    This is the version of the Minecraft server you want to run, which must be set.
    Specify a version of Minecraft, like `1.13.2`
    `release` will keep you always up to date, which may mean upgrading before you meant to
    `snapshot` will keep you up to date on the latest snapshot
- `EULA` required to be true!
    default: `false`
    This must be set to true
- `RAM_MAX`
    default: `8G`
    Set this to change the default amount of RAM allocated to the server
    You can read more about the options [here](https://stackoverflow.com/a/14763095/985615)

### Volumes
- `/data` **required!**
    This is where your Minecraft world data will be stored. If you don't map this as a volume, your world data will be lost when the container shuts down!
- `/server-jars`
    This is an optional volume to enable caching a copy of the server jar.

### Ports
- `25565:25565`

### Other recommended options
- `restart:on-failure`
