.PHONY: all build clean

all: build

build:
	./v-build -prod . -o flightos

check:
	./v test .

clean:
	$(RM) flightos
