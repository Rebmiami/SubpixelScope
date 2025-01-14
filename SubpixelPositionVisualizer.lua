print("Welcome to SubpixelPositionVisualizer. Press Z and look at some particles!")

local dotRadius = 2

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
                    graphics.fillCircle(drawX - dotRadius / 2, drawY - dotRadius / 2, dotRadius, dotRadius, 255, 0, 0)
                    graphics.drawCircle(drawX - dotRadius / 2, drawY - dotRadius / 2, dotRadius, dotRadius)

                    -- Draw a line from the current position to the projected position
                    graphics.drawLine(drawX - 1, drawY - 1, drawNextX - 1, drawNextY - 1, 0, 255, 0)

                    -- Ditto, but for projected position using current velocity
                    graphics.fillCircle(drawNextX - dotRadius / 2, drawNextY - dotRadius / 2, dotRadius, dotRadius, 0, 255, 0)
                    graphics.drawCircle(drawNextX - dotRadius / 2, drawNextY - dotRadius / 2, dotRadius, dotRadius)
                end
            end
        end
    end
end)