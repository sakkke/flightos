module main

import os

struct PacmanConf {
	path       string
	mirrorlist string
}

fn (p PacmanConf) build() string {
	mirrorlist := p.mirrorlist
	return $tmpl('./pacman.conf.txt')
}

fn (p PacmanConf) write() {
	os.write_file(p.path, p.build()) or { panic(err) }
}
