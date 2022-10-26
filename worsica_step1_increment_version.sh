HOME_PATH=/home/centos

if  [[ -z $1 ]] ; then
	echo "Folder parameter: please provide worsica folder name"
	exit 1
else
	FOLDER_NAME=$1
	CURRENT_PATH=$HOME_PATH/$FOLDER_NAME
	if [[ -z $(echo $(cat $CURRENT_PATH/WORSICA_VERSION)) ]]; then
		echo 'ERROR: No WORSICA_VERSION file set. Create this file and set version number (0.9.0)'
		exit 1
	fi
	WORSICA_VERSION=$(cat $CURRENT_PATH/WORSICA_VERSION)
	echo "Actual version: ${WORSICA_VERSION}"

	if  [[ -z $2 ]] ; then
		echo "Increment parameter: must be either --increment-major, --increment-minor, --increment-patch"
		exit 1
	else
		if [[ $2 == '--increment-major' ]] ; then
			WORSICA_NEXT_VERSION=$(echo ${WORSICA_VERSION} | awk -F. -v OFS=. '{$1++;$2=0;$3=0;print}')
			echo "Next version: ${WORSICA_NEXT_VERSION}"
			echo $WORSICA_NEXT_VERSION > $CURRENT_PATH/WORSICA_VERSION
			WORSICA_VERSION=$(cat $CURRENT_PATH/WORSICA_VERSION)
			echo "Finished! Updated to version: ${WORSICA_VERSION}"
		elif [[ $2 == '--increment-minor' ]] ; then
			WORSICA_NEXT_VERSION=$(echo ${WORSICA_VERSION} | awk -F. -v OFS=. '{$2++;$3=0;print}')
			echo "Next version: ${WORSICA_NEXT_VERSION}"
			echo $WORSICA_NEXT_VERSION > $CURRENT_PATH/WORSICA_VERSION
			WORSICA_VERSION=$(cat $CURRENT_PATH/WORSICA_VERSION)
			echo "Finished! Updated to version: ${WORSICA_VERSION}"
		elif [[ $2 == '--increment-patch' ]] ; then
			WORSICA_NEXT_VERSION=$(echo ${WORSICA_VERSION} | awk -F. -v OFS=. '{$3++;print}')
			echo "Next version: ${WORSICA_NEXT_VERSION}"
			echo $WORSICA_NEXT_VERSION > $CURRENT_PATH/WORSICA_VERSION
			WORSICA_VERSION=$(cat $CURRENT_PATH/WORSICA_VERSION)
			echo "Finished! Updated to version: ${WORSICA_VERSION}"
		else
			echo "Invalid argument $2"
			exit 1
		fi
	fi
fi