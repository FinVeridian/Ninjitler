graphical = {}

function graphical.drawControl(x, y, width, height, label, controlVar)
    -- Check if we're editing this control
    if controlVar then
        love.graphics.setColor(255, 0, 0)  -- Highlight the control in red
    else
        love.graphics.setColor(255, 255, 255)  -- Default color
    end
    -- Draw the rectangle for the control
    love.graphics.rectangle("line", x, y, width, height)
    -- Draw the label
    love.graphics.print(label, x + 25, y + 15)
end

function graphical.drawButton(texture, selectedtex, x, y, width, height, label, selected)
  if texture then
    if selected then
      love.graphics.draw(selectedtex, x, y, texture:width(), texture:height())
    else
      love.graphics.draw(texture, x, y, texture:width(), texture:height())
    end
  else
    if selected then
      love.graphics.setColor(128, 255, 0)
    else
      love.graphics.setColor(255, 255, 255)
    end

    love.graphics.rectangle("line", x, y, width, height)
    love.graphics.print(label, x + 25, y + 15)
  end
end

function graphical.drawobstacle(x, y, width, height, texture)
    obw = width
    obh = height
    oby = y
    obx = x
    -- Draw the obstacle
    if texture then
      love.graphics.draw(texture, x - camerax, y, width, height)
    else
      love.graphics.rectangle("fill", x - camerax, y, width, height)
    end

    if checkCollision(playerx, playery, playerw, playerh, x, y, width, height) then
      -- If moving left and colliding, revert the player's position
      if facing == "left" then
          playerx = originalX -- Revert to previous position to prevent passing through obstacle
      end
      -- If moving right and colliding, revert the player's position
      if facing == "right" then
          playerx = originalX -- Revert to previous position to prevent passing through obstacle
      end
    end
    if playerx < x + width and playerx + playerw > x and playery + playerh <= y + 3 and playery + playerh > y then
      velocityy = 0
      isGrounded = true
      jump = 0
      playery = originalY
    end
    --if (projectile.x >= x and projectile.x <= x + width and projectile.y >= y and projectile.y <= y + height) then
      --table.remove(projectiles, i)
    --end
end

function checkCollision(px, py, pw, ph, ox, oy, ow, oh)
    -- Check if player collides with the obstacle using AABB (Axis-Aligned Bounding Box) method
    return px < ox + ow and
           px + pw > ox and
           py < oy + oh and
           py + ph > oy
end

return graphical
