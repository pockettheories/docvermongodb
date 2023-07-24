#!/usr/bin/env bash
docker run --name docvermongodb -it -e mongouri='mongodb://host.docker.internal:27017' -e dbname='cms' -e collname='docs' -e sleeptime=2 docvermongodb
