#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



;-----------------------------------------------------------
; 一直关闭 Capslock
SetCapsLockState, AlwaysOff

; Win & CapsLock -> CapsLock
LWin & CapsLock::
Send {CapsLock}
return

; CapsLock -> Win + Space
CapsLock::
Show_IME_Tooltip(0)
Send #{Space}
return

; CapsLock & w -> Alt + F4
CapsLock & w::
Send !{F4}
return

; CapsLock & q -> Chrome
CapsLock & q::
Run, chrome
return

; 重启脚本
CapsLock & r::
Reload
Sleep 1000 ; 如果成功, 则 reload 会在 Sleep 期间关闭这个实例, 所以下面这行语句永远不会执行.
MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
IfMsgBox, Yes, Edit
return
;-----------------------------------------------------------



;-----------------------------------------------------------
; 鼠标滚轮
CapsLock & i::
SendEvent {Blind}{WheelUp}
return
CapsLock & k::
SendEvent {Blind}{WheelDown}
return
CapsLock & j::
SendEvent {Blind}{WheelLeft}
return
CapsLock & l::
SendEvent {Blind}{WheelRight}
return

; 鼠标的第四个按键
XButton1::
send {Browser_Back}
return

; 鼠标的第五个按键 -> LCtrl + W
XButton2::
Send ^w
return
;-----------------------------------------------------------



; 设置鼠标样式
; SetSystemCursor("SIZEALL")
; SetSystemCursor()
; https://msdn.microsoft.com/en-us/library/windows/desktop/ms648395(v=vs.85).aspx
SetSystemCursor(Cursor := "")
{
    Static Cursors := {APPSTARTING: 32650, ARROW: 32512, CROSS: 32515, HAND: 32649, HELP: 32651, IBEAM: 32513, NO: 32648, SIZEALL: 32646, SIZENESW: 32643, SIZENS: 32645, SIZENWSE: 32642, SIZEWE: 32644, UPARROW: 32516, WAIT: 32514}

    If (Cursor == "")
        Return DllCall("User32.dll\SystemParametersInfoW", "UInt", 0x0057, "UInt", 0, "Ptr", 0, "UInt", 0)
    Cursor := InStr(Cursor, "3") ? Cursor : Cursors[Cursor]

    ; Local hCursor
    For Each, ID in Cursors
    {
        hCursor := DllCall("User32.dll\LoadImageW", "Ptr", 0, "Int", Cursor, "UInt", 2, "Int", 0, "Int", 0, "UInt", 0x00008000, "Ptr")   ; 2 = IMAGE_CURSOR | 0x00008000 = LR_SHARED
        hCursor := DllCall("User32.dll\CopyIcon", "Ptr", hCursor, "Ptr")
        DllCall("User32.dll\SetSystemCursor", "Ptr", hCursor, "UInt",  ID)
    }
}

;-----------------------------------------------------------
; IMEの状態の取得
;    対象： AHK v1.0.34以降
;   WinTitle : 対象Window (省略時:アクティブウィンドウ)
;   戻り値  1:ON 0:OFF
;-----------------------------------------------------------
IME_GET(WinTitle="")
{
    ifEqual WinTitle,,  SetEnv,WinTitle,A
    WinGet,hWnd,ID,%WinTitle%
    DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hWnd, Uint)

    ;Message : WM_IME_CONTROL  wParam:IMC_GETOPENSTATUS
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows,ON
    SendMessage 0x283, 0x005,0,,ahk_id %DefaultIMEWnd%
    DetectHiddenWindows,%DetectSave%
    Return ErrorLevel
}

; 判断当前输入法状态，显示ToolTip
Show_IME_Tooltip(OnValue:=1)
{
    If (IME_GET() = OnValue) {
        ToolTip, 中
        ; SetSystemCursor("APPSTARTING")
    } else {
        ToolTip, EN
        ; SetSystemCursor()
    }
    SetTimer, RemoveToolTip, -500
}
; 移除ToolTip
RemoveToolTip:
ToolTip
return

; ~LButton::
; If (A_Cursor = "IBeam") {
;     Show_IME_Tooltip()
; } else if(A_Cursor = "Arrow") {
; }
; return
