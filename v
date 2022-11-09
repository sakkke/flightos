#!/bin/sh
docker run \
	--rm \
	-i \
	-v "${LOCAL_WORKSPACE_FOLDER:-$PWD}":/src \
	thevlang/vlang:alpine-dev \
	sh -c "apk add --no-cache -U sudo \
		&& adduser -D -u \"$(id -u)\" vlang \
		&& chown -R vlang:vlang /opt/vlang \
		&& sudo -u vlang v $*"
