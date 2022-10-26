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

	cd ${CURRENT_PATH}
	git add $CURRENT_PATH/WORSICA_VERSION && git commit -m "Updated tag to v${WORSICA_VERSION}" && git push origin development && git push github development
	git tag -a ${WORSICA_VERSION} -m "Version v${WORSICA_VERSION}" && git push --tags
	cd ${CURRENT_PATH}
	echo "Done!"
fi