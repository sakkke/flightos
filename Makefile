.PHONY: all build clean

all: build

build:
	./v-build -prod flightos.v -o flightos

check:
	./v test .

clean:
	$(RM) flightos
