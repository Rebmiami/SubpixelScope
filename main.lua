local dotRadius = 2

event.register(event.tick, function()
    local zoomEnabled = ren.zoomEnabled()
    if zoomEnabled then
        local zoomX, zoomY, zoomPixels = ren.zoomScope()
        local zWinX, zWinY, zWinPxSize, zWinSize = ren.zoomWindow()

        for i = 0, zoomPixels - 1 do
            for j = 0, zoomPixels - 1 do
                local part = sim.partID(i + zoomX, j + zoomY)

                if part then
                    local originX = zWinX + zWinPxSize * i
                    local originY = zWinY + zWinPxSize * j
                    x, y = sim.partPosition(part)
                    local drawX = originX + zWinPxSize * ((x + 0.5) % 1) - dotRadius / 2
                    local drawY = originY + zWinPxSize * ((y + 0.5) % 1) - dotRadius / 2
                    graphics.fillCircle(drawX, drawY, dotRadius, dotRadius, 255, 0, 0)
                    graphics.drawCircle(drawX, drawY, dotRadius, dotRadius)
                end
            end
        end
    end
end)