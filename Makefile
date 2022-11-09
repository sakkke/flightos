.PHONY: all build clean

all: build

build:
	./v -freestanding flightos.v -o flightos

clean:
	$(RM) flightos
