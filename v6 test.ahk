#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 99000000
#KeyHistory 0
SetBatchLines -1
SetKeyDelay -1, -1
SetMouseDelay -1
SetDefaultMouseSpeed 0
SetWinDelay -1
SetControlDelay -1
SendMode Input

; ================= 설정 =================
rapid_delay := 158     ; 380 BPM 기준 (필요하면 155~162 사이로 미세 조정)
recoil_y := 4          ; 아래로 보정할 픽셀 (감도에 따라 3~6 추천)

; ================= 메인 =================
~RButton::  
    while GetKeyState("RButton", "P")  
    {
        if GetKeyState("LButton", "P")  
        {
            Loop
            {
                Click  
                DllCall("mouse_event", uint, 0x01, int, 0, int, recoil_y, uint, 0, int, 0)  
                Sleep, %rapid_delay%
                
                if (!GetKeyState("LButton", "P") || !GetKeyState("RButton", "P"))
                    break
            }
        }
        Sleep, 10
    }
return