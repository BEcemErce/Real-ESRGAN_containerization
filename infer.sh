#!/bin/sh

docker pull beerce/real_esrgan:v1
docker run --rm -d -it --platform linux/amd64 --name cont-realesrgan  --mount type=bind,src=$1,target=/Real-ESRGAN/inputs_local beerce/real_esrgan:v1