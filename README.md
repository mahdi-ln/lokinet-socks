# Lokinet-socks inside Docker

Run Lokinet inside Docker without much hassle.
Note that this image just downloads, compiles, and starts Lokinet. It has no practical purpose aside being a base on which other containers (like Caddy routed with Lokinet inside Docker) can be built.

## Compiling

After cloning the repository and CD-ing in the correct folder, run:   
`sudo docker build . -t mahdi/lokinet-socks`

## Running

In case you want to run this image, be aware that because of Docker quirks, you have to give the container the NET_ADMIN privilege, and  share the TUN device.
This probably doesn't work on Windows.

docker run --name lokinet-socks --publish 1080:1080 --cap-add=NET_ADMIN --device=/dev/net/tun mahdi/lokinet-socks:latest 

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

## Support, Licensing, etc.

For support, licensing information, etcetera take a look at the [main README.](https://codeberg.org/massivebox/lokinet-docker/src/branch/main/README.md)
