EnablePrimaryMouseButtonEvents(true)

-- 항상 ON 기본값
local recoil = true
local recoilStrength = 2  -- 기본 반동 값
local minRecoil = 1       -- 최소 반동 강도
local maxRecoil = 5       -- 최대 반동 강도

local function clamp(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

recoilStrength = clamp(recoilStrength, minRecoil, maxRecoil)

local function printOn()
    OutputLogMessage([[
  ___   _ __  
 / _ \ | '_ \ 
| (_) || | | |
 \___/ |_| |_|

Recoil ON (forced)
]])
end

function OnEvent(event, arg)
    -- 프로필 켜질 때마다 강제 ON
    if event == "PROFILE_ACTIVATED" then
        recoil = true
        printOn()
    end

    -- 6번 버튼: 강제 ON (토글 아님)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 6) then
        recoil = true
        printOn()
    end

    -- 안전장치: 어딘가에서 false가 되었다면 즉시 복구
    if not recoil then
        recoil = true
        -- 메시지는 과도 출력 방지 위해 생략 가능; 원하면 printOn() 호출
    end

    -- 반동제어 실행 (좌클릭 + 우클릭 동시에 눌렸을 때만 작동)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 1 and recoil) then
        if IsMouseButtonPressed(3) then
            -- 최소 1회 반동 적용
            MoveMouseRelative(0, recoilStrength)
            Sleep(10)

            -- 좌클릭 유지되는 동안 반복
            while IsMouseButtonPressed(1) and IsMouseButtonPressed(3) do
                -- 루프 중에도 항상 ON 유지
                if not recoil then recoil = true end
                MoveMouseRelative(0, recoilStrength)
                Sleep(10)
            end
        end
    end
end
