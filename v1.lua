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

    -- 반동 강도 증가 (엄지버튼 4번)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 4) then  -- 마우스 4번 버튼 (엄지버튼)
        recoilStrength = math.min(maxRecoil, recoilStrength + 1)  -- 최대값 제한
        OutputLogMessage("Recoil Strength Increased: %d\n", recoilStrength)
    end

    -- 반동 강도 감소 (엄지버튼 5번)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 5) then  -- 마우스 5번 버튼 (엄지버튼)
        recoilStrength = math.max(minRecoil, recoilStrength - 1)  -- 최소값 제한
        OutputLogMessage("Recoil Strength Decreased: %d\n", recoilStrength)
    end

    -- 반동제어 실행 (좌클릭 시 적용)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 1 and recoil) then
        OutputLogMessage("Recoil Activated\n")

        -- 좌클릭 감지되면 최소 1회 반동 적용 (간헐적 미적용 방지)
        MoveMouseRelative(math.random(-1, 1), recoilStrength + math.random(-2, 2))
        Sleep(10)

        while IsMouseButtonPressed(1) do
            -- 랜덤한 수직 움직임 추가 (더 자연스러운 반동)
            MoveMouseRelative(math.random(-1, 1), recoilStrength + math.random(-2, 2))
            Sleep(math.random(8, 12))  -- 최적화된 반동 속도
        end
    end
end
