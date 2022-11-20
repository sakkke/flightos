module main

import os

[params]
struct ProviderConfig {
	cmd   string
	desc  string
	multi bool
}

struct Provider {
	cmd   string
	desc  string
	multi bool
}

fn new_provider(c ProviderConfig) &Provider {
	return &Provider{
		cmd: c.cmd
		desc: c.desc
		multi: c.multi
	}
}

fn (p Provider) get() []string {
	result := os.execute(p.cmd)
	if result.exit_code != 0 {
		panic('A command "$p.cmd" returned non-zero exit code: $result.exit_code')
	}
	return result.output.split('\n')
}
