# CS2D Dedicated Server in Docker

Counter-Strike 2D is a top-down two dimensional adaptation of the the original Counter-Strike by Valve Software. It has
been made by [Unreal Software](https://cs2d.fandom.com/wiki/Unreal_Software), an one-man developer studio founded by
Peter Schauß; known as DarkCorner or DC on the Internet.

![Counter-Strike 2D Banner](https://raw.githubusercontent.com/LacledesLAN/gamesvr-cs2d/master/Documentation/images/cs2d_banner00.jpg "Counter-Strike 2D Banner")

This repository is maintained by [Laclede's LAN](https://lacledeslan.com). Its contents are intended to be bare-bones
and used as a stock server. For examples of building a customized server from this Docker image browse its related
child-projects [gamesvr-cs2d-freeplay](https://github.com/LacledesLAN/gamesvr-cs2d-freeplay). If any documentation is
unclear or it has any issues please see [CONTRIBUTING.md](./CONTRIBUTING.md).

## Linux x64 (64-bit)

### Run simple interactive server

```shell
docker run -it --net=host lacledeslan/gamesvr-cs2d ./cs2d_dedicated
```

## Getting Started with Game Servers in Docker

[Docker](https://docs.docker.com/) is an open-source project that bundles applications into lightweight, portable,
self-sufficient containers. For a crash course on running Dockerized game servers check out [Using Docker for Game
Servers](https://github.com/LacledesLAN/README.1ST/blob/master/GameServers/DockerAndGameServers.md). For tips, tricks,
and recommended tools for working with Laclede's LAN Dockerized game server repos see the guide for [Working with our
Game Server Repos](https://github.com/LacledesLAN/README.1ST/blob/master/GameServers/WorkingWithOurRepos.md). You can
also browse all of our other Dockerized game servers: [Laclede's LAN Game Servers
Directory](https://github.com/LacledesLAN/README.1ST/tree/master/GameServers).
