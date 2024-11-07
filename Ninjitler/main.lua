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

  titlex = love.graphics.getWidth() / 2
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

  resumebuttx = love.graphics.getWidth() / 2
  resumebutty = love.graphics.getHeight() / 2 - 150

  optionsbuttx = resumebuttx
  optionsbutty = resumebutty + 100

  quitbuttx = resumebuttx
  quitbutty = resumebutty + 200

  opcontrolsx = 100
  opcontrolsy = 100

  opsoundx = 100
  opsoundy = 200

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
end

function love.update(dt)
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
  if controls == true then
      if love.keyboard.isDown("space") then
          controls = false
          startgame = true
      end
  end
  if pause == false and startgame == true then
      if love.keyboard.isDown(moveleft or moveleft2) then
          playerx = playerx - 2.5
          facing = "left"
      end

      if love.keyboard.isDown(moveright or moveright2) then
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
          love.graphics.rectangle("fill", startBUTTx, startBUTTy, startBUTTw, startBUTTh)
      end
      --controls
      if controls == true then
          love.graphics.clear()
          love.graphics.print("arrow keys or wasd to move", 100, 100)
          love.graphics.print("x to shoot swastiken", 100, 150)
          love.graphics.print("up or w to jump", 100, 200)
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
              love.graphics.clear()

              love.graphics.rectangle("fill", resumebuttx, resumebutty, 100, 50) -- resume
              love.graphics.rectangle("fill", optionsbuttx, optionsbutty, 100, 50) -- options
              love.graphics.rectangle("fill", quitbuttx, quitbutty, 100, 50) -- quit
          end
          --options
          if options == true then
              love.graphics.clear()

              love.graphics.rectangle("fill", opcontrolsx, opcontrolsy, 100, 50) -- edit controls
              love.graphics.rectangle("fill", opsoundx, opsoundy, 100, 50) -- sound
          end
          --controls settings
          if opcontrols == true then
              love.graphics.clear()

              love.graphics.rectangle("fill", controlsleftx, controlslefty, 100, 50)
              love.graphics.print("click to edit keybind for moving left", 175, 100)

              love.graphics.rectangle("fill", controlsrightx, controlsrighty, 100, 50)
              love.graphics.print("click to edit keybind for moving right", 175, 200)

              love.graphics.rectangle("fill", controlsshootx, controlsshooty, 100, 50)
              love.graphics.print("click to edit keybind for throwing swastikens", 175, 300)

              love.graphics.rectangle("fill", controlsjumpx, controlsjumpy, 100, 50)
              love.graphics.print("click to edit keybind for jumping", 175, 400)
          end
          --sound settings
          if opsound == true then

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
      end
      if warning == true then
          warning = false
      end
      if pause == true then
          if x > resumebuttx and x < resumebuttx + 100 and y > resumebutty and y < resumebutty + 50 then
              pause = false
          end
          if x > optionsbuttx and x < optionsbuttx + 100 and y > optionsbutty and y < optionsbutty + 50 then
              options = true
              pause = false
          end
          if x > quitbuttx and x < quitbuttx + 100 and y > quitbutty and y < quitbutty + 50 then
              pause = false
              startgame = false
          end
      end
      if options == true then
          if x > opcontrolsx and x < opcontrolsx + 100 and y > opcontrolsy and y < opcontrolsy + 50 then
              options = false
              opcontrols = true
          end
          if x > opsoundx and x < opsoundx + 100 and y > opsoundy and y < opsoundy + 50 then
              options = false
              opsound = true
          end
      end
      if opcontrols == true then
          if x > controlsleftx and x < controlsleftx + 100 and y > controlslefty and y < controlslefty + 50 then
              editcontrolsleft = true
          end
          if x > controlsrightx and x < controlsrightx + 100 and y > controlsrighty and y < controlsrighty + 50 then
              editcontrolsright = true
          end
          if x > controlsshootx and x < controlsshootx + 100 and y > controlsshooty and y < controlsshooty + 50 then
              editcontrolsshoot = true
          end
          if x > controlsjumpx and x < controlsjumpx + 100 and y > controlsjumpy and y < controlsjumpy + 50 then
              editcontrolsjump = true
          end
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
      if pause == false then
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
