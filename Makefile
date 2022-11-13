.PHONY: all build clean

all: build

build:
	./v-wrapper -prod -o flightos .

check:
	./v-wrapper test .

clean:
	$(RM) flightos
