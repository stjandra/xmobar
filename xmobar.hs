-- Compile this with something like
-- stack ghc -- --make -o $HOME/.local/bin/xmobar xmobar.hs

import Text.Printf (printf)
import Xmobar

data MyTheme = MT
  { myBg :: String,
    myFg :: String,
    myRed :: String,
    myColorDate :: String,
    myColorMemory :: String,
    myColorCpu :: String,
    myColorVpnIp :: String
  }

-- Colors from https://github.com/catppuccin/catppuccin
latteTheme :: MyTheme
latteTheme =
  MT
    { myBg = "#eff1f5",
      myFg = "#4c4f69",
      myRed = "#d20f39",
      myColorDate = "#dc8a78",
      myColorMemory = "#dd7878",
      myColorCpu = "#ea76cb",
      myColorVpnIp = "#e64553"
    }

-- Colors from https://github.com/catppuccin/catppuccin
macchiatoTheme :: MyTheme
macchiatoTheme =
  MT
    { myBg = "#24273a",
      myFg = "#cad3f5",
      myRed = "#ed8796",
      myColorDate = "#f5bde6",
      myColorMemory = "#f5bde6",
      myColorCpu = "#f5bde6",
      myColorVpnIp = "#f5bde6"
    }

-- Colors from https://www.nordtheme.com/
nordTheme :: MyTheme
nordTheme =
  MT
    { myBg = "#2e3440",
      myFg = "#d8dee9",
      myRed = "#bf616a",
      myColorDate = "#81a1c1",
      myColorMemory = "#81a1c1",
      myColorCpu = "#81a1c1",
      myColorVpnIp = "#b48ead"
    }

-- Colors from https://github.com/Binaryify/OneDark-Pro
onedarkTheme :: MyTheme
onedarkTheme =
  MT
    { myBg = "#282c34",
      myFg = "#abb2bf",
      myRed = "#e05561",
      myColorDate = "#42b3c2",
      myColorMemory = "#42b3c2",
      myColorCpu = "#42b3c2",
      myColorVpnIp = "#42b3c2"
    }

-- The following line could be changed by ~/git/scripts-public/change_theme
-- Please be careful when changing
myTheme :: MyTheme
myTheme = macchiatoTheme

myXmobarColor :: String -> String -> String
myXmobarColor color text = printf "<fc=%s>" color ++ text ++ "</fc>"

config :: Config
config =
  defaultConfig
    { font = "xft:Fira Code:weight=bold:pixelsize=13:antialias=true:hinting=true",
      additionalFonts = ["xft:Font Awesome 6 Free Solid:style=Solid:pixelsize=12"],
      border = NoBorder,
      bgColor = myBg myTheme,
      fgColor = myFg myTheme,
      alpha = 255,
      position = TopW L 100,
      textOffset = -1,
      iconOffset = -1,
      lowerOnStart = True,
      pickBroadest = False,
      persistent = False,
      hideOnStart = False,
      iconRoot = ".",
      allDesktops = True,
      overrideRedirect = True,
      commands =
        [ Run XMonadLog,
          Run $ XPropertyLog "_XMONAD_TRAYPAD",
          Run $
            Cpu
              [ "-t",
                "<fn=1>\xf2db</fn> <total>",
                "-S",
                "True",
                "-L",
                "3",
                "-H",
                "50",
                "--high",
                myRed myTheme
              ]
              30,
          Run $
            Memory
              [ "-t",
                "<fn=1>\xf538</fn> <usedratio>",
                "-S",
                "True",
                "-L",
                "0",
                "-H",
                "80",
                "--high",
                myRed myTheme
              ]
              100,
          Run $ Com "/home/stephen/git/scripts-public/vpn_ip" [] "vpnip" 50,
          Run $ Date "<fn=1>\xf133</fn> %Y-%m-%d %a %H:%M" "date" 100
        ],
      sepChar = "%",
      alignSep = "}{",
      template =
        "%XMonadLog%}{"
          ++ myXmobarColor (myColorVpnIp myTheme) "%vpnip%"
          ++ myXmobarColor (myColorCpu myTheme) "%cpu%"
          ++ "   "
          ++ myXmobarColor (myColorMemory myTheme) "%memory%"
          ++ "   "
          ++ myXmobarColor (myColorDate myTheme) "%date%"
          ++ " "
          ++ "%_XMONAD_TRAYPAD%"
    }

main :: IO ()
main = xmobar config
