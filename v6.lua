EnablePrimaryMouseButtonEvents(true)

local rapid_delay = 158    -- 380 BPM (155~162 사이에서 테스트하며 조정)
local recoil_y = 4         -- 아래로 보정할 값 (3~6 사이에서 Mutant에 맞게 조정)

function OnEvent(event, arg)
    if event == "MOUSE_BUTTON_PRESSED" and arg == 1 then        -- 좌클릭 눌렀을 때
        if IsMouseButtonPressed(3) then                         -- 우클릭(ADS)이 눌려있으면
            repeat
                PressAndReleaseMouseButton(1)                   -- 발사
                MoveMouseRelative(0, recoil_y)                  -- 반동 보정
                Sleep(rapid_delay)
            until not IsMouseButtonPressed(1) or not IsMouseButtonPressed(3)  -- 하나라도 떼면 종료
        end
    end
end