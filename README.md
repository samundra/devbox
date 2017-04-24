# PHP Development Box

### Features

##### Editor
- vim

##### Backend Development
- PHP7.0
- php-fpm
- xdebug extension
- git
- postgres9.5 client
- redis
- curl
- supervisor
- nginx

#### Frontend Development
- gulp
- npm
- yarn
- typings

#### Shell Environment
- bash
- zsh
- oh-my-zsh

#### Expose
- 80, 443, 9000

### Create container

> `docker pull samundra/devbox:1.7`

`$ docker run -it --rm -v $(pwd):/vagrant --net={{ network_name }} samundra/devbox:1.7 zsh`

