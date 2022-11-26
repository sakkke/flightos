module main

import os

[params]
struct ProviderConfig {
	on_leave fn (p Provider, i Installer) []string
	desc     string
	multi    bool
}

struct Provider {
	on_leave fn (p Provider, i Installer) []string
	desc     string
	multi    bool
}

fn new_provider(c ProviderConfig) Provider {
	return Provider{
		on_leave: c.on_leave
		desc: c.desc
		multi: c.multi
	}
}

fn (p Provider) cmd(s string) []string {
	result := os.execute(s)
	if result.exit_code != 0 {
		panic('A command "$s" returned non-zero exit code: $result.exit_code')
	}
	return result.output.split('\n')
}

fn (p Provider) get(i Installer) []string {
	return p.on_leave(p, i)
}
