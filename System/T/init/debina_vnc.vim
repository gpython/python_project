apt install gnome-core ibus vnc4server gnome-desktop-environment x-window-system-core gnome-icon-theme
apt install install xfce4 xfce4-goodies

reboot

vim /etc/vnc.conf
$geometry = "1280x1024";
$localhost = "no";
#1;

vim /etc/gdm3/daemon.conf
[security]
AllowRoot=true

vim /etc/pam.d/gdm-password
#auth	required	pam_succeed_if.so user != root quiet_success

systemctl status gdm3
systemctl restart gdm3

su tom

vncpasswd 
Password:
Verify:
Would you like to enter a view-only password (y/n)? n

vim  ~/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
exec /etc/X11/xinit/xinitrc
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
#x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
gnome-terminal &
gnome-session &
#xterm &

#启动
vncserver -localhost no -geometry 1280x1024 -depth 24
#关闭
vncserver -kill :1
