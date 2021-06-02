#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#archey3
alias suspend='systemctl suspend'
alias rangers='urxvtc -name ranger -e ranger'
alias ls='ls --color=auto -la --group-directories-first'
#alias prime='DRI_PRIME=1'
alias archnews='/etc/profile.d/arch-rss.sh'
# Gentoo (/etc/bash/bashrc)
if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
    PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi


export EDITOR=/usr/bin/vim
force_color_prompt=yes
export ANDROID_HOME=/mnt/Storage/Android
export ANDROID_SDK_HOME=/mnt/Storage/Android
export ANDROID_ADV_HOME=/mnt/Storage/Android/.android/avd

	unset sq_color
# ==== Ruby =====
#PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"






