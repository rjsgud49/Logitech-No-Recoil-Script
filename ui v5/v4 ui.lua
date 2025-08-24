EnablePrimaryMouseButtonEvents(true)

local recoil = false
local recoilStrength = 2

function OnEvent(event, arg)
    if (event == "MOUSE_BUTTON_PRESSED" and arg == 6) then
        recoil = not recoil
        local state = recoil and "ON" or "OFF"
        OutputLogMessage("[Recoil] %s\n", state)

        local f = io.open("C:\\Users\\qkrrjsgud49\\Documents\\recoil_state.txt", "w")
        if f then
            f:write(state)
            f:flush()  -- 버퍼 비우기 (즉시 기록)
            f:close()
        end
    end

    if (event == "MOUSE_BUTTON_PRESSED" and arg == 1 and recoil) then
        if IsMouseButtonPressed(3) then
            while IsMouseButtonPressed(1) and IsMouseButtonPressed(3) do
                MoveMouseRelative(0, recoilStrength)
                Sleep(10)
            end
        end
    end
end
