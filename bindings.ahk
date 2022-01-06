; general key bindings for Windows

; close windows with Win+Shift+q
#+q::
    WinClose A
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
