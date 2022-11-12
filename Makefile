.PHONY: all build clean

all: build

build:
	./v flightos.v -o flightos

clean:
	$(RM) flightos
