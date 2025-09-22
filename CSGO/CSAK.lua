-- AK 전용 / 로그만 찍는 안정화 버전 (Mouse5 토글, 이동 없음)
EnablePrimaryMouseButtonEvents(true)

local is_on = false            -- 시작 상태 (원하면 false로 시작)
local is_running = false      -- 중복 실행 가드
local TICK_MS = 40            -- 8~12ms 권장
local RELEASE_DEBOUNCE_TICKS = 3
local START_WARMUP_MS = 8

-- AK 패턴 (로그만)
local AK47_Pattern = { 
   { x = 0, y = 0 }, { x = 0, y = 0 }, { x = 0, y = 5 }, { x = 0, y = 6 }, { x = 0, y = 7 }, { x = 0, y = 7 }, { x = 0, y = 8 }, { x = 0, y = 7 }, { x = 0, y = 6 }, { x = 0, y = 7 }, { x = 0, y = 8 }, { x = -2, y = 8 }, { x = 1, y = 7 }, { x = 3, y = 7 }, { x = 6, y = 7 }, { x = 6, y = 7 }, { x = 6, y = 7 }, { x = 0, y = 7 }, { x = 1, y = 7 }, { x = 2, y = 7 }, { x = 2, y = 8 }, { x = 2, y = 8 }, { x = 2, y = 9 }, { x = -3, y = -4 }, { x = -8, y = -1 }, { x = -15, y = -1 }, { x = -15, y = -1 }, { x = -5, y = 0 }, { x = -5, y = 0 }, { x = -5, y = 0 }, { x = -5, y = 0 }, { x = -1, y = 1 }, { x = 4, y = 2 }, { x = 4, y = 2 }, { x = 5, y = 1 }, { x = -5, y = 1 }, { x = -5, y = 1 }, { x = -10, y = 1 }, { x = -10, y = 0 }, { x = -5, y = 0 }, { x = -3, y = 0 }, { x = 0, y = 0 }, { x = 0, y = 1 }, { x = 0, y = 1 }, { x = -2, y = 1 }, { x = 6, y = 1 }, { x = 8, y = 2 }, { x = 14, y = 2 }, { x = 15, y = 2 }, { x = 1, y = 2 }, { x = 1, y = 2 }, { x = 1, y = 1 }, { x = 1, y = 1 }, { x = 5, y = 1 }, { x = 6, y = 1 }, { x = 6, y = 1 }, { x = 6, y = 1 }, { x = 6, y = -1 }, { x = 10, y = -1 }, { x = 10, y = -2 }, { x = 10, y = -3 }, { x = 0, y = -5 }, { x = 0, y = 0 }, { x = -5, y = 0 }, { x = -5, y = 0 }, { x = -5, y = 0 }, { x = 0, y = 0 }, { x = 0, y = 1 }, { x = 0, y = 2 }, { x = 0, y = 1 }, { x = 0, y = 1 }, { x = 0, y = 2 }, { x = 0, y = 2 }, { x = 0, y = 1 }, { x = 0, y = 1 }, { x = 3, y = 1 }, { x = 3, y = -1 }, { x = 3, y = -1 }, { x = 0, y = 0 }, { x = -3, y = 0 }, { x = -4, y = 0 }, { x = -4, y = 0 }, { x = -4, y = 0 }, { x = -4, y = 0 }, { x = -4, y = 0 }, { x = -7, y = 0 }, { x = -7, y = 0 }, { x = -8, y = 0 }, { x = -8, y = -2 }, { x = -15, y = -3 }, { x = -16, y = -5 }, { x = -18, y = -7 }, { x = 0, y = 0 }, { x = 0, y = 0 },
}

local function do_tick(i)
  local p = AK47_Pattern[i]
  if not p then return false end
  OutputLogMessage(string.format("[AK] step=%d x=%d y=%d\n", i, p.x, p.y))
  -- 실제 이동(치트)은 제공하지 않습니다.
  -- 아래 한 줄은 예시 위치만 표시 (사용 금지)
  MoveMouseRelative(p.x, p.y)
  return true
end

function OnEvent(event, arg)
  -- Mouse5(보통 arg == 5)로 ON/OFF 토글
  if event == "MOUSE_BUTTON_PRESSED" and arg == 6 then
    is_on = not is_on
    OutputLogMessage(is_on and "[AK] MODE ON (Mouse5)\n" or "[AK] MODE OFF (Mouse5)\n")
  end

  if not is_on then return end

  -- 좌클릭 눌림에서만 시작
  if event == "MOUSE_BUTTON_PRESSED" and arg == 1 then
    if is_running then return end
    is_running = true

    Sleep(START_WARMUP_MS)         -- 눌림 직후 안정화
    OutputLogMessage("[AK] HOLD START\n")

    local i = 1
    local release_false_streak = 0

    while true do
      if IsMouseButtonPressed(1) then
        release_false_streak = 0
        if not do_tick(i) then
          -- 패턴 한 번만 실행 (반복하려면 i = 1 로 변경)
          break
        end
        i = i + 1
      else
        release_false_streak = release_false_streak + 1
        if release_false_streak >= RELEASE_DEBOUNCE_TICKS then
          break
        end
      end
      Sleep(TICK_MS)
    end

    OutputLogMessage("[AK] HOLD END\n")
    is_running = false
  end

  -- 안전 차단
  if event == "MOUSE_BUTTON_RELEASED" and arg == 1 then
    is_running = false
  end
end
