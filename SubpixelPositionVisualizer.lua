print("Welcome to SubpixelPositionVisualizer. Press Z and look at some particles!")

-- Radius of position dots
local dotRadius = 2
local dotRadiusNext = 1

-- 0: Never draw
-- 1: Draw only when moused over
-- 2: Always draw
local drawPosition = 2
local drawNextPosition = 2
local drawVelocityLine = 2

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