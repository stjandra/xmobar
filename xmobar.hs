-- Compile this with something like
-- stack ghc -- --make -o $HOME/.local/bin/xmobar xmobar.hs

import Xmobar

config :: Config
config =
  defaultConfig
    { font = "xft:Fira Code:weight=bold:pixelsize=13:antialias=true:hinting=true",
      additionalFonts = ["xft:Font Awesome 6 Free Solid:style=Solid:pixelsize=12"],
      border = NoBorder,
      bgColor = "#2e3440",
      fgColor = "grey",
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
                "#bf616a"
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
                "#bf616a"
              ]
              100,
          Run $ Com "/home/stephen/git/scripts-public/vpn_ip" [] "vpnip" 50,
          Run $ Date "<fn=1>\xf133</fn> %Y-%m-%d %a %H:%M" "date" 100
        ],
      sepChar = "%",
      alignSep = "}{",
      template =
        "%XMonadLog%}\
        \{\
        \<fc=#b48ead>%vpnip%</fc>\
        \<fc=#81a1c1>%cpu%</fc>   \
        \<fc=#81a1c1>%memory%</fc>   \
        \<fc=#81a1c1>%date%</fc> \
        \%_XMONAD_TRAYPAD%"
    }

main :: IO ()
main = xmobar config
