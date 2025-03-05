EnablePrimaryMouseButtonEvents(true)

local recoil = false
local recoilStrength = 10  -- 기본 반동 값

function OnEvent(event, arg)
    -- 매크로 토글 (Caps Lock 키 사용)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 3) then
        recoil = not recoil
        if recoil then
            OutputLogMessage("Recoil ON\n")
        else
            OutputLogMessage("Recoil OFF\n")
        end
    end

    -- 반동 강도 증가 (엄지버튼 4번)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 4) then  -- 마우스 4번 버튼 (엄지버튼)
        recoilStrength = recoilStrength + 1
        OutputLogMessage("Recoil Strength Increased: %d\n", recoilStrength)
    end

    -- 반동 강도 감소 (엄지버튼 5번)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 5) then  -- 마우스 5번 버튼 (엄지버튼)
        recoilStrength = math.max(1, recoilStrength - 1)  -- 최소값 1 제한
        OutputLogMessage("Recoil Strength Decreased: %d\n", recoilStrength)
    end

    -- 반동제어 실행 (좌클릭 시 적용)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 1 and recoil) then
        OutputLogMessage("Recoil Activated\n")
        while IsMouseButtonPressed(1) do
            MoveMouseRelative(0, recoilStrength)
            Sleep(10)  -- 조절 가능
        end
    end
end
