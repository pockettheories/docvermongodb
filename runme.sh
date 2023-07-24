#!/usr/bin/env bash
docker run --name approxIncrement -it -e mongouri='mongodb://host.docker.internal:27017' -e dbname='approx' -e collname='coin' -e sleeptime=2 coincount
