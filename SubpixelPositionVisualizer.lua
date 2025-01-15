print("Welcome to SubpixelPositionVisualizer. Press Z and look at some particles! Press V to cycle display modes")

-- Radius of position dots
local dotRadius = 2
local dotRadiusNext = 1

-- 0: Never draw
-- 1: Draw only when moused over
-- 2: Always draw
local drawPosition = 0
local drawVelocityLine = 0
local drawNextPosition = 0

event.register(event.tick, function()
    local zoomEnabled = ren.zoomEnabled()
    if zoomEnabled then
        -- Get information about the position of the zoom window
        local zoomX, zoomY, zoomPixels = ren.zoomScope()
        local zWinX, zWinY, zWinPxSize, zWinSize = ren.zoomWindow()

        -- Iterate through all grid positions displayed in the zoom window
        for i = 0, zoomPixels - 1 do
            for j = 0, zoomPixels - 1 do
                -- Check if there's a part at this grid position
                local part = sim.partID(i + zoomX, j + zoomY)

                -- Is the mouse hovering over this particle?
                local mouseX, mouseY = sim.adjustCoords(interface.mousePosition())
                local mouseOver = mouseX == i + zoomX and mouseY == j + zoomY

                if part then
                    x, y = sim.partPosition(part)
                    vx, vy = sim.partProperty(part, "vx"), sim.partProperty(part, "vy")

                    -- Translate particle position to screen space coordinates, scaled to fit the zoom window
                    local drawX = zWinX + zWinPxSize * (x - zoomX + 0.5)
                    local drawY = zWinY + zWinPxSize * (y - zoomY + 0.5)

                    -- Ditto, but for projected position using current velocity
                    local drawNextX = zWinX + zWinPxSize * (x - zoomX + 0.5 + vx)
                    local drawNextY = zWinY + zWinPxSize * (y - zoomY + 0.5 + vy)

                    -- Draw dot centered on particle's subpixel position in zoom window, adjusted for the size of the dot
                    if drawPosition == 2 or drawPosition == 1 and mouseOver then
                        graphics.fillCircle(drawX - dotRadius / 2, drawY - dotRadius / 2, dotRadius, dotRadius, 255, 0, 0)
                        graphics.drawCircle(drawX - dotRadius / 2, drawY - dotRadius / 2, dotRadius, dotRadius)
                    end

                    -- Draw a line from the current position to the projected position
                    if drawVelocityLine == 2 or drawVelocityLine == 1 and mouseOver then
                        graphics.drawLine(drawX - 1, drawY - 1, drawNextX - 1, drawNextY - 1, 0, 255, 0)
                    end

                    -- Ditto, but for projected position using current velocity
                    if drawNextPosition == 2 or drawNextPosition == 1 and mouseOver then
                        graphics.fillCircle(drawNextX - dotRadiusNext / 2, drawNextY - dotRadiusNext / 2, dotRadiusNext, dotRadiusNext, 0, 255, 0)
                        graphics.drawCircle(drawNextX - dotRadiusNext / 2, drawNextY - dotRadiusNext / 2, dotRadiusNext, dotRadiusNext)
                    end
                end
            end
        end
    end
end)

local currentDisplayMode
local displayModes = {
    {2, 0, 0, "Default"},
    {2, 2, 0, "Velocity line"},
    {2, 2, 2, "Next frame position"},
    {2, 1, 1, "Next frame position (hover)"},
    {1, 1, 1, "Hovering only"},
}

local function changeDisplayMode(newMode)
    if displayModes[newMode] then
        currentDisplayMode = newMode
        drawPosition = displayModes[newMode][1]
        drawVelocityLine = displayModes[newMode][2]
        drawNextPosition = displayModes[newMode][3]
        print("Display mode " .. newMode .. ": " .. displayModes[newMode][4])
        MANAGER.savesetting("SubpixelPositionVisualizer", "displayMode", newMode)
    else
        print("No display mode with index " .. newMode)
    end
end
changeDisplayMode(tonumber(MANAGER.getsetting("SubpixelPositionVisualizer", "displayMode") or 1))

event.register(event.keypress, function(key, scan, rep, shift, ctrl, alt)
    if not rep and key == 118 then -- V
        if shift then
            changeDisplayMode((currentDisplayMode - 2) % #displayModes + 1)
        else
            changeDisplayMode(currentDisplayMode % #displayModes + 1)
        end
    end
end)  