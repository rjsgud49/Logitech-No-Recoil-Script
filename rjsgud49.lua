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

    -- 반동 강도 증가 (Alt + -)
    if (event == "KEY_PRESSED" and arg == 0xE2 and IsModifierPressed("lalt")) then  -- Alt + -
        recoilStrength = recoilStrength + 1
        OutputLogMessage("Recoil Strength: %d\n", recoilStrength)
    end

    -- 반동 강도 감소 (Alt + +)
    if (event == "KEY_PRESSED" and arg == 0xE3 and IsModifierPressed("lalt")) then  -- Alt + +
        recoilStrength = math.max(1, recoilStrength - 1)  -- 최소값 1 제한
        OutputLogMessage("Recoil Strength: %d\n", recoilStrength)
    end

    -- 반동제어 실행 (좌클릭 시 적용)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 1 and recoil) then
        while IsMouseButtonPressed(1) do
            MoveMouseRelative(0, recoilStrength)
            Sleep(10)  -- 조절 가능
        end
    end
end
