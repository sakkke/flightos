module main

import os
import sakkke.vfzf { FzfPrompt }
import time

const base_packages = [
	'base',
	'efibootmgr',
	'grub',
	'linux',
	'linux-firmware',
	'networkmanager',
]

struct Installer {
	fzf          FzfPrompt
	provider_map map[string]Provider
mut:
	config_map map[string][]string
}

fn (i Installer) bootloader() {
	cmd := [
		'arch-chroot',
		i.config_map['mount_prefix'].first(),
		'grub-install',
		'--target=x86_64-efi',
		'--efi-directory=/boot',
		'--bootloader-id=GRUB',
		'&&',
		'arch-chroot',
		i.config_map['mount_prefix'].first(),
		'grub-mkconfig',
		'-o',
		'/boot/grub/grub.cfg',
	].join(' ')
	result := os.system(cmd)
	if result != 0 {
		panic('A command "$cmd" returned non-zero exit code: $result')
	}
}

fn (i Installer) cmd(s string) int {
	result := os.system(s)
	if result != 0 {
		panic('A command "$s" returned non-zero exit code: $result')
	}
	return result
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
				mut fzf_options := ['--header="' + provider.desc + '"', '--expect=ctrl-n,ctrl-p']
				if provider.multi {
					fzf_options << '--multi'
				}
				result := i.fzf.prompt(
					choices: provider.get()
					fzf_options: fzf_options.join(' ')
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
	fs_cmd := fn [i] (s string) string {
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
	esp_cmd := fs_cmd(i.config_map['efi_system_partition_fs'].first())
	esp_result := os.system(esp_cmd)
	if esp_result != 0 {
		panic('A command "$esp_cmd" returned non-zero exit code: $esp_result')
	}
	rp_cmd := fs_cmd(i.config_map['root_partition_fs'].first())
	rp_result := os.system(rp_cmd)
	if rp_result != 0 {
		panic('A command "$rp_cmd" returned non-zero exit code: $rp_result')
	}
}

fn (i Installer) fstab() {
	cmd := 'genfstab -t PARTUUID ' + i.config_map['mount_prefix'].first() + ' >> ' +
		i.config_map['mount_prefix'].first() + '/etc/fstab'
	result := os.system(cmd)
	if result != 0 {
		panic('A command "$cmd" returned non-zero exit code: $result')
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
	result := os.system(cmd)
	if result != 0 {
		panic('A command "$cmd" returned non-zero exit code: $result')
	}
	for {
		if os.exists('/dev/disk/by-partlabel/' + i.config_map['efi_system_partition'].first())
			&& os.exists('/dev/disk/by-partlabel/' + i.config_map['root_partition'].first()) {
			break
		}
		time.sleep(1 * time.second)
	}
}

fn (i Installer) localization() {
	cmd := [
		'arch-chroot',
		i.config_map['mount_prefix'].first(),
		'sed',
		'-i',
		r'"s/^#\(' + i.config_map['locale'].first() + r'\)$/\1/"',
		'/etc/locale.gen',
		'&&',
		'arch-chroot',
		i.config_map['mount_prefix'].first(),
		'locale-gen',
		'&&',
		'echo',
		'LANG="' + i.config_map['locale'].first().split(' ').first() + '"',
		'|',
		'arch-chroot',
		i.config_map['mount_prefix'].first(),
		'tee',
		'/etc/locale.conf',
		'>',
		'/dev/null',
		'2>&1',
		'&&',
		'echo',
		'KEYMAP="' + i.config_map['console_keymap'].first() + '"',
		'|',
		'arch-chroot',
		i.config_map['mount_prefix'].first(),
		'tee',
		'/etc/vconsole.conf',
		'>',
		'/dev/null',
		'2>&1',
	].join(' ')
	result := os.system(cmd)
	if result != 0 {
		panic('A command "$cmd" returned non-zero exit code: $result')
	}
}

fn (i Installer) mirrorlist() {
	mirrorlist := '/etc/pacman.d/mirrorlist'
	i.cmd('echo -n > "$mirrorlist"')
	for mirror in i.config_map['mirrors'] {
		i.cmd('echo "Server = $mirror" >> "$mirrorlist"')
	}
}

fn (i Installer) mount() {
	cmd := [
		'mount',
		'--mkdir',
		'/dev/disk/by-partlabel/"' + i.config_map['root_partition'].first() + '"',
		'"' + i.config_map['mount_prefix'].first() + '"',
		'&&',
		'mount',
		'--mkdir',
		'/dev/disk/by-partlabel/"' + i.config_map['efi_system_partition'].first() + '"',
		'"' + i.config_map['mount_prefix'].first() +
			i.config_map['efi_system_partition_prefix'].first() + '"',
	].join(' ')
	result := os.system(cmd)
	if result != 0 {
		panic('A command "$cmd" returned non-zero exit code: $result')
	}
}

fn (i Installer) network() {
	cmd := [
		'echo',
		'"' + i.config_map['hostname'].first() + '"',
		'|',
		'arch-chroot',
		i.config_map['mount_prefix'].first(),
		'tee',
		'/etc/hostname',
		'>',
		'/dev/null',
		'2>&1',
		'&&',
		'arch-chroot',
		i.config_map['mount_prefix'].first(),
		'systemctl enable NetworkManager.service',
	].join(' ')
	result := os.system(cmd)
	if result != 0 {
		panic('A command "$cmd" returned non-zero exit code: $result')
	}
}

fn (i Installer) pacstrap() {
	cmd := 'pacstrap -K "' + i.config_map['mount_prefix'].first() + '" ' + base_packages.join(' ') +
		' ' + i.config_map['packages'].join(' ')
	result := os.system(cmd)
	if result != 0 {
		panic('A command "$cmd" returned non-zero exit code: $result')
	}
}

fn (i Installer) root() {
	cmd := [
		'echo',
		'root:flightos',
		'|',
		'arch-chroot',
		i.config_map['mount_prefix'].first(),
		'chpasswd',
	].join(' ')
	result := os.system(cmd)
	if result != 0 {
		panic('A command "$cmd" returned non-zero exit code: $result')
	}
}

fn (i Installer) run() {
	match i.config_map['installation_mode'].first() {
		'Custom' {
			i.mirrorlist()
			i.custom_partition()
			i.fs()
			i.mount()
			i.pacstrap()
			i.fstab()
			i.timezone()
			i.localization()
			i.network()
			i.root()
			i.system()
			i.bootloader()
			i.unmount()
			i.success()
		}
		'Full' {
			i.mirrorlist()
			i.full_partition()
			i.fs()
			i.mount()
			i.pacstrap()
			i.fstab()
			i.timezone()
			i.localization()
			i.network()
			i.root()
			i.system()
			i.bootloader()
			i.unmount()
			i.success()
		}
		else {
			panic('Install mode "' + i.config_map['installation_mode'].first() + '" does not exist.')
		}
	}
}

fn (i Installer) success() {
	println('Installation complete!')
}

fn (i Installer) system() {
	s := i.config_map['system'].first()
	if s == 'default' {
		return
	}
	url := Url{s}
	dir := os.vtmp_dir()
	setup := '$dir/setup'
	os.write_file(setup, url.get()) or { panic(err) }
	os.chmod(setup, 0o700) or { panic(err) }
	i.cmd(setup)
}

fn (i Installer) timezone() {
	cmd := [
		'arch-chroot',
		i.config_map['mount_prefix'].first(),
		'ln',
		'-sf',
		'/usr/share/zoneinfo/"' + i.config_map['timezone'].first() + '"',
		'/etc/localtime',
		'&&',
		'arch-chroot',
		i.config_map['mount_prefix'].first(),
		'hwclock',
		'--systohc',
	].join(' ')
	result := os.system(cmd)
	if result != 0 {
		panic('A command "$cmd" returned non-zero exit code: $result')
	}
}

fn (i Installer) unmount() {
	cmd := 'umount -R "' + i.config_map['mount_prefix'].first() + '"'
	result := os.system(cmd)
	if result != 0 {
		panic('A command "$cmd" returned non-zero exit code: $result')
	}
}
