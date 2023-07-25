#!/usr/bin/env bash
docker run --name docvermongodb -it -e mongouri='mongodb://host.docker.internal:27017' -e dbname='test' -e collname='contacts' -e sleeptime=2 docvermongodb
