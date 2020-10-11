; 特殊案件映射
SC132::f1
return
SC165::f2
return
; LCtrl & a::
; return
; LCtrl & c::
; return
; LCtrl & v::
; return
; LCtrl & x::
return
SC110::f7
return
SC122::f8
return
SC119::f9
return
SC12E::f10
return
SC130::f11
return



; f3~f6的特殊处理
; 遗留问题：
; Ctrl+a、Ctrl+c、Ctrl+v、Ctrl+x操作时不能按太久，否则会误判为f3~f6
; 原因在于长按按键会重复触发事件，导致关键的时间判断出错
~LCtrl::
send {LCtrl Down}
return

; MsgBox, %A_ThisHotKey% %A_PriorHotkey% %A_PriorKey% %A_TimeSinceThisHotkey% %A_TimeSincePriorHotkey%
LCtrl & a::
KeyWait LCtrl
Diff := A_TimeSincePriorHotkey - A_TimeSinceThisHotkey
if (Diff <= 16) {
    send {f3}
} else {
    send ^a
}
return

LCtrl & c::
KeyWait LCtrl
Diff := A_TimeSincePriorHotkey - A_TimeSinceThisHotkey
if (Diff <= 16) {
    send {f4}
} else {
    send ^c
}
return

LCtrl & v::
KeyWait LCtrl
Diff := A_TimeSincePriorHotkey - A_TimeSinceThisHotkey
if (Diff <= 16) {
    send {f5}
} else {
    send ^v
}
return

LCtrl & x::
KeyWait LCtrl
Diff := A_TimeSincePriorHotkey - A_TimeSinceThisHotkey
if (Diff <= 16) {
    send {f6}
} else {
    send ^x
}
return
