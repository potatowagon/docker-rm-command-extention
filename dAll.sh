#!/bin/bash

cmdName="dAll"

dockerContainers1=$(docker container ls -all | awk '{print $1}')
toDelete="CONTAINER"
dockerContainers2=${dockerContainers1#$toDelete}
   
if [ "$1" == "" ]
then    
    docker container rm $dockerContainers2
else
	if [ $# > 2 ]
	then
		echo "Invalid argument. Try \n./$cmdName.sh\nRemove all containers\n\n./$cmdName.sh <image>\nRemove all conatiners of <image>\n\n$./$cmdName.sh -e <image>\nRemove all containers except for containers with <image>" 
	else
                imageString=$(docker container ls -all | awk '{print $2}')
                IFS=" " read -r -a imageArr <<< "$imageString"
                read -r -a dockerContainersArr1 <<< "$dockerContainers1"
	
		if [ "$1" == "-e" ]
			shift
			delExcept=$1
                	for i in imageArr 
