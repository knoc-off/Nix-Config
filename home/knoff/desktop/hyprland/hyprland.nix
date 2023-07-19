{ config, inputs, lib, pkgs, ... }:
let
  inherit (config.colorscheme) colors;
  #jq = "${pkgs.jq}/bin/jq";
  fuzzel = "${pkgs.fuzzel}/bin/fuzzel";
in
{
  programs = {
    bash = {
      initExtra = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
           exec  Hyprland
        fi
      '';
    };
  };
  systemd.user.targets.hyprland-session.Unit.Wants =
    [ "xdg-desktop-autostart.target" ];

  imports = [
    inputs.hyprland.homeManagerModules.default
    {
      wayland.windowManager.hyprland = {
        enable = true;
        systemdIntegration = true;
        #nvidiaPatches = false;
        extraConfig = ''

          # See https://wiki.hyprland.org/Configuring/Monitors/
          #monitor=,preferred,auto,auto


          # See https://wiki.hyprland.org/Configuring/Keywords/ for more

          # Execute your favorite apps at launch
          # exec-once = waybar & hyprpaper & firefox

          # Source a file (multi-file configs)
          # source = ~/.config/hypr/myColors.conf

          # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
          input {
            kb_layout = us
            kb_variant =
            kb_model =
            kb_options =
            kb_rules =

            follow_mouse = 1

            touchpad {
              natural_scroll = true
            }

            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
          }

          general {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            gaps_in = 2
            gaps_out = 4
            border_size = 2
            col.active_border =  0xff${colors.base04}
            col.inactive_border = 0xff${colors.base02}

            #cursor_inactive_timeout=4
            layout = dwindle
          }

          decoration {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            rounding = 5
            blur=true
            blur_size=5
            blur_passes=3
            blur_ignore_opacity=true
            blur_new_optimizations = true

            inactive_opacity=0.9

            drop_shadow = true
            shadow_range = 2
            shadow_render_power = 3
            col.shadow = 0xff${colors.base01}
            }



#          animations {
#            enabled=true
#
#            bezier=easein,0.11, 0, 0.5, 0
#            bezier=easeout,0.5, 1, 0.89, 1
#            bezier=easeinout,0.45, 0, 0.55, 1
#
#            animation=windowsIn,1,3,easeout,slide
#            animation=windowsOut,1,3,easein,slide
#            animation=windowsMove,1,3,easeout
#
#            animation=fadeIn,1,3,easeout
#            animation=fadeOut,1,3,easein
#            animation=fadeSwitch,1,3,easeout
#            animation=fadeShadow,1,3,easeout
#            animation=fadeDim,1,3,easeout
#            animation=border,1,3,easeout
#
#            animation=workspaces,1,2,easeout,slide
#          }

          animations {
            enabled = true

            # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

            bezier = myBezier, 0.05, 0.9, 0.1, 1.05

            animation = windows, 1, 7, myBezier
            animation = windowsOut, 1, 7, default, popin 80%
            animation = border, 1, 10, default
            #animation = borderangle, 1, 8, default
            animation = fade, 1, 7, default
            animation = workspaces, 1, 6, default
          }

          dwindle {
            # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
            pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = true # you probably want this
          }

          master {
            # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
            new_is_master = true
          }

          gestures {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = true
          }

          # Example per-device config
          # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
          device:epic mouse V1 {
            sensitivity = -0.5
          }

          windowrule=float,^mako$
          windowrule=pin,^mako$

          # Example windowrule v1
          # windowrule = float, ^(kitty)$
          # Example windowrule v2
          # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
          # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


          # See https://wiki.hyprland.org/Configuring/Keywords/ for more
          $mainMod = SUPER

          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          bind = $mainMod, SPACE, exec, ${fuzzel} -b ${colors.base02}DD -t ${colors.base06}DD -m ${colors.base04}DD -C ${colors.base05}DD -s ${colors.base03}DD -S ${colors.base07}DD -M ${colors.base07}DD
          bind = $mainMod, C, killactive,
          bind = $mainMod, E, exit,
          bind = $mainMod, V, togglefloating,
          #bind = $mainMod, R, exec, wofi --show drun
          bind = $mainMod, P, pseudo, # dwindle
          bind = $mainMod, S, togglesplit, # dwindle
          bind = $mainMod, F, fullscreen, 0
          #bind = $mainMod, T, tile,

          # What does this do
          bind=SUPER,g,togglegroup
          bind=SUPER,apostrophe,changegroupactive,f
          bind=SUPERSHIFT,apostrophe,changegroupactive,b

          bind=SUPER,minus,splitratio,-0.25
          bind=SUPERSHIFT,minus,splitratio,-0.3333333

          bind=SUPER,equal,splitratio,0.25
          bind=SUPERSHIFT,equal,splitratio,0.3333333


          binde=$mainMod SHIFT,right,resizeactive,25 0
          binde=$mainMod SHIFT,right,resizeactive,25 0
          binde=$mainMod SHIFT,left,resizeactive,-25 0
          binde=$mainMod SHIFT,up,resizeactive,0 -25
          binde=$mainMod SHIFT,down,resizeactive,0 25

          # sudo light -A 10 # ADD
          # sudo light -O 10 # SUB

          binde=, XF86MonBrightnessDown, exec, sudo light -A 10
          bindl=, XF86MonBrightnessDown, exec, sudo light -O 10

          # Example volume button that allows press and hold
          binde=, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+

          # Example volume button that will activate even while an input inhibitor is active
          bindl=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-


          # ~~~~~~~~~~~


          # will switch to a submap called resize
          bind = $mainMod, R, submap, resize

          # will start a submap called "resize"
          submap=resize

          # sets repeatable binds for resizing the active window
          binde=,right,resizeactive,10 0
          binde=,left,resizeactive,-10 0
          binde=,up,resizeactive,0 -10
          binde=,down,resizeactive,0 10

          # use reset to go back to the global submap
          bind=,escape,submap,reset

          # will reset the submap, meaning end the current one and return to the global one
          submap=reset

          # ~~~~ Window Specific Rules ~~~~~




          # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

          # ~~~~ Enviroment Variables ~~~~~
          env = GDK_BACKEND,wayland,x11
          env = QT_QPA_PLATFORM,wayland;xcb
          env = SDL_VIDEODRIVER,wayland
          env = CLUTTER_BACKEND,wayland
          env = XDG_CURRENT_DESKTOP,Hyprland
          env = XDG_SESSION_TYPE,wayland
          env = XDG_SESSION_DESKTOP,Hyprland
          env = QT_AUTO_SCREEN_SCALE_FACTOR,1
          #env = GTK_THEME,Breeze-Dark
          #env = QT_STYLE_OVERRIDE,Breeze-Dark
          env = XCURSOR_THEME,Future-Cursors
          env = XCURSOR_SIZE,24
          env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
          #exec-once=gsettings set org.gnome.desktop.interface cursor-theme 'Future-cursors'
          #exec-once=hyprctl setcursor Future-cursors 24
          monitor=eDP-1,highres,auto,1.0


          # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


          # Move focus with mainMod + arrow keys
          bind = $mainMod ALT, left, movewindow, l
          bind = $mainMod ALT, right, movewindow, r
          bind = $mainMod ALT, up, movewindow, u
          bind = $mainMod ALT, down, movewindow, d

          # Move focus with mainMod + arrow keys
          bind = $mainMod, h, movefocus, l
          bind = $mainMod, l, movefocus, r
          bind = $mainMod, k, movefocus, u
          bind = $mainMod, j, movefocus, d

          # Move focus with mainMod + arrow keys
          bind = $mainMod, left, movefocus, l
          bind = $mainMod, right, movefocus, r
          bind = $mainMod, up, movefocus, u
          bind = $mainMod, down, movefocus, d

          # Switch workspaces with mainMod + [0-9]
          bind = $mainMod, 1, workspace, 1
          bind = $mainMod, 2, workspace, 2
          bind = $mainMod, 3, workspace, 3
          bind = $mainMod, 4, workspace, 4
          bind = $mainMod, 5, workspace, 5
          bind = $mainMod, 6, workspace, 6
          bind = $mainMod, 7, workspace, 7
          bind = $mainMod, 8, workspace, 8
          bind = $mainMod, 9, workspace, 9
          bind = $mainMod, 0, workspace, 10


          # Volume
          binde=, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
          binde=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          binde=, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          bind = $mainMod SHIFT, 1, movetoworkspace, 1
          bind = $mainMod SHIFT, 2, movetoworkspace, 2
          bind = $mainMod SHIFT, 3, movetoworkspace, 3
          bind = $mainMod SHIFT, 4, movetoworkspace, 4
          bind = $mainMod SHIFT, 5, movetoworkspace, 5
          bind = $mainMod SHIFT, 6, movetoworkspace, 6
          bind = $mainMod SHIFT, 7, movetoworkspace, 7
          bind = $mainMod SHIFT, 8, movetoworkspace, 8
          bind = $mainMod SHIFT, 9, movetoworkspace, 9
          bind = $mainMod SHIFT, 0, movetoworkspace, 10

          # Scroll through existing workspaces with mainMod + scroll
          bind = $mainMod, mouse_down, workspace, e+1
          bind = $mainMod, mouse_up, workspace, e-1

          # Move/resize windows with mainMod + LMB/RMB and dragging
          bindm = $mainMod, mouse:272, movewindow
          bindm = $mainMod, mouse:273, resizewindow

          # Startup
          exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          exec-once=hyprpaper
          #exec-once=swayidle -w

          # Keyboard controls (brightness, media, sound, etc)
          bind=,XF86MonBrightnessUp,exec,light -A 10
          bind=,XF86MonBrightnessDown,exec,light -U 10

          # Screenshots
          bind=,Print,exec,grimblast --notify copy output
          bind=SHIFT,Print,exec,grimblast --notify copy active
          bind=CONTROL,Print,exec,grimblast --notify copy screen
          bind=SUPER,Print,exec,grimblast --notify copy window
          bind=ALT,Print,exec,grimblast --notify copy area


        '';

      };
    }
  ];
}
