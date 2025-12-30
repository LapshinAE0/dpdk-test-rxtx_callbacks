#!/bin/bash
docker build -t dpdk-test .
docker run -it --rm dpdk-test:latest bash