module main

import sakkke.vfzf { FzfPrompt }

struct Installer {
	fzf          FzfPrompt
	provider_map map[string]Provider
mut:
	config_map map[string][]string
}

fn (mut i Installer) configure() {
	original_config_map := i.config_map.clone()
	keys := i.config_map.keys()
	for j := 0; j < keys.len; j++ {
		key := keys[j]
		value := i.config_map[key]
		match value.first() {
			'auto' {
				i.config_map[key] = default_config_map[key]
			}
			'interactive' {
				result := i.fzf.prompt(
					choices: i.provider_map[key].get()
					fzf_options: '--expect=ctrl-l'
				)
				input := result.first()
				output := result[1..]
				match input {
					'ctrl-p' {
						if j == 0 {
							break
						}
						i.config_map[keys[j - 1]] = original_config_map[keys[j - 1]]
						j -= 2
						continue
					}
					else {
						i.config_map[key] = output
					}
				}
			}
			else {
				i.config_map[key] = value
			}
		}
	}
}
