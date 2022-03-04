# Lokinet inside Docker

Run Lokinet inside Docker without much hassle.
Note that this image just downloads, compiles, and starts Lokinet. It has no practical purpose aside being a base on which other containers (like Caddy routed with Lokinet inside Docker) can be built.

## Compiling

**Attention**: you don't need to do this! There's already a pre-built image on [DockerHub](https://hub.docker.com/r/massiveboxe/lokinet). You might want to do compile the image by yourself only if the DockerHub one doesn't work on your architecture or you don't trust that image.

After cloning the repository and CD-ing in the correct folder, run:   
`sudo docker build . -t massiveboxe/lokinet`

## Running

In case you want to run this image, be aware that because of Docker quirks, you have to give the container the NET_ADMIN privilege, and  share the TUN device.
This probably doesn't work on Windows.
docker stop lokinet 
docker rm lokinet 
docker run --name lokinet --publish 3128:3128 --cap-add=NET_ADMIN --device=/dev/net/tun lokinet:latest 

You should see some startup logs when the container is starting.

## Testing

docker exec -it lokinet /bin/bash -c "lokinet-vpn --up --exit exit-arda.loki"
2. Use `apt-get install curl -y` to install cURL
curl http://probably.loki/echo.sh
4. Use `exit` to leave the shell.

xite.loki


## Troubleshooting

**I get an error message saying "`Illegal instruction (core dumped)`"**  
Sorry, you'll have to compile the image by yourself instead of using the DockerHub one. Refer to the "Compiling" section of this README to know how.

**I see an error message/warning in the Lokinet bootstrap, should I worry?**

- Generally, all warns (yellow) can be ignored. The only exception is if keep getting warns that contain [somethingsomething]`.loki has no first hop candidate` after 1:30 mins of runtime. You should consider restarting your container.
- If you get an error saying `Cannot open /dev/net/tun: No such file or directory`, make sure you have included `--cap-add=NET_ADMIN --device=/dev/net/tun` when running `docker run`. This error could also happen when trying to use this container in Windows, where I don't think there's a workaround other than getting a decent OS.

## Support, Licensing, etc.

For support, licensing information, etcetera take a look at the [main README.](https://codeberg.org/massivebox/lokinet-docker/src/branch/main/README.md)
