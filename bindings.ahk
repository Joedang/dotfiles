; general key bindings for Windows

; For some reason, this needs to be alone in its own script to be reliable...
;Capslock::Esc ; remap the capslock key to escape

; reload this script
#+c::
    Traytip, 'reloading key bindings', %A_ScriptName%,,
    Reload
return

; close windows with Win+Shift+q
#+q::
    WinClose A
return

; lock the display with Ctrl+Alt+l
^!l::
    DllCall("LockWorkStation")
return

ClipNotify(){
    Traytip, 'copied to clipboard:', %clipboard%,,
}

; open calc in WSL and Windows Terminal instead of the useless Windows calculator app
Launch_App2::
    ; wrap in bash to get the nice readline prompts
    ;Run, wt "C:\WINDOWS\system32\wsl.exe" -d Arch -u joe --cd ~ -- bash -c units -v1
    Run, wt "C:\WINDOWS\system32\wsl.exe" -d Arch -u joe --cd ~ -- units -v1
    ;Run, wt "C:\WINDOWS\system32\wsl.exe" -d Arch -u joe --cd ~ -- calc
return

; copy the date to the clipboard Win+Shift+i
#+i::
    FormatTime, CurrentDateTime,, yyyy-MM-dd
    clipboard=%CurrentDateTime%
    ClipNotify()
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

; super+shift+F9 for full opacity
#+F9::
    WinGet, TransLevel, Transparent, A
    WinSet, Transparent, OFF, A
return

; super+F8 to reduce opacity
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

; Ctrl+Alt+mouseForward to toggle left-mouse on and off
; pressing left-mouse also untoggles by sending a button-up event
^!XButton2::
    if (GetKeyState(LButton))
        SendInput { LButton up }
    else
        SendInput { LButton down }
    return
return
