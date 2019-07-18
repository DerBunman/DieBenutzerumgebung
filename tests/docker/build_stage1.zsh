#!/usr/bin/env zsh
cd "${0:h}/stage1" || exit 1

# download and install apt packages and then clone git repo
docker build -f Dockerfile_bionic -t derbunman/diebenutzerumgebung:bionic-staged $(pwd) \
	&& docker push derbunman/diebenutzerumgebung:bionic-staged

docker build -f Dockerfile_disco -t derbunman/diebenutzerumgebung:disco-staged $(pwd) \
	&& docker push derbunman/diebenutzerumgebung:disco-staged

docker build -f Dockerfile_stable -t derbunman/diebenutzerumgebung:stable-staged $(pwd) \
	&& docker push derbunman/diebenutzerumgebung:stable-staged

docker build -f Dockerfile_testing -t derbunman/diebenutzerumgebung:testing-staged $(pwd) \
	&& docker push derbunman/diebenutzerumgebung:testing-staged


