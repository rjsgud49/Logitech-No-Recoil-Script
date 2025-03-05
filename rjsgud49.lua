EnablePrimaryMouseButtonEvents(true)

local recoil = false
local recoilStrength = 1.0  -- 기본 반동 값 (소수점으로 조정)
local minRecoilStrength = 0.1  -- 최소 반동 강도
local maxRecoilStrength = 5.0  -- 최대 반동 강도
local recoilStep = 0.1  -- 반동 강도 증가/감소 단위 (세밀하게 조정)

function OnEvent(event, arg)
    -- 매크로 토글 (Caps Lock 키 사용)
    if event == "MOUSE_BUTTON_PRESSED" and arg == 3 then
        recoil = not recoil
        if recoil then
            OutputLogMessage("Recoil ON\n")
        else
            OutputLogMessage("Recoil OFF\n")
        end
    end

    -- 반동 강도 증가 (Alt + -)
    if event == "KEY_PRESSED" and arg == 0xE2 and IsModifierPressed("lalt") then  -- Alt + -
        recoilStrength = math.min(maxRecoilStrength, recoilStrength + recoilStep)
        OutputLogMessage("Recoil Strength: %.1f\n", recoilStrength)
    end

    -- 반동 강도 감소 (Alt + +)
    if event == "KEY_PRESSED" and arg == 0xE3 and IsModifierPressed("lalt") then  -- Alt + +
        recoilStrength = math.max(minRecoilStrength, recoilStrength - recoilStep)
        OutputLogMessage("Recoil Strength: %.1f\n", recoilStrength)
    end

    -- 반동제어 실행 (좌클릭 시 적용)
    if event == "MOUSE_BUTTON_PRESSED" and arg == 1 and recoil then
        while IsMouseButtonPressed(1) do
            -- 반동 강도를 소수점 단위로 적용
            MoveMouseRelative(0, recoilStrength * 10)  -- 반동 강도에 따라 마우스 이동량 조정
            Sleep(10)  -- 이 값은 반동 조정의 반응 속도에 영향을 미침
        end
    end
end
