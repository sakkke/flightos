.PHONY: all build clean

all: build

build:
	./v -prod flightos.v -o flightos

check:
	./v test .

clean:
	$(RM) flightos
