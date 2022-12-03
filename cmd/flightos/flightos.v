module main

import flag
import os
import sakkke.vfzf { new_fzf_prompt }

fn main() {
	mut fp := flag.new_flag_parser(os.args)
	fp.application('flightos')
	fp.version('22.11.17')
	fp.description('The Flight OS installer.')
	fp.skip_executable()
	mut config_map := map[string][]string{}
	config_map['mount_prefix'] = [
		fp.string('mount_prefix', `M`, '/mnt', 'The path to mount directory.'),
	]
	config_map['mirrors'] = fp.string('mirrors', `U`, 'interactive', 'Comma-separated list of mirrors.').split(',')
	config_map['console_keymap'] = [
		fp.string('console-keymap', `k`, 'interactive', 'The console keymap name.'),
	]
	config_map['disk'] = [fp.string('disk', `d`, 'interactive', 'The path to disk.')]
	config_map['disk_label'] = [
		fp.string('disk-label', `l`, 'gpt', 'The name of disk label.'),
	]
	config_map['hostname'] = [
		fp.string('hostname', `h`, 'flightos', 'The hostname.'),
	]
	config_map['installation_mode'] = [
		fp.string('installation-mode', `m`, 'interactive', 'The installation mode.'),
	]
	config_map['locale'] = [
		fp.string('locale', `l`, 'interactive', 'The locale.'),
	]
	config_map['packages'] = fp.string('packages', `p`, 'interactive', 'Comma-separated list of packages.').split(',')
	config_map['root_partition'] = [
		fp.string('root-partition', `r`, 'ROOT', 'The PARTLABEL name of root partition.'),
	]
	config_map['root_partition_fs'] = [
		fp.string('root-partition-fs', `R`, 'ext4', 'The filesystem name of root partition.'),
	]
	config_map['root_partition_end'] = [
		fp.string('root-partition-end', `o`, '100%', 'The filesystem end of root partition.'),
	]
	config_map['efi_system_partition'] = [
		fp.string('efi-system-partition', `e`, 'EFI_SYSTEM', 'The PARTLABEL name of EFI system partition.'),
	]
	config_map['efi_system_partition_fs'] = [
		fp.string('efi-system-partition-fs', `E`, 'fat32', 'The filesystem name of EFI system partition.'),
	]
	config_map['timezone'] = [
		fp.string('timezone', `t`, 'interactive', 'The time zone.'),
	]
	config_map['efi_system_partition_end'] = [
		fp.string('efi-system-partition-end', `y`, '300MiB', 'The filesystem end of EFI system partition.'),
	]
	config_map['efi_system_partition_prefix'] = [
		fp.string('efi-system-partition-prefix', `Y`, '/boot', 'The path that EFI system partition will be mounted.'),
	]
	config_map['system'] = [
		fp.string('system', `s`, 'default', 'The URL to a system setup executable.'),
	]
	fp.finalize()!
	tmp_dir := os.vtmp_dir()
	config := '$tmp_dir/pacman.conf'
	mirrorlist := '$tmp_dir/mirrorlist'
	pacman_conf := PacmanConf{
		path: config
		mirrorlist: mirrorlist
	}
	pacman_conf.write()
	mut installer := Installer{
		config_map: config_map
		fzf: new_fzf_prompt()
		provider_map: {
			'mirrors':           new_provider(
				on_leave: fn (p Provider, i Installer) []string {
					return p.cmd('curl -s "https://archlinux.org/mirrorlist/?country=all&protocol=https&ip_version=4&ip_version=6" | grep "^#Server = " | sed "s/^#Server = //"')
				}
				desc: 'pacman mirrors.'
				multi: true
			)
			'console_keymap':    new_provider(
				on_leave: fn (p Provider, i Installer) []string {
					return p.cmd('localectl list-keymaps --no-pager')
				}
				desc: 'The console keymap name.'
			)
			'installation_mode': new_provider(
				on_leave: fn (p Provider, i Installer) []string {
					return p.cmd('printf "Custom\nFull\n"')
				}
				desc: 'The installation mode.'
			)
			'disk':              new_provider(
				on_leave: fn (p Provider, i Installer) []string {
					return p.cmd('sfdisk -l | grep "^Disk /" | awk "{ s = \\\$2; print substr(s, 1, length(s) - 1) }"')
				}
				desc: 'The path to disk.'
			)
			'packages':          new_provider(
				on_leave: fn [config] (p Provider, i Installer) []string {
					i.mirrorlist()
					return p.cmd('pacman --config "$config" -Siy | grep "^Name            : " | sed "s/^Name            : //"')
				}
				desc: 'List of packages.'
				multi: true
			)
			'timezone':          new_provider(
				on_leave: fn (p Provider, i Installer) []string {
					return p.cmd('timedatectl list-timezones --no-pager')
				}
				desc: 'The time zone.'
			)
			'locale':            new_provider(
				on_leave: fn (p Provider, i Installer) []string {
					return p.cmd('cat /etc/locale.gen | grep "^#[a-z]" | sed "s/^#//"')
				}
				desc: 'The locale.'
			)
		}
		tmp_dir: tmp_dir
	}
	installer.configure()
	installer.run()
	println(installer)
}
