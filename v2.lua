EnablePrimaryMouseButtonEvents(true)

local recoil = false
local recoilStrength = 10  -- 기본 반동 값
local minRecoil = 1        -- 최소 반동 강도
local maxRecoil = 20       -- 최대 반동 강도

function OnEvent(event, arg)
    -- 매크로 토글 (Caps Lock 키 사용)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 3) then
        recoil = not recoil
        if recoil then
            OutputLogMessage("[✔] Recoil ON\n")
        else
            OutputLogMessage("[✖] Recoil OFF\n")
        end
    end

    -- 반동 강도 조절 (DPI 버튼)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 6) then  -- 마우스 DPI 버튼
        recoilStrength = recoilStrength + 1
        if recoilStrength > maxRecoil then
            recoilStrength = minRecoil  -- 최대값 초과 시 최소값으로 초기화
        end
        OutputLogMessage("Recoil Strength: %d\n", recoilStrength)
    end

    -- 반동제어 실행 (좌클릭 시 적용)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 1 and recoil) then
        OutputLogMessage("Recoil Activated\n")
        while IsMouseButtonPressed(1) do
            -- 자연스러운 반동 보정 적용
            MoveMouseRelative(math.random(-1, 1), recoilStrength + math.random(-2, 2))
            Sleep(math.random(15, 20))  -- CPU 점유율 최적화
        end
    end
end
