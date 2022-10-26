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

	RELEASE_PATH=$HOME_PATH/eosc_$FOLDER_NAME
	echo "Getting latest version from github..."
	cd ${CURRENT_PATH}
	git archive -o $FOLDER_NAME-v${WORSICA_VERSION}.zip development
	echo "Extract to ${RELEASE_PATH}..."
	unzip -o $FOLDER_NAME-v${WORSICA_VERSION}.zip -d ${RELEASE_PATH}
	rm $FOLDER_NAME-v${WORSICA_VERSION}.zip

	WORSICA_RELEASE_VERSION=$(cat $RELEASE_PATH/WORSICA_VERSION)
	echo "Release version: ${WORSICA_RELEASE_VERSION}"
	cd ${RELEASE_PATH}
	#echo -e "worsica_increment_version.sh
	#worsica_add_tag.sh
	#worsica_launch_release_public.sh" >> .gitignore
	git add --all && git commit -m "Version v${WORSICA_RELEASE_VERSION}" && git push origin main
	git tag -a ${WORSICA_RELEASE_VERSION} -m "Version v${WORSICA_RELEASE_VERSION}" && git push --tags
	cd ${CURRENT_PATH}
	echo "Done!"
fi