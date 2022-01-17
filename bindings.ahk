; general key bindings for Windows

Capslock::Esc ; remap the capslock key to escape

; close windows with Win+Shift+q
#+q::
    WinClose A
return

; lock the display with Ctrl+Alt+l
^!l::
    DllCall("LockWorkStation")
return

; fullscreen a window with Win+f
#f::Send {F11} ; It would be nice to actually control the active window instead of remapping like this, but oh well...

; remove annoying window properties with Win+Shift+f
#+f::
    WinSet, AlwaysOnTop, Off, A
    WinSet, Enable, , A
    WinActivate, A
    WinSet, Redraw, , A
return

; adjust transparency up and down with Win+F9 and Win+F8
#F9::
    WinGet, TransLevel, Transparent, A
    if (TransLevel = OFF) {
        TransLevel := 255
    }
    newTrans := TransLevel+25
    if (newTrans > 255){
        newTrans := "OFF"
    }
    WinSet, Transparent, %newTrans%, A
return
#+F9::
    WinGet, TransLevel, Transparent, A
    WinSet, Transparent, OFF, A
return
#F8::
    WinGet, TransLevel, Transparent, A
    if (TransLevel = OFF) {
        TransLevel := 255
    }
    newTrans := TransLevel-25
    if (newTrans < 0){
        newTrans := 0
    }
    WinSet, Transparent, %newTrans%, A
return
