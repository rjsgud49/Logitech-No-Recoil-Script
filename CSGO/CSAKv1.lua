-- 진행도 기반 릴리스 보정 버전 (Mouse6 토글)
-- 홀드 중엔 이동 없음, 손을 떼는 순간에만 "진행도 비례 상향 보정" 1회 수행
EnablePrimaryMouseButtonEvents(true)

local is_on = false
local is_running = false

local TICK_MS = 29            -- 패턴 로그 틱
local START_WARMUP_MS = 8     -- 눌림 직후 안정화
local MAX_STEPS = 200         -- 안전 가드
local RELEASE_DEBOUNCE_TICKS = 0 -- 즉시 종료

-- 진행도 → 픽셀 보정 한계치(위로 올림 픽셀 수의 최대값)
-- 예: 60이면 진행도 100%일 때 릴리스 순간 위로 60px 올림
local MAX_UP_COMP_PIXELS = 250

-- 보정 곡선(감쇠/가중치) 선택: "linear" | "easeOut" | "sqrt"
local CURVE = "easeOut"

-- 패턴(로그만 찍음, 홀드 동안 이동 없음)
local AK47_Pattern = {
   { x = 0, y = 0 }, { x = 0, y = 0 }, { x = 0, y = 5 }, { x = 0, y = 6 }, { x = 0, y = 7 }, { x = 0, y = 7 }, { x = 0, y = 8 }, { x = 0, y = 7 }, { x = 0, y = 6 }, { x = 0, y = 7 }, { x = 0, y = 8 }, { x = -2, y = 8 }, { x = 1, y = 7 }, { x = 3, y = 7 }, { x = 6, y = 7 }, { x = 6, y = 7 }, { x = 6, y = 7 }, { x = 0, y = 7 }, { x = 1, y = 7 }, { x = 2, y = 7 }, { x = 2, y = 8 }, { x = 2, y = 8 }, { x = 2, y = 9 }, { x = -3, y = -4 }, { x = -8, y = -1 }, { x = -15, y = -1 }, { x = -15, y = -1 }, { x = -5, y = 0 }, { x = -5, y = 0 }, { x = -5, y = 0 }, { x = -5, y = 0 }, { x = -1, y = 1 }, { x = 4, y = 2 }, { x = 4, y = 2 }, { x = 5, y = 1 }, { x = -5, y = 1 }, { x = -5, y = 1 }, { x = -10, y = 1 }, { x = -10, y = 0 }, { x = -5, y = 0 }, { x = -3, y = 0 }, { x = 0, y = 0 }, { x = 0, y = 1 }, { x = 0, y = 1 }, { x = -2, y = 1 }, { x = 6, y = 1 }, { x = 8, y = 2 }, { x = 14, y = 2 }, { x = 15, y = 2 }, { x = 1, y = 2 }, { x = 1, y = 2 }, { x = 1, y = 1 }, { x = 1, y = 1 }, { x = 5, y = 1 }, { x = 6, y = 1 }, { x = 6, y = 1 }, { x = 6, y = 1 }, { x = 6, y = -1 }, { x = 10, y = -1 }, { x = 10, y = -2 }, { x = 10, y = -3 }, { x = 0, y = -5 }, { x = 0, y = 0 }, { x = -5, y = 0 }, { x = -5, y = 0 }, { x = -5, y = 0 }, { x = 0, y = 0 }, { x = 0, y = 1 }, { x = 0, y = 2 }, { x = 0, y = 1 }, { x = 0, y = 1 }, { x = 0, y = 2 }, { x = 0, y = 2 }, { x = 0, y = 1 }, { x = 0, y = 1 }, { x = 3, y = 1 }, { x = 3, y = -1 }, { x = 3, y = -1 }, { x = 0, y = 0 }, { x = -3, y = 0 }, { x = -4, y = 0 }, { x = -4, y = 0 }, { x = -4, y = 0 }, { x = -4, y = 0 }, { x = -4, y = 0 }, { x = -7, y = 0 }, { x = -7, y = 0 }, { x = -8, y = 0 }, { x = -8, y = -2 }, { x = -15, y = -3 }, { x = -16, y = -5 }, { x = -18, y = -7 }, { x = 0, y = 0 }, { x = 0, y = 0 },
}

local function curve_factor(t) -- t in [0,1]
  if t <= 0 then return 0 end
  if t >= 1 then return 1 end
  if CURVE == "linear" then
    return t
  elseif CURVE == "sqrt" then
    -- 초반 가볍게, 후반 더 크게
    return math.sqrt(t)
  else
    -- easeOutQuad (기본)
    return 1 - (1 - t) * (1 - t)
  end
end

local function do_tick(i)
  local p = AK47_Pattern[i]
  if not p then return false end
  -- 홀드 동안에는 '로그만' 찍고, 이동은 하지 않음
  OutputLogMessage(string.format("[AK] step=%d x=%d y=%d\n", i, p.x, p.y))
   MoveMouseRelative(p.x, p.y)
  return true
end

function OnEvent(event, arg)
  -- Mouse6 토글
  if event == "MOUSE_BUTTON_PRESSED" and arg == 6 then
    is_on = not is_on
    OutputLogMessage(is_on and "[AK] MODE ON (Mouse6)\n" or "[AK] MODE OFF (Mouse6)\n")
  end
  if not is_on then return end

  -- 좌클릭 눌림 시작
  if event == "MOUSE_BUTTON_PRESSED" and arg == 1 then
    if is_running then return end
    is_running = true

    Sleep(START_WARMUP_MS)
    OutputLogMessage("[AK] HOLD START\n")

    local i = 1
    local steps = 0
    local release_false_streak = 0
    local total_steps = #AK47_Pattern

    while true do
      if not IsMouseButtonPressed(1) then
        release_false_streak = release_false_streak + 1
        if release_false_streak >= RELEASE_DEBOUNCE_TICKS then
          break
        end
      else
        release_false_streak = 0
        steps = steps + 1
        if steps > MAX_STEPS then
          OutputLogMessage("[AK] MAX_STEPS reached, stop\n")
          break
        end
        if not do_tick(i) then
          break
        end
        i = i + 1
      end
      Sleep(TICK_MS)
    end

    -- ===== 릴리스 순간 보정: 진행도 비례 상향 이동 1회 =====
    -- 진행도: 0.0 ~ 1.0 (패턴 단계 수 기준)
    local progress = 0
    if total_steps > 0 then
      progress = (math.max(0, math.min(steps, total_steps))) / total_steps
    end

    local factor = curve_factor(progress)        -- 곡선 가중
    local up_pixels = math.floor(MAX_UP_COMP_PIXELS * factor + 0.5)

    if up_pixels > 0 then
      -- 화면을 '위로' 올리려면 y 음수(상향)로 이동
      MoveMouseRelative(0, -up_pixels)
      OutputLogMessage(string.format("[AK] RELEASE COMP: progress=%.2f factor=%.2f up=%dpx\n",
        progress, factor, up_pixels))
    else
      OutputLogMessage(string.format("[AK] RELEASE COMP: progress=%.2f factor=%.2f up=0px\n",
        progress, factor))
    end
    -- ================================================

    OutputLogMessage("[AK] HOLD END\n")
    is_running = false
  end

  -- 릴리스 시 가드
  if event == "MOUSE_BUTTON_RELEASED" and arg == 1 then
    is_running = false
  end
end
