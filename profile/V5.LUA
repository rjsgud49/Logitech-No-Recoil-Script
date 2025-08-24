EnablePrimaryMouseButtonEvents(true)

local recoilStrength = 2  -- 반동 강도 (항상 일정)

function OnEvent(event, arg)
    -- 좌클릭 + 우클릭 동시에 눌렸을 때만 작동
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 1) then
        if IsMouseButtonPressed(3) then   -- 우클릭 상태 확인
            OutputLogMessage("Recoil Activated (Always ON)\n")

            -- 최소 1회 반동 적용
            MoveMouseRelative(0, recoilStrength)
            Sleep(10)

            -- 좌클릭 유지되는 동안 반복
            while IsMouseButtonPressed(1) and IsMouseButtonPressed(3) do
                MoveMouseRelative(0, recoilStrength)
                Sleep(10)
            end
        else
            OutputLogMessage("Recoil skipped (RMB not held)\n")
        end
    end
end
-- 이 스크립트는 항상 좌클릭과 우클릭이 동시에 눌렸을 때만 반동을 적용합니다.
-- 반동 강도는 항상 일정하게 유지되며, 우클릭이 눌리지 않으면 반동이 적용되지 않습니다.