eval "$(starship init bash)"


# Aliases
# Manage NixOS system configurations and updates
alias config='sudo vim /etc/nixos/configuration.nix'
alias hconfig='sudo vim /etc/nixos/hardware-configuration.nix'
#alias update='sudo nixos-rebuild switch'

alias q='exit'
alias cat='bat'

# Shortcuts to directories
alias villa='cd /home/adam/villa/'
alias projects='cd /home/adam/villa/projects'
alias villacode='cd /home/adam/villa/projects/code'

# Recording screen shortcuts
export RECORDING_EXT=mp4
export SCREEN_RECORDING_PATH=~/Videos/screen-recording.$RECORDING_EXT
export POST_RECORDING_PATH=~/Videos/post-recording.$RECORDING_EXT
export SAVED_RECORDINGS_PATH=~/Videos/saved_recordings
export CLIPS_PATH=~/Videos/clips

# Record screen and default output and input
alias record='gpu-screen-recorder -w portal -restore-portal-session yes -f 60 -o $SCREEN_RECORDING_PATH -a "default_output" -a "default_input"'

function neofetch {
	echo "NEOFETCH IS EOL USING FASTFETCH INSTEAD!!!!!!!!!!!!!!!!!!!!!!*******************"
	fastfetch
}

function clip { 
	# usage: clip <filepath> <starttime> <finishtime>
	# eg. clip screen-recording.mp4 00:01:30 00:02:30.9
	# take clip from 1 minute and 30 seconds to 2 minutes and 30.9 seconds
	current_datetime=`date +"%Y%m%d%H%M%S%Z"`
	ffmpeg -i $1 -ss $2 -to $3 -map 0 -c copy $CLIPS_PATH/clip_$current_datetime.$RECORDING_EXT
}

function post { 
	# usage: post <filepath>
	# eg. post screen-recording.mp4
	ffmpeg -y -i $1 -filter_complex "[0:a:0]volume=0.75[a0];[0:a:1]volume=12.5[a1];[a0][a1]amerge=inputs=2[aout]" -map 0:v -map "[aout]" -c:v copy -c:a aac -b:a 192k $POST_RECORDING_PATH
}

function backuprecording {
	current_datetime=`date +"%Y%m%d%H%M%S%Z"`
	cp $SCREEN_RECORDING_PATH $SAVED_RECORDINGS_PATH/recording_$current_datetime.$RECORDING_EXT
}

function extracttrack2 {
	# usage: extractaudio <filepath>
	# extracts audio track 2 (normally my mic) this is for transcribing after and using AI to find possible clip moments
	#
	echo "NOT IMPLEMENTED"
}


# Quick Logs
function log {
	text=""
	# collect input arguments
	for var in "$@"
	do
		text+="$var "
	done
	# append to log file
	current_date=`date +"%Y.%m.%d %H:%M:%S %Z"`
	echo "$current_date| $text" >> ~/my.log
}

# Audio Logging
export AUDIO_LOGS_DIR=~/Audio/audio_logs
function logmic {
	current_datetime=`date +"%Y%m%d%H%M%S%Z"`
	if [ ! -d $AUDIO_LOGS_DIR ]; then
		echo "Directory does not exist. Creating: ~/Audio/audio_logs/" 
		mkdir -p $AUDIO_LOGS_DIR
	fi
	arecord -f cd -r 44100 -c 1 $AUDIO_LOGS_DIR/audio_log_$current_datetime.wav
}

function transcribe {
	# usage: transcribe_audio_log audio_log.wav
	whisper $1 --language English --fp16 False
}

# Bitcoin Systemd shortcut
# Eg. bitcoin start | stop | status
function bitcoin {
		if [ "$1" = "status" ]; then
				systemctl $1 bitcoind-bitcoind
		else
				sudo systemctl $1 bitcoind-bitcoind
		fi
}

# Nix env
function install {
	nix-env -iA nixos.$1
}
alias installed='nix-env -q'
function uninstall {
	nix-env --uninstall $1
}
alias generations='nix-env --list-generations'
function collect-garbage {
	sudo nix-collect-garbage -d
}

# Nix repl
alias repl="nix repl '<nixpkgs>'"

function mc {
	# mark (p)cap $count
	# this is for marking a pcap in wireshark
	# main idea is that the number of pings
	# mean how bad the network issue is/was
	# 1 ping means something happened momentarily
	# lots of pings means something was seriously wrong with the
	# network connection
	ping -c $1 192.168.1.1
}

function backupnix {
	cp /etc/nixos/configuration.nix ~/my-nix/hosts/desktop/
	cp /etc/nixos/hardware-configuration.nix ~/my-nix/hosts/desktop/
	cp ~/.bashrc ~/my-nix/users/adam/dotfiles/
	cp ~/.profile ~/my-nix/users/adam/dotfiles/
}

function update {
	echo "flatpak update"
	flatpak update
	echo "sudo nixos-rebuild switch"
	sudo nixos-rebuild switch
	source ~/.bashrc
	backupnix
	echo "Backed up configs to ~/my-nix | REMEMBER TO 'git push' to GitHub"
}

# Check network connection
function checknet {
	echo $(date)

	echo -e "\nLayer 1 - The Physical Layer (Cable & NIC)\n"

	echo "Cable & NIC - Is the link UP?"
	ip -s link show enp74s0
	echo -e "\n--------\n"
	echo "NIC settings - Is the speed and duplex correct?"
	sudo ethtool enp74s0

	echo -e "\nLayer 2 - The Data Link Layer (MAC Addresses)\n"

	echo "ARP Table - Is the default gateway REACHABLE?"
	ip neighbor show

	echo -e "\nLayer 3 - The Network Layer (IP Addresses, Routes, DNS)\n"

	echo "IP Address Assignment - Do we have a VALID IP?"
	ip -br address show enp74s0
	echo -e "\n--------\n"
	echo "Routing Table - Is there a default route?"
	ip route show
	echo -e "\n--------\n"
	echo "Ping Gateway - Is there packet loss and is the ping-time good?"
	# Comment out the pings for speed of report
	ping -c 3 192.168.1.1
	echo -e "\n--------\n"
	echo "Ping Internet - Is there packet loss and is the ping-time good?"
	ping -c 3 1.1.1.1
	echo -e "\n--------\n"
	echo "Ping FQDN - Does the DNS work?"
	ping -c 3 www.google.com.au
	echo -e "\n--------\n"
	echo "NSLOOKUP - Is the DNS server address correct?"
	nslookup www.google.com.au
	echo -e "\n--------\n"
	echo "Host file check - Is there an IP address here different to nslookup's?"
	cat /etc/hosts
	
	echo -e "\nLayer 4 - The Transport Layer (Ports, TCP, UDP)\n"
	echo "Open Listening Ports - What process is using what port?"
	ss -tunlp4

	echo -e "\n--------\n"

	echo -e "\nSystem Logs\n"
	echo "dmesg - kernal ring buffer (time in seconds since boot)"
	dmesg | rg r8169
	
	echo -e "\n\n\nEND OF REPORT"

	
}

# Reset Ethernet (LAN) network interface if the network stops working
function fixnet {
	set -x
	sudo ip link set enp74s0 down
	sudo systemctl restart NetworkManager.service
	sleep 2
	sudo ip link set enp74s0 up
	set +x
}

# Upgrade the entire system
function upgrade {
	sudo nix-channel --update
	sudo nixos-rebuild switch --upgrade
	backupnix
	echo "Backed up configs to ~/my-nix | REMEMBER TO 'git push' to GitHub"
}


# Docker shortcuts
alias d='docker'

# Better file listings
alias l='exa -lah'
alias ll='exa -al'
alias ls='exa --group-directories-first'
alias sl=exa

# NeoVim Shortcut
alias nv="nvim"

# Edit this file from anywhere
#alias bashrc='vim ~/.bashrc'
function bashrc {
	nvim ~/.bashrc
	source ~/.bashrc
	backupnix
}
# Update terminal bash config
alias ubsh='source ~/.bashrc'

# copy to clipboard, ctrl+c, ctrl+shift+c eg. $ cat file.txt | copy
alias copy='xclip -selection clipboard' 
# paste from clipboard, ctrl+v, ctrl+shift+v $ paste > clipboard.txt
alias paste='xclip -selection clipboard -o' 
# paste from highlight, middle click, shift+insert, $ select > highlighted.txt
alias select='xclip -selection primary -o' 

# Create directory and change directory to that
function take {
	mkdir -p $1
	cd $1
}

# Quic notes
function note {
	drafts="drafts.txt"
	echo "date: $(date)" >> $HOME/$drafts
	echo "$@" >> $HOME/$drafts
	echo "" >> $HOME/$drafts
}

#Repair NixOS
alias repair='sudo nixos-rebuild switch --repair'

#Verify Nix Store
alias verify='sudo nix-store --verify --check-contents --repair'


