#!/bin/bash

cmdName="dAll"

if [ "$1" == "" ]
then
	echo "Are you sure you want to remove all containers? (Y/N)"
	read -n1 ans
	if [ "$ans" == "y" ] || [ "$ans" == "Y" ]
	then
		echo ""
		dockerContainers1=$(docker container ls --all | awk '{print $1}')
		toDelete="CONTAINER"
		dockerContainers2=${dockerContainers1#$toDelete}
		docker container rm $dockerContainers2
	fi
else
	if [ $# -gt 2 ];
	then
		printf "Invalid argument. Try \n./$cmdName.sh\nRemove all containers\n\n./$cmdName.sh <image>\nRemove all conatiners of <image>\n\n$./$cmdName.sh -e <image>\nRemove all containers except for containers with <image>" 

	else
		mapfile -t imageArr < <(docker container ls --all | awk '{print $2}')
		mapfile -t dockerContainersArr < <(docker container ls --all | awk '{print $1}')
		#echo "${dockerContainersArr[@]}"

		if [ "$1" == "-e" ]
		then
			shift
			delExcept=$1
			for i in "${!imageArr[@]}"
			do
				if [ "${imageArr[i]}" == "$delExcept" ]
				then
					unset dockerContainersArr[i]
				fi
			done
			unset dockerContainersArr[0] #remove the string "CONTAINER"
			if [ ${#dockerContainersArr[@]} -eq 0 ]
			then
				echo "No containers to remove"
			else
				dockerConatinersToDel=$( IFS=$' '; echo "${dockerContainersArr[*]}" )
				docker container rm $dockerConatinersToDel
			fi
		else
			del=$1
			dockerContainersToDel=""
			for i in "${!imageArr[@]}"
			do
				if [ "${imageArr[i]}" == "$del" ]
				then
					dockerContainersToDel="$dockerContainersToDel ${dockerContainersArr[i]}"
				fi
			done
			if [ "$dockerContainersToDel" == "" ]
			then 
				echo "No containers to remove"
			else
				docker container rm $dockerContainersToDel
			fi
		fi
	fi
fi

echo ""
docker container ls --all

