import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig(additionalKeys)
-- We need these for the status bar, xmobar
import XMonad.Hooks.DynamicLog -- system state
import XMonad.Hooks.SetWMName -- Window name in status bar
import XMonad.Hooks.ManageDocks -- Status bar not tiled over
import XMonad.Util.Run(spawnPipe) -- Send data to status bar
import System.IO -- send data to status bar
import XMonad.ManageHook


myManagementHooks :: [ManageHook]
myManagementHooks = [
  resource =? "stalonetray" --> doIgnore
  ]


main = do
xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
xmonad $ defaultConfig
      { manageHook = manageDocks <+> manageHook defaultConfig <+> composeAll myManagementHooks
      , layoutHook = avoidStruts $ layoutHook defaultConfig
      , modMask = mod1Mask     -- Rebind Mod to the Windows key
      , logHook = dynamicLogWithPP xmobarPP
           { ppOutput = hPutStrLn xmproc
           , ppTitle = xmobarColor "blue" "" . shorten 0
           , ppLayout = const "" -- to disable the layout info on xmobar
           }
     , startupHook = do
         spawn "~/.xmonad/autostart"
      } `additionalKeys`
        [
          ((mod1Mask, xK_s), sendMessage ToggleStruts)
      	, ((0,0x1008ff12), spawn "amixer set Master toggle && amixer set Speaker unmute && amixer set Headphone unmute")
      	, ((0,0x1008ff13), spawn "amixer set Master 2+")
      	, ((0,0x1008ff11), spawn "amixer set Master 2-")
        , ((mod4Mask, xK_l), spawn "slock")
        ]
      --  `additionalKeys`
      --   [ ((mod1Mask, xK_t), spawn "lxterminal")
      --   , ((mod1Mask, xK_f), spawn "firefox")
      --   , ((mod1Mask, xK_g), spawn "google-chrome")
      --   , ((mod1Mask, xK_n), spawn "nautilus --no-desktop")
      --   ]
