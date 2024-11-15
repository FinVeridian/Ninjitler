-- add tutorial
-- add controls screen
-- add resume button to pause
-- add quit button to pause
-- add options button to pause
-- make pause screen translucent instead of opaque
-- add quit and options buttons to main menu
-- make menus navigable through arrow keys and enter


function love.load()
  love.window.setMode(1000, 1000, {resizable = true})
  love.window.maximize()

  titlex = love.graphics.getWidth() / 2 - 25
  titley = love.graphics.getHeight() / 2

  warning = true
  time = 0
  controls = false
  startgame = false
  options = false
  opcontrols = false
  opsound = false
  pause = false

  shoottime = 0

  startBUTTx = titlex - 75
  startBUTTy = titley + 100
  startBUTTw = 200
  startBUTTh = 50

  optionBUTTx = startBUTTx
  optionBUTTy = startBUTTy + 100
  optionBUTTw = startBUTTw
  optionBUTTh = startBUTTh

  sQUITx = startBUTTx
  sQUITy = optionBUTTy + 100
  sQUITw = startBUTTw
  sQUITh = startBUTTh

  groundlevelx = 0
  groundlevely = love.graphics.getHeight() - 50
  groundlevelw = love.graphics.getWidth()
  groundlevelh = 100

  playerx = 50
  playery = groundlevely - 100
  playerw = 50
  playerh = 100

  love.keyboard.setKeyRepeat(true)


  jump = 0

  --gravity
  gravity = 500
  velocityy = 0
  isGrounded = false

  --projectiles
  projectiles = {}
  projectileSpeed = 400

  facing = "right"

  rwalk1 = love.graphics.newImage("walk1ninjitler - right.png")
  rwalk2 = love.graphics.newImage("walk2ninjitler - right.png")
  rjump = love.graphics.newImage("jumpninjitler - right.png")
  lwalk1 = love.graphics.newImage("walk1ninjitler - left.png")
  lwalk2 = love.graphics.newImage("walk2ninjitler - left.png")
  ljump = love.graphics.newImage("jumpninjitler - left.png")

  weapon1 = love.graphics.newImage("weapon1ninjitler.png")
  weapon2 = love.graphics.newImage("weapon2ninjitler.png")


  background = love.graphics.newImage("background.png")

  animationFrame = 1
  animationTime = 0
  frameDuration = 0.75

  weaponanimationframe = 1
  weaponanimationtime = 1
  weaponframeDuration = 0.25

  resumebuttx = love.graphics.getWidth() / 2 - 100
  resumebutty = love.graphics.getHeight() / 2 - 150

  optionsbuttx = resumebuttx
  optionsbutty = resumebutty + 100

  quitbuttx = resumebuttx
  quitbutty = resumebutty + 200

  opcontrolsx = 400
  opcontrolsy = 300

  opsoundx = 400
  opsoundy = 400

  jump1 = "up"
  jump2 = "w"
  moveleft = "left"
  moveleft2 = "a"
  moveright = "right"
  moveright2 = "d"
  shoot = "x"

  tempkey = ""

  editcontrolsleft = false
  editcontrolsright = false
  editcontrolsshoot = false
  editcontrolsjump = false

  controlsleftx = 100
  controlslefty = 100

  controlsrightx = controlsleftx
  controlsrighty = 200

  controlsshootx = controlsleftx
  controlsshooty = 300

  controlsjumpx = controlsleftx
  controlsjumpy = 400

  love.graphics.setBlendMode("alpha")
end

function love.update(dt)

  if controls == true then
      if love.keyboard.isDown("space") then
          controls = false
          startgame = true
      end
  end
  if pause == false and startgame == true and options == false and opsound == false and opcontrols == false then
    time = time + dt
    shoottime = shoottime + dt
    if time >= 3 then
        warning = false
    end

    if not isGrounded then
        velocityy = velocityy + gravity * dt
        playery = playery + velocityy * dt
    end

    if playery + playerh >= groundlevely then
      playery = groundlevely - playerh
      velocityy = 0
      isGrounded = true
      jump = 0
    else
      isGrounded = false
    end
      if love.keyboard.isDown(moveleft) or love.keyboard.isDown(moveleft2) then
          playerx = playerx - 2.5
          facing = "left"
      end

      if love.keyboard.isDown(moveright) or love.keyboard.isDown(moveright2) then
          playerx = playerx + 2.5
          facing = "right"
      end

      animationTime = animationTime + dt
      if animationTime >= frameDuration then
          animationTime = animationTime - frameDuration
          animationFrame = animationFrame + 1
          if animationFrame > 2 then
              animationFrame = 1
          end
      end

      weaponanimationtime = weaponanimationtime + dt
      if weaponanimationtime >= weaponframeDuration then
          weaponanimationtime = weaponanimationtime - weaponframeDuration
          weaponanimationframe = weaponanimationframe + 1
          if weaponanimationframe > 2 then
              weaponanimationframe = 1
          end
      end

      for i = #projectiles, 1, -1 do
        local projectile = projectiles[i]
        if projectile.direction == "right" then
            projectile.x = projectile.x + projectileSpeed * dt
        elseif projectile.direction == "left" then
            projectile.x = projectile.x - projectileSpeed * dt
        end
        if projectile.x > love.graphics.getWidth() then
            table.remove(projectiles, i)
        end
    end
  end
end

function love.draw()
  if warning == true then
      love.graphics.clear()
      love.graphics.print("i am jewish, so this is ok", titlex, titley)
      love.graphics.print("- the developer", titlex, titley + 50)
  else
      if startgame == false then
          --title
          love.graphics.print("NINJITLER", titlex, titley)

          --start button
          love.graphics.rectangle("line", startBUTTx, startBUTTy, startBUTTw, startBUTTh)
          love.graphics.print("START GAME", startBUTTx + 60, startBUTTy + 15)
          --options on start screen
          --love.graphics.rectangle("line", optionBUTTx, optionBUTTy, optionBUTTw, optionBUTTh)
          --quit button
          love.graphics.rectangle("line", sQUITx, sQUITy, sQUITw, sQUITh)
          love.graphics.print("QUIT", sQUITx + 80, sQUITy + 15)
      end
      --controls
      if controls == true then
          love.graphics.clear()
          love.graphics.print(moveleft .. " or " .. moveleft2 .. " to move left", 100, 100)
          love.graphics.print(moveright .. " or " .. moveright2 .. " to move right", 100, 150)
          love.graphics.print(shoot  .. " to shoot swastiken", 100, 200)
          love.graphics.print(jump1 .. " or " .. jump2 .. " to jump", 100, 250)
          love.graphics.print("press space to continue", love.graphics.getWidth() / 2, love.graphics.getHeight() - 250)
      end
      if startgame == true then
          --background
          love.graphics.draw(background, 0, 0)
          --ground
          love.graphics.rectangle("fill", groundlevelx, groundlevely, groundlevelw, groundlevelh)

          --player
          if isGrounded then
              if facing == "right" then
                  if animationFrame == 1 then
                      love.graphics.draw(rwalk1, playerx, playery, 0)
                  elseif animationFrame == 2 then
                      love.graphics.draw(rwalk2, playerx, playery, 0)
                  end
              elseif facing == "left" then
                  if animationFrame == 1 then
                      love.graphics.draw(lwalk1, playerx, playery, 0)
                  elseif animationFrame == 2 then
                      love.graphics.draw(lwalk2, playerx, playery, 0)
                  end
              end
          else
              if facing == "right" then
                  love.graphics.draw(rjump, playerx, playery, 0)
              elseif facing == "left" then
                  love.graphics.draw(ljump, playerx, playery, 0)
              end
          end
          --pause
          if pause == true then
            love.graphics.setColor(0, 0, 0, .5)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            love.graphics.setColor(255, 255, 255, 255)

            love.graphics.rectangle("line", resumebuttx, resumebutty, 200, 50) -- resume
            love.graphics.print("resume", resumebuttx + 75, resumebutty + 15)
            love.graphics.rectangle("line", optionsbuttx, optionsbutty, 200, 50) -- options
            love.graphics.print("options", optionsbuttx + 75, optionsbutty + 15)
            love.graphics.rectangle("line", quitbuttx, quitbutty, 200, 50) -- quit
            love.graphics.print("quit", quitbuttx + 75, quitbutty + 15)
        end
          --options
          if options == true then
            love.graphics.setColor(0, 0, 0, .5)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            love.graphics.setColor(255, 255, 255, 255)
              love.graphics.rectangle("line", opcontrolsx, opcontrolsy, 200, 50) -- edit controls
              love.graphics.print("controls", opcontrolsx + 75, opcontrolsy + 15)
              love.graphics.rectangle("line", opsoundx, opsoundy, 200, 50) -- sound
              love.graphics.print("audio", opsoundx + 75, opsoundy + 15)
          end
          --controls settings
          if opcontrols == true then
            love.graphics.setColor(0, 0, 0, .5)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            love.graphics.setColor(255, 255, 255, 255)
            --left
              love.graphics.print("left", 100, 65)
              love.graphics.rectangle("line", 175, 50, 200, 50)
              love.graphics.print(moveleft, 200, 65)
              love.graphics.rectangle("line", 475, 50, 200, 50)
              love.graphics.print(moveleft2, 500, 65)
              love.graphics.rectangle("line", 775, 50, 200, 50)
              --right
              love.graphics.print("right", 100, 165)
              love.graphics.rectangle("line", 175, 150, 200, 50)
              love.graphics.print(moveright, 200, 165)
              love.graphics.rectangle("line", 475, 150, 200, 50)
              love.graphics.print(moveright2, 500, 165)
              love.graphics.rectangle("line", 775, 150, 200, 50)
              --jump
              love.graphics.print("jump", 100, 265)
              love.graphics.rectangle("line", 175, 250, 200, 50)
              love.graphics.print(jump1, 200, 265)
              love.graphics.rectangle("line", 475, 250, 200, 50)
              love.graphics.print(jump2, 500, 265)
              love.graphics.rectangle("line", 775, 250, 200, 50)
              --shoot
              love.graphics.print("shoot", 100, 365)
              love.graphics.rectangle("line", 175, 350, 200, 50)
              love.graphics.print(shoot, 200, 365)
              love.graphics.rectangle("line", 475, 350, 200, 50)
              --love.graphics.print(shoot, 500, 365)
              love.graphics.rectangle("line", 775, 350, 200, 50)

          end
          --sound settings
          if opsound == true then
            love.graphics.setColor(0, 0, 0, .5)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            love.graphics.setColor(255, 255, 255, 255)
          end
          --projectiles
          for _, projectile in ipairs(projectiles) do
              if weaponanimationframe == 1 then
                  love.graphics.draw(weapon1, projectile.x, projectile.y, 0)
              elseif weaponanimationframe == 2 then
                  love.graphics.draw(weapon2, projectile.x - 1, projectile.y - 1, 0)
              end
          end
      end
  end
end

function love.mousepressed(x, y, k)
  if k == 1 then
      if startgame == false and warning == false then
          if x > startBUTTx and x < startBUTTx + startBUTTw and y > startBUTTy and y < startBUTTy + startBUTTh then
              controls = true
          end
          --if x > optionBUTTx and x < optionBUTTx + optionBUTTw and y > optionBUTTy and y < optionBUTTy + optionBUTTh then
          --end
          if x > sQUITx and x < sQUITx + sQUITw and y > sQUITy and y < sQUITy + sQUITh then
            love.event.quit()
          end
      end
      if warning == true then
          warning = false
      end
      if pause == true then
          if x > resumebuttx and x < resumebuttx + 200 and y > resumebutty and y < resumebutty + 50 then
              pause = false
          end
          if x > optionsbuttx and x < optionsbuttx + 200 and y > optionsbutty and y < optionsbutty + 50 then
              options = true
              pause = false
          end
          if x > quitbuttx and x < quitbuttx + 200 and y > quitbutty and y < quitbutty + 50 then
              pause = false
              startgame = false
          end
      end
      if options == true  or startoptions == true then
          if x > opcontrolsx and x < opcontrolsx + 200 and y > opcontrolsy and y < opcontrolsy + 50 then
              options = false
              opcontrols = true
          end
          if x > opsoundx and x < opsoundx + 200 and y > opsoundy and y < opsoundy + 50 then
              options = false
              opsound = true
          end
      end
      if opcontrols == true then

      end
  end
end

function love.textInput(t)
  if editcontrolsleft == true then
      if t.size() >= 1 then
          left = t
          editcontrolsleft = false
      end
  end
  if editcontrolsright == true then
      if t.size() >= 1 then
          right = t
          editcontrolsright = false
      end
  end
  if editcontrolsshoot == true then
      if t.size() >= 1 then
          shoot = t
          editcontrolsshoot = false
      end
  end
  if editcontrolsjump == true then
      if t.size() >= 1 then
          jump1 = t
          editcontrolsjump = false
      end
  end
end

function love.keypressed(key, scancode)
  if startgame == true then
      --pause
      if pause == false and options == false and opcontrols == false and opsound == false then
          if key == "escape" then
              pause = true
          end

          if key == jump1 or key == jump2 then
              if isGrounded or jump == 1 then
                  velocityy = -500
                  isGrounded = false
                  jump = jump + 1
              end
          end

          if key == shoot and shoottime >= 1 then
              shootProjectile()
              shoottime = 0
          end
      elseif pause == true then
          if key == "escape" then
              pause = false
          end
      end

      if options == true then
          if key == "escape" then
              pause = true
              options = false
          end
      end

      if opcontrols == true then
          if key == "escape" then
              opcontrols = false
              options = true
          end
      end
      if opsound == true then
        if key == "escape" then
          opsound = false
          options = true
        end
      end
  end
  if startgame == false then
    if key == "escape" then
      love.event.quit()
    end
  end
end

function shootProjectile()
  local x
  local y = playery + playerh / 2

  if facing == "right" then
      x = playerx + playerw
  elseif facing == "left" then
      x = playerx - 10
  end
  local projectile = {
      x = x,
      y = y,
      width = 10,
      height = 5,
      direction = facing
  }
  table.insert(projectiles, projectile)
end
