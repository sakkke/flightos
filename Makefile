.PHONY: all build clean

all: build

build:
	./v-build -prod -o flightos .

check:
	./v-build test .

clean:
	$(RM) flightos
