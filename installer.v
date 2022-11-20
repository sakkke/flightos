module main

import os
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
				provider := i.provider_map[key]
				fzf_options := ['--expect=ctrl-n,ctrl-p']
				if provider.multi {
					fzf_options << '--multi'
				}
				result := i.fzf.prompt(
					choices: provider.get()
					fzf_options: fzf_options.split(' ')
				)
				input := result.first()
				output := result[1..]
				match input {
					'ctrl-n' {
						i.config_map[key] = original_config_map[key]
					}
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

fn (i Installer) custom_partition() {
	for {
		os.system('parted "' + i.config_map['disk'].first() + '"')
		if os.exists('/dev/disk/by-partlabel/' + i.config_map['efi_system_partition'].first())
			&& os.exists('/dev/disk/by-partlabel/' + i.config_map['root_partition'].first()) {
			break
		}
	}
}

fn (i Installer) fs() {
	fs_cmd := fn (s string) {
		return match s {
			'ext4' {
				'mkfs.ext4 -F /dev/disk/by-partlabel/"' + i.config_map['root_partition'].first() +
					'"'
			}
			'fat32' {
				'mkfs.fat -F 32 /dev/disk/by-partlabel/"' +
					i.config_map['efi_system_partition'].first() + '"'
			}
			else {
				panic('Filesystem "$s" is not supported.')
			}
		}
	}
	cmd := fs_cmd(i.config_map['efi_system_partition_fs'].first())
	result := os.execute(cmd)
	if result.exit_code != 0 {
		panic('A command "$cmd" returned non-zero exit code: $result.exit_code')
	}
}

fn (i Installer) full_partition() {
	cmd := [
		'parted',
		'-s',
		'"' + i.config_map['disk'].first() + '"',
		'mklabel',
		'"' + i.config_map['disk_label'].first() + '"',
		'mkpart',
		'"' + i.config_map['efi_system_partition'].first() + '"',
		'"' + i.config_map['efi_system_partition_fs'].first() + '"',
		'0%',
		'"' + i.config_map['efi_system_partition_end'].first() + '"',
		'mkpart',
		'"' + i.config_map['root_partition'].first() + '"',
		'"' + i.config_map['root_partition_fs'].first() + '"',
		'"' + i.config_map['efi_system_partition_end'].first() + '"',
		'"' + i.config_map['root_partition_end'].first() + '"',
	].join(' ')
	result := os.execute(cmd)
	if result.exit_code != 0 {
		panic('A command "$cmd" returned non-zero exit code: $result.exit_code')
	}
}

fn (i Installer) mount() {
	cmd := [
		'mount',
		'--mkdir',
		'/dev/disk/by-partlabel/"' + i.config_map['root_partition'].first() + '"',
		'"' + i.config_map['mount_prefix'] + '"',
		'&&',
		'mount',
		'--mkdir',
		'/dev/disk/by-partlabel/"' + i.config_map['efi_system_partition'].first() + '"',
		'"' + i.config_map['mount_prefix'].first() +
			i.config_map['efi_system_partition_prefix'].first() + '"',
	].join(' ')
	result := os.execute(cmd)
	if result.exit_code != 0 {
		panic('A command "$cmd" returned non-zero exit code: $result.exit_code')
	}
}

fn (i Installer) pacstrap() {
	cmd := 'pacstrap -K "' + i.config_map['mount_prefix'].first() +
		'" base linux linux-firmware ${i.config_map['packages'].join(' ')}'
	result := os.execute(cmd)
}

fn (i Installer) run() {
	match i.config_map['installation_mode'].first() {
		'Custom' {
			i.custom_partition()
			i.fs()
		}
		'Full' {
			i.full_partition()
			i.fs()
		}
		else {
			panic('Install mode "' + i.config_map['installation_mode'].first() + '" does not exist.')
		}
	}
}

fn (i Installer) setup() {
	cmd := 'pacman -Sy'
	result := os.execute(cmd)
	if result.exit_code != 0 {
		panic('A command "$cmd" returned non-zero exit code: $result.exit_code')
	}
}
