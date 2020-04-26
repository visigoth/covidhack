#!/bin/sh
docker run \
       --rm \
       -it \
       --mount type=bind,source="$(pwd)"/notebooks,target=/notebooks \
       --mount type=bind,source="$(pwd)"/python,target=/python-modules,readonly \
       --mount type=bind,source="$(pwd)"/data,target=/data \
       -p 8888:8888 \
       eternann:latest \
       bash -lic "cd /notebooks && jupyter notebook --allow-root --ip=0.0.0.0 --notebook-dir=/notebooks"
