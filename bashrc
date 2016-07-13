# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Put your fun stuff here.
use_color=true
# TMUX
if which tmux >/dev/null 2>&1; then
#if not inside a tmux session, and if no session is started, start a new session
	test -z "$TMUX" && (tmux new -t 0\;neww\; set-option destroy-unattached || tmux new)
	fi


#Let bash notice resize changes
shopt -s checkwinsize

#Disable completion when the input buffer is empty
shopt -s no_empty_cmd_completion

#Enable history appending instead of overiwriting when exiting
shopt -s histappend

case ${TERM} in
		rxvt*)
			PS1='\[\033]0;\u@\h:\w\007\]'
			;;
		tmux*)
			trap 'echo -ne "\033]0;$BASH_COMMAND\007"' DEBUG
			;;
		*)
			unset PS1
			;;
esac

if [[ ${EUID} == 0 ]] ; then
		
		PS1+='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
		PS1+='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '

fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'


	


