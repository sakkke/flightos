#!/bin/sh
docker run \
	--rm \
	-i \
	-v "${LOCAL_WORKSPACE_FOLDER:-$PWD}":/src \
	thevlang/vlang:buster-dev \
	sh -c "cd /src \
		&& apt-get update \
		&& apt-get --no-install-recommends -y install sudo \
		&& useradd -m -u \"$(id -u)\" vlang \
		&& chown -R vlang:vlang /opt/vlang \
		&& sudo -u vlang v $*"
