#!/bin/sh
docker run \
	--rm \
	-it \
	-v "$LOCAL_WORKSPACE_FOLDER":/src \
	thevlang/vlang:alpine-dev \
	sh -c "apk add --no-cache -U sudo \
		&& adduser -D vlang \
		&& chown -R vlang:vlang /opt/vlang \
		&& sudo -u vlang v $*"
