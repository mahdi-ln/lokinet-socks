# Lokinet socks proxy inside Docker

Run Lokinet inside Docker without much hassle.
Note that this image just downloads, compiles, and starts Lokinet. It has no practical purpose aside being a base on which other containers (like Caddy routed with Lokinet inside Docker) can be built.

## Compiling

**Attention**: you don't need to do this! There's already a pre-built image on [DockerHub](https://hub.docker.com/r/mahdi5/lokinet-socks). You might want to do compile the image by yourself only if the DockerHub one doesn't work on your architecture or you don't trust that image.

After cloning the repository and CD-ing in the correct folder, run:   
`sudo docker build . -t mahdi5/lokinet-socks`

## Running

In case you want to run this image, be aware that because of Docker quirks, you have to give the container the NET_ADMIN privilege, and  share the TUN device.
This probably doesn't work on Windows.

`docker run --name lokinet-socks --publish 1080:1080 --cap-add=NET_ADMIN --device=/dev/net/tun mahdi5/lokinet-socks:latest`

You should see some startup logs when the container is starting.

## Testing

1. docker exec -it lokinet /bin/bash
2. curl http://probably.loki/echo.sh
3. Use `exit` to leave the shell.


## Troubleshooting

**I get an error message saying "`Illegal instruction (core dumped)`"**  
Sorry, you'll have to compile the image by yourself instead of using the DockerHub one. Refer to the "Compiling" section of this README to know how.

**I see an error message/warning in the Lokinet bootstrap, should I worry?**

- Generally, all warns (yellow) can be ignored. The only exception is if keep getting warns that contain [somethingsomething]`.loki has no first hop candidate` after 1:30 mins of runtime. You should consider restarting your container.
- If you get an error saying `Cannot open /dev/net/tun: No such file or directory`, make sure you have included `--cap-add=NET_ADMIN --device=/dev/net/tun` when running `docker run`. This error could also happen when trying to use this container in Windows, where I don't think there's a workaround other than getting a decent OS.


## Known problem
https://github.com/mahdi-ln/lokinet-socks/issues/1

## Law change that protect you from evil sibling
https://www.facebook.com/mahm25/posts/1078633392633275
