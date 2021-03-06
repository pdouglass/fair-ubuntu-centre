#!/bin/sh

gconftool --recursive-unset /desktop

gconftool-2 --type boolean -s /apps/gnome-power-manager/lock/blank_screen false
gconftool-2 --type boolean -s /apps/gnome-power-manager/lock/gnome_keyring_hibernate false
gconftool-2 --type boolean -s /apps/gnome-power-manager/lock/gnome_keyring_suspend false
gconftool-2 --type boolean -s /apps/gnome-power-manager/lock/hibernate false
gconftool-2 --type boolean -s /apps/gnome-power-manager/lock/suspend false
gconftool-2 --type boolean -s /apps/gnome-power-manager/lock_use_screensaver_settings true
gconftool-2 --type boolean -s /apps/gnome-screensaver/lock_enabled false

#gconftool -t string --set /desktop/gnome/background/picture_filename "file:///usr/share/backgrounds/edubuntu_default.png"
#gconftool -t string --set /desktop/gnome/background/primary_color black
#gconftool -t bool --set /desktop/gnome/background/draw_background 1
#gconftool -t string --set /desktop/gnome/background/color_shading_type solid

# Theme
#gconftool -t string --set /desktop/gnome/interface/gtk_theme Ambiance
gconftool -t string --set /apps/metacity/general/theme Ambiance
#gconftool -t string --set /desktop/gnome/interface/icon_theme ubuntu-mono-dark

# Lockdowns
gconftool -t bool --set /desktop/gnome/lockdown/disable_lock_screen 1
gconftool -t int --set /desktop/gnome/peripherals/mouse/cursor_size 36
gconftool -t int --set /desktop/gnome/peripherals/mouse/double_click 600
gconftool -t bool --set /desktop/gnome/sound/event_sounds 0
gconftool -t bool --set /apps/bluetooth-manager/show_icon 0
gconftool -t bool --set /apps/gnome-screensaver/lock_enabled 0
gconftool -t string --set /apps/gnome-screensaver/mode blank-only
gconftool -t int --set /apps/gnome-screensaver/idle_delay 20
gconftool -t bool --set /apps/panel/global/locked_down 1
gconftool -t bool --set /apps/panel/global/disable_lock_screen 1

gconftool -t bool --set /desktop/gnome/lockdown/disable_lock_screen 1
gconftool -t bool --set /desktop/gnome/lockdown/disable_print_setup 1
