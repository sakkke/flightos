module main

import os
import regex

enum Kind {
	github
	http
	https
	path
}

struct Url {
	str string
}

fn (u Url) cat(path string) string {
	return u.cmd('cat "$path"')
}

fn (u Url) cmd(cmd string) string {
	result := os.execute(cmd)
	if result.exit_code != 0 {
		panic('A command "$cmd" returned non-zero exit code: $result.exit_code')
	}
	return result.output
}

fn (u Url) curl(url string) string {
	return u.cmd('curl -s "$url"')
}

fn (u Url) get() string {
	match u.kind() {
		.github {
			str := u.str[3..]
			tokens := str.split('/')
			owner := tokens[0]
			repo := tokens[1]
			url := 'https://raw.githubusercontent.com/$owner/$repo/main/setup'
			return u.curl(url)
		}
		.http {
			return u.curl(u.str)
		}
		.https {
			return u.curl(u.str)
		}
		.path {
			return u.cat(u.str)
		}
	}
}

fn (u Url) kind() Kind {
	mut github := regex.regex_opt('^gh:') or { panic(err) }
	if github.matches_string(u.str) {
		return Kind.github
	}
	mut http := regex.regex_opt('^http://') or { panic(err) }
	if http.matches_string(u.str) {
		return Kind.http
	}
	mut https := regex.regex_opt('^https://') or { panic(err) }
	if https.matches_string(u.str) {
		return Kind.https
	}
	return Kind.path
}
