#if AltDragToggle && GetKeyState("F16","P") && !(WinActive("ahk_exe vmconnect.exe") || WinActive("ahk_exe vmware.exe"))
    MButton::
        CoordMode, Mouse
        MouseGetPos, , , win
        WinGetClass,aClass,ahk_id %win%
        if (aClass = "WorkerW" or aClass = "Windows.UI.Core.CoreWindow" or aClass = "Shell_TrayWnd")
            Return
        WinClose, ahk_id %win%
    return

    LButton::
        CoordMode, Mouse ; Switch to screen/absolute coordinates.
        MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
        ; except Windows desktop and windows basic UI ( like windows search and control panel)
        WinGetClass,aClass,ahk_id %EWD_MouseWin%
        if (aClass = "WorkerW" or aClass = "Windows.UI.Core.CoreWindow" or aClass = "Shell_TrayWnd")
            Return
        ; Only if the window isn't maximized
        CheckAndResetMaximizedWindow(aClass)
        WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%

        WinGet, winState, MinMax, ahk_id %EWD_MouseWin%
        if winState = 0
            WinActivate, ahk_id %EWD_MouseWin%
        SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
    return

    EWD_WatchMouse:
        GetKeyState, EWD_LButtonState, LButton, P
        if EWD_LButtonState = U ; Button has been released, so drag is complete.
        {
            SetTimer, EWD_WatchMouse, off
            return
        }

        GetKeyState, EWD_EscapeState, Escape, P
        if EWD_EscapeState = D ; Escape has been pressed, so drag is cancelled.
        {
            SetTimer, EWD_WatchMouse, off
            WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
            return
        }

        ; Otherwise, reposition the window to match the change in mouse coordinates
        ; caused by the user having dragged the mouse:
        CoordMode, Mouse
        MouseGetPos, EWD_MouseX, EWD_MouseY
        WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
        SetWinDelay, -1 ; Makes the below move faster/smoother.
        WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
        EWD_MouseStartX := EWD_MouseX ; Update for the next timer-call to this subroutine.
        EWD_MouseStartY := EWD_MouseY
    return

    ResetWindowToNormal(winId) {
        WinGet, winState, MinMax, ahk_id %winId%
        if winState = 1 ; 1 means maximized
            WinRestore, ahk_id %winId%
    }

    CheckAndResetMaximizedWindow(appClass) {
        WinGet, winList, List, ahk_class %appClass%
        MouseGetPos, , , mouseWinId  ; 获取鼠标下窗口的ID
        Loop, %winList%
        {
            this_id := winList%A_Index%
            if (this_id = mouseWinId)  ; 检查当前窗口是否与鼠标下的窗口匹配
                ResetWindowToNormal(this_id)
        }
    }
#If