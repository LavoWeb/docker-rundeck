#!/bin/bash

APP="rundeck"
CD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function build_ {
	docker build -t $APP .
}

function run_ {
	docker stop $(docker ps -a | grep $APP | cut -d' ' -f1);
	docker rm $(docker ps -a | grep $APP | cut -d' ' -f1);

    mkdir -p volume/etc
    mkdir -p volume/rundeck
    mkdir -p volume/lib
    mkdir -p volume/log

	docker run --name $APP -p 4443:4443 \
        -v $CD/volume/etc:/etc/rundeck \
        -v $CD/volume/rundeck:/var/rundeck \
        -v $CD/volume/lib:/var/lib/rundeck \
        -v $CD/volume/log:/var/log/rundeck \
        -i -t $APP;
}

function restart_ {
	docker restart $APP
}

function logs_ {
	docker logs -f $APP
}

function bash_ {
	docker exec -it $APP bash
}

function stop_ {
	docker stop $APP
}

help="build : build or rebuild the DockerFile\n
run : the container after building\n
logs : follow the container logs\n
bash : get a prompt in the container\n
stop : stop the container\n
restart : the container if is already running"
case $1 in
	"build" )
		build_ ;;
	"run" )
		run_ ;;
	"restart" )
		restart_ ;;
	"logs" )
		logs_ ;;
	"bash" )
		bash_ ;;
	"stop" )
		stop_ ;;
	*)
		echo -e $help ;;		
esac
