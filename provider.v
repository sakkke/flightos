module main

import os

struct Provider {
	cmd   string
	desc  string = ''
	multi bool   = false
}

fn (p Provider) get() []string {
	result := os.execute(p.cmd)
	if result.exit_code != 0 {
		panic('A command "$p.cmd" returned non-zero exit code: $result.exit_code')
	}
	return result.output.split('\n')
}
