module main

import flag
import os
import sakkke.vfzf { new_fzf_prompt }

fn main() {
	mut fp := flag.new_flag_parser(os.args)
	fp.application('flightos')
	fp.version('2022.11.3')
	fp.description('The Flight OS installer.')
	fp.skip_executable()
	mut config_map := map[string][]string{}
	config_map['console_keymap'] = [
		fp.string('console-keymap', `k`, 'interactive', 'The console keymap name.'),
	]
	config_map['disk'] = [fp.string('disk', `d`, 'interactive', 'The path to disk.')]
	fp.finalize()!
	mut installer := Installer{
		config_map: config_map
		fzf: new_fzf_prompt()
		provider_map: {
			'console_keymap': Provider{'ls /usr/share/kbd/keymaps/**/*.map.gz | xargs -n1 basename -s .map.gz'}
			'disk':           Provider{'sfdisk -l | grep "^Disk /" | awk "{ s = \$2; print substr(s, 1, length(s) - 1) }"'}
		}
	}
	installer.configure()
	println(installer)
}
