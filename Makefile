.PHONY: all build clean

all: build

build:
	./v -prod flightos.v -o flightos

clean:
	$(RM) flightos
