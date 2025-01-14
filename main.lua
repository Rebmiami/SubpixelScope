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

                    -- Translate particle position to screen space coordinates, scaled to fit the zoom window and adjusted for the size of the dot
                    local drawX = zWinX + zWinPxSize * (x - zoomX + 0.5) - dotRadius / 2
                    local drawY = zWinY + zWinPxSize * (y - zoomY + 0.5) - dotRadius / 2

                    -- Draw dot centered on particle's subpixel position in zoom window
                    graphics.fillCircle(drawX, drawY, dotRadius, dotRadius, 255, 0, 0)
                    graphics.drawCircle(drawX, drawY, dotRadius, dotRadius)
                end
            end
        end
    end
end)