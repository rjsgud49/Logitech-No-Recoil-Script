EnablePrimaryMouseButtonEvents(true)

local autoFire = false
local fireRate = 5000  -- 연사 속도 (밀리초, 낮을수록 빠름)

function OnEvent(event, arg)
    -- 매크로 토글 (마우스 휠 클릭 사용)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 3) then
        autoFire = not autoFire
        OutputLogMessage(autoFire and "[✔] Auto Fire ON\n" or "[✖] Auto Fire OFF\n")
    end

    -- 자동 클릭 실행 (좌클릭 시)
    if autoFire and event == "MOUSE_BUTTON_PRESSED" and arg == 1 then
        OutputLogMessage("Auto Fire Activated\n")
        repeat
            PressMouseButton(1)  -- 좌클릭 누름
            Sleep(10)            -- 입력 인식 개선
            ReleaseMouseButton(1) -- 좌클릭 뗌
        until not IsMouseButtonPressed(1) or not autoFire  -- 좌클릭을 떼거나, 자동 연사가 비활성화되면 종료
    end
end
