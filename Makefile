.PHONY: all build clean

all: build

build:
	./v-wrapper -prod -o flightos .

check:
	./v-wraooer test .

clean:
	$(RM) flightos
