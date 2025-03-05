EnablePrimaryMouseButtonEvents(true)

local recoil = false
local recoilStrength = 10  -- 기본 반동 값
local minRecoil = 1        -- 최소 반동 강도
local maxRecoil = 20       -- 최대 반동 강도

function OnEvent(event, arg)
    -- 매크로 토글 (마우스 클릭으로  사용)
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

        -- 좌클릭이 감지되면 최소 1회는 반동 적용 (간헐적 미적용 문제 해결)
        MoveMouseRelative(math.random(-2, 2), recoilStrength + math.random(-3, 3))
        Sleep(10)  -- 최소한의 반응 시간 확보

        -- 좌클릭이 유지되는 동안 반복 실행
        while IsMouseButtonPressed(1) do
            MoveMouseRelative(math.random(-2, 2), recoilStrength + math.random(-3, 3))
            Sleep(math.random(8, 12))  -- 더 빠른 반동제어
        end
    end
end
