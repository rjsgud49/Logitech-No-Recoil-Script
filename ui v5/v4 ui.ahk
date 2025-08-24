#Persistent
SetTimer, CheckRecoil, 500
return

CheckRecoil:
FileRead, state, C:\recoil_state.txt
StringTrimRight, state, state, 1   ; 줄바꿈 제거

if (state != lastState) {
    lastState := state
    Gui, Destroy
    Gui, +AlwaysOnTop -Caption +ToolWindow
    Gui, Color, 000000  ; 배경 검정
    if (state = "ON") {
        Gui, Font, s14 Bold cFF5555, Segoe UI  ; 빨강 글씨
    } else {
        Gui, Font, s14 Bold c5555FF, Segoe UI  ; 파랑 글씨
    }
    Gui, Add, Text, w200 Center, Recoil %state%
    Gui, Show, x10 y10 NoActivate
}
return
