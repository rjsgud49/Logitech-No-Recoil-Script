EnablePrimaryMouseButtonEvents(true)

local recoil = false
local recoilStrength = 2  -- 기본 반동 값
local minRecoil = 1       -- 최소 반동 강도
local maxRecoil = 5       -- 최대 반동 강도

function OnEvent(event, arg)
    -- 매크로 토글 (마우스 6번 버튼으로 ON/OFF)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 6) then
        recoil = not recoil
        if recoil then
            OutputLogMessage([[
  ___   _ __  
 / _ \ | '_ \ 
| (_) || | | |
 \___/ |_| |_|

Recoil ON
]])
        else
            OutputLogMessage([[
 _____ ______ ______ 
|  _  ||  ___||  ___|
| | | || |_   | |_   
| | | ||  _|  |  _|  
\ \_/ /| |    | |    
 \___/ \_|    \_|    

Recoil OFF
]])
        end
    end

    -- 반동제어 실행 (좌클릭 + 우클릭 동시에 눌렸을 때만 작동)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 1 and recoil) then
        if IsMouseButtonPressed(3) then   -- 우클릭 체크 추가
            --OutputLogMessage("Recoil Activated (RMB held)\n")

            -- 최소 1회 반동 적용
            MoveMouseRelative(0, recoilStrength)
            Sleep(10)

            -- 좌클릭 유지되는 동안 반복
            while IsMouseButtonPressed(1) and IsMouseButtonPressed(3) do
                MoveMouseRelative(0, recoilStrength)
                Sleep(10)
            end
        else
            --OutputLogMessage("Recoil skipped (RMB not held)\n")
        end
    end
end