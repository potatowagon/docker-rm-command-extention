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
                read -r -a dockerContainersArr <<< "$dockerContainers1"
	
		if [ "$1" == "-e" ]
		then
			shift
			delExcept=$1
                	for i in "${!imageArr[@]}"
			do
				if [ "${imageArr[i]}" == "$delExcept" ]
				then
					unset "dockerContainersArr[i]"
				fi
			done
			unset "dockerContainerArr[0]" #remove the string "CONTAINER"
			dockerConatinersToDel=$( IFS=$" "; echo "${dockerContainersArr[*]}" )
			docker container rm $dockerConatinerToDel
		elif
		        del=$1
			dockerContainersToDel=""
			for i in "${!imageArr[@]}"
			do
				if [ "${imageArr[i]}" == "$del" ]
				then
					dockerContainersToDel="$dockerConatinersToDel ${dockerContainersArr[i]}"
				fi
			done
			docker container rm $dockerContainersToDel
		fi
	fi
fi
				
