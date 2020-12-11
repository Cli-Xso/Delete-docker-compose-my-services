#!/bin/bash

docker-compose kill  `docker-compose ps -a  | tail -n +3 | awk  '{print $1}'`
docker-compose rm -f  `docker-compose ps -a  | tail -n +3 | awk  '{print $1}'`
rm -fr data/{mysql/*,rabbitmq/*,redis/*}
