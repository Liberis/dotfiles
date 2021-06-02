#/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#barM&
#cvlc --play-and-exit computeropen.WAV &
picom &
#(conky | while read LINE; do xsetroot -name "$LINE"; done) &
feh --bg-scale ~/pics/sierra.jpg &
urxvtd &
#
slstatus &
setxkbmap -option grp:alt_shift_toggle "us,gr" &
#setxkbmap -option terminate:ctrl_alt_bksp &amp;
#eval `cat ~/.fehbg` &amp;
#numlockx &amp;
#xscreensaver -no-splash &amp;
# Dzen &amp; conky
# (sleep 15s &amp;&amp; conky | dzen2 -x '500' -e '' -fg '#dcdcdc' -bg
# '#3f3f3f' \
# -w '650' -ta r -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*' -p )
# &amp;
 # Start dwm
# exec ck-launch-session ~/Scripts/dwm-start.sh
#exec xmonad
exec dwm
#exec awesome
