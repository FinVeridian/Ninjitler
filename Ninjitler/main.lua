-- add tutorial
-- add scrolling screen function                        done
-- add controls screen                                  done
-- add resume button to pause                           done
-- add quit button to pause                             done
-- add options button to pause                          done
-- make pause screen translucent instead of opaque      done
-- add quit and options buttons to main menu            done (not options)
-- make menus navigable through arrow keys and enter
-- add controller functionality

-- total of 10 levels (not including tutorial)

-- Neville Chamberlain = Tutorial Boss (EXTREMELY EASY) in Munich
-- Albert Lebrun (French President) = Level 1 Boss (RELATIVELY EASY) in Paris
-- King Christian X (Danish King) = Level 2 Boss (EASY) in Copenhagen
-- King Leopold III (Belgian King) = Level 3 Boss (SLIGHTLY HARDER) in Brussels
--
-- General Rydz-Śmigły (Polish General) = Level 5 Boss (VERY HARD) in Warsaw

-- 1512 x 915


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
  dialogue = false

  tutorial = false
  level1 = false
  level2 = false

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

  --sprites
  rwalk1 = love.graphics.newImage("walk1ninjitler - right.png")
  rwalk2 = love.graphics.newImage("walk2ninjitler - right.png")
  rjump = love.graphics.newImage("jumpninjitler - right.png")
  lwalk1 = love.graphics.newImage("walk1ninjitler - left.png")
  lwalk2 = love.graphics.newImage("walk2ninjitler - left.png")
  ljump = love.graphics.newImage("jumpninjitler - left.png")

  weapon1 = love.graphics.newImage("weapon1ninjitler.png")
  weapon2 = love.graphics.newImage("weapon2ninjitler.png")

  background = love.graphics.newImage("background.png")
  tutorialbg = love.graphics.newImage("tutorialbg.png")

  --spriteframes
  animationFrame = 1
  animationTime = 0
  frameDuration = 0.75

  weaponanimationframe = 1
  weaponanimationtime = 1
  weaponframeDuration = 0.25

  --pause menu buttons
  resumebuttx = love.graphics.getWidth() / 2 - 100
  resumebutty = love.graphics.getHeight() / 2 - 150

  optionsbuttx = resumebuttx
  optionsbutty = resumebutty + 100

  quitbuttx = resumebuttx
  quitbutty = resumebutty + 200

  --options menu buttons
  opcontrolsx = 400
  opcontrolsy = 300

  opsoundx = 400
  opsoundy = 400

  --controls
  jump1 = "up"
  jump2 = "w"
  jump3 = "up"
  moveleft = "left"
  moveleft2 = "a"
  moveleft3 = "left"
  moveright = "right"
  moveright2 = "d"
  moveright3 = "right"
  shoot = "x"
  shoot2 = "x"
  shoot3 = "x"

  tempkey = ""

  editcontrolsleft1 = false
  editcontrolsleft2 = false
  editcontrolsleft3 = false
  editcontrolsright1 = false
  editcontrolsright2 = false
  editcontrolsright3 = false
  editcontrolsshoot1 = false
  editcontrolsshoot2 = false
  editcontrolsshoot3 = false
  editcontrolsjump1 = false
  editcontrolsjump2 = false
  editcontrolsjump3 = false

  --controls menu buttons
  controlsleftx = 100
  controlslefty = 100

  controlsrightx = controlsleftx
  controlsrighty = 200

  controlsshootx = controlsleftx
  controlsshooty = 300

  controlsjumpx = controlsleftx
  controlsjumpy = 400

  --audio menu buttons
  sliderX = 100
  sliderY = 200
  sliderWidth = 400
  sliderHeight = 20

  sliderValue = 0.5

  --music
  music = love.audio.newSource("music.mp3", "stream")
  music:setLooping(true)

  screenwidth = love.graphics.getWidth()
  screenheight = love.graphics.getHeight()
  camerax = 0
  scrollmargin = 250
  worldwidth = 3200
end

function love.update(dt)
  if controls == true then
      if love.keyboard.isDown("space") then
          controls = false
          startgame = true
          tutorial = true
      end
  end

  if startgame == true then
    music:play(music)
  end

  if pause == false and startgame == true and options == false and opsound == false and opcontrols == false and dialogue == false then
    time = time + dt
    shoottime = shoottime + dt
    if time >= 3 then
        warning = false
    end

    if playerx < camerax + scrollmargin then
      -- Player is too close to the left edge, scroll left
      camerax = playerx - scrollmargin
    elseif playerx > camerax + screenwidth - scrollmargin then
      -- Player is too close to the right edge, scroll right
      camerax = playerx - screenwidth + scrollmargin
    end

    camerax = math.max(0, math.min(camerax, worldwidth - screenwidth))


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
      if love.keyboard.isDown(moveleft) or love.keyboard.isDown(moveleft2) or love.keyboard.isDown(moveleft3) then
          playerx = playerx - 2.5
          facing = "left"
      end

      if love.keyboard.isDown(moveright) or love.keyboard.isDown(moveright2) or love.keyboard.isDown(moveright3) then
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
        if projectile.x > love.graphics.getWidth() + camerax then
            table.remove(projectiles, i)
        end
    end
  end
  if opsound == true then
    if isDragging then
      local mouseX = love.mouse.getX()
      sliderValue = math.min(math.max((mouseX - sliderX) / sliderWidth, 0), 1)
      music:setVolume(sliderValue)  -- Set music volume to the slider value
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
          --love.graphics.draw(background, 0, 0)
          --ground
          --love.graphics.rectangle("fill", groundlevelx, groundlevely, groundlevelw, groundlevelh)

          --tutorial
          if tutorial == true then
            --background
            love.graphics.draw(tutorialbg, 0, 0)

            --ground
            love.graphics.rectangle("fill", groundlevelx, groundlevely, groundlevelw, groundlevelh)

            --welcome text
            love.graphics.setColor(0, 0, 0, .8)
            love.graphics.rectangle("fill", 100 - camerax, 100, 500, 100)
            love.graphics.setColor(255, 255, 255, 1)
            love.graphics.print("Wilkommen aus München! (you're not getting anymore German out of me)", 125 - camerax, 125)
            love.graphics.print("Neville Chamberlain is here. go meet him!", 125 - camerax, 165)


          end

          love.graphics.push()
          love.graphics.translate(-camerax, 0)

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

          love.graphics.pop()

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
            -- Left controls
            love.graphics.print("left", 100, 65)
            drawControl(175, 50, 200, 50, moveleft, editcontrolsleft1)
            drawControl(475, 50, 200, 50, moveleft2, editcontrolsleft2)
            drawControl(775, 50, 200, 50, moveleft3, editcontrolsleft3)

            -- Right controls
            love.graphics.print("right", 100, 165)
            drawControl(175, 150, 200, 50, moveright, editcontrolsright1)
            drawControl(475, 150, 200, 50, moveright2, editcontrolsright2)
            drawControl(775, 150, 200, 50, moveright3, editcontrolsright3)

            -- Jump controls
            love.graphics.print("jump", 100, 265)
            drawControl(175, 250, 200, 50, jump1, editcontrolsjump1)
            drawControl(475, 250, 200, 50, jump2, editcontrolsjump2)
            drawControl(775, 250, 200, 50, jump3, editcontrolsjump3)

            -- Shoot controls
            love.graphics.print("shoot", 100, 365)
            drawControl(175, 350, 200, 50, shoot, editcontrolsshoot1)
            drawControl(475, 350, 200, 50, shoot2, editcontrolsshoot2)
            drawControl(775, 350, 200, 50, shoot3, editcontrolsshoot3)
          end
          --sound settings
          if opsound == true then
            love.graphics.setColor(0, 0, 0, .5)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            love.graphics.setColor(255, 255, 255, 255)

            love.graphics.setColor(0.5, 0.5, 0.5)
            love.graphics.rectangle("fill", sliderX, sliderY, sliderWidth, sliderHeight)

            love.graphics.setColor(0, 0, 0)
            knobX = sliderX + sliderValue * sliderWidth - 10
            love.graphics.rectangle("fill", knobX, sliderY - 10, 20, sliderHeight + 20)

            love.graphics.setColor(1, 1, 1)
            love.graphics.print("Volume: " .. math.floor(sliderValue * 100) .. "%", 100, 100)
          end
          --projectiles
          for _, projectile in ipairs(projectiles) do
              if weaponanimationframe == 1 then
                  love.graphics.draw(weapon1, projectile.x - camerax, projectile.y, 0)
              elseif weaponanimationframe == 2 then
                  love.graphics.draw(weapon2, projectile.x - 1 - camerax, projectile.y - 1, 0)
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
        --left1
        if x > 175 and x < 175 + 200 and y > 50 and y < 50 + 50 then
          editcontrolsleft1 = true
          love.keyboard.setTextInput(true)
        end
        --left2
        if x > 475 and x < 475 + 200 and y > 50 and y < 50 + 50 then
          editcontrolsleft2 = true
          love.keyboard.setTextInput(true)

        end
        --left3 / controller?
        if x > 775 and x < 775 + 200 and y > 50 and y < 50 + 50 then
          editcontrolsleft3 = true
          love.keyboard.setTextInput(true)
        end
        --right1
        if x > 175 and x < 175 + 200 and y > 150 and y < 50 + 150 then
          editcontrolsright1 = true
          love.keyboard.setTextInput(true)
        end
        --right2
        if x > 475 and x < 475 + 200 and y > 150 and y < 150 + 50 then
          editcontrolsright2 = true
          love.keyboard.setTextInput(true)
        end
        --right3 / controller?
        if x > 775 and x < 775 + 200 and y > 150 and y < 150 + 50 then
          editcontrolsright3 = true
          love.keyboard.setTextInput(true)
        end
        --jump1
        if x > 175 and x < 175 + 200 and y > 250 and y < 250 + 50 then
          editcontrolsjump1 = true
          love.keyboard.setTextInput(true)
        end
        --jump2
        if x > 475 and x < 475 + 200 and y > 250 and y < 250 + 50 then
          editcontrolsjump2 = true
          love.keyboard.setTextInput(true)
        end
        --jump3 / controller?
        if x > 775 and x < 775 + 200 and y > 250 and y < 250 + 50 then
          editcontrolsjump3 = true
          love.keyboard.setTextInput(true)
        end
        --shoot1
        if x > 175 and x < 175 + 200 and y > 350 and y < 350 + 50 then
          editcontrolsshoot1 = true
          love.keyboard.setTextInput(true)
        end
        --shoot2
        if x > 475 and x < 475 + 200 and y > 350 and y < 350 + 50 then
          editcontrolsshoot2 = true
          love.keyboard.setTextInput(true)
        end
        --shoot3 / controller?
        if x > 775 and x < 775 + 200 and y > 350 and y < 350 + 50 then
          editcontrolsshoot3 = true
          love.keyboard.setTextInput(true)
        end
      end
      if opsound == true then
        if x >= sliderX and x <= sliderX + sliderWidth and y >= sliderY and y <= sliderY + sliderHeight then
          isDragging = true
        end
      end
  end
end

function love.mousereleased(x, y, k)
  if opsound == true then
    isDragging = false
  end
end

function love.keypressed(key, scancode)
  if startgame == true then
      --pause
      if pause == false and options == false and opcontrols == false and opsound == false then
          if key == "escape" then
              pause = true
          end

          if key == jump1 or key == jump2 or key == jump3 then
              if isGrounded or jump == 1 then
                  velocityy = -500
                  isGrounded = false
                  jump = jump + 1
              end
          end

          if (key == shoot or key == shoot2 or key == shoot3) and shoottime >= 1 then
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
  --edit controls
  --edit left
  if editcontrolsleft1 == true then
    if #key == 1 then
      moveleft = key:lower()
      editcontrolsleft1 = false
    else
      if key == "up" then
        moveleft = "up"
        editcontrolsleft1 = false
      elseif key == "down" then
        moveleft = "down"
        editcontrolsleft1 = false
      elseif key == "left" then
        moveleft = "left"
        editcontrolsleft1 = false
      elseif key == "right" then
        moveleft = "right"
        editcontrolsleft1 = false
      elseif key == "space" then
        moveleft = "space"
        editcontrolsleft1 = false
      end
    end
  end
  if editcontrolsleft2 == true then
    if #key == 1 then
      moveleft2 = key:lower()
      editcontrolsleft2 = false
    else
      if key == "up" then
        moveleft2 = "up"
        editcontrolsleft2 = false
      elseif key == "down" then
        moveleft2 = "down"
        editcontrolsleft2 = false
      elseif key == "left" then
        moveleft2 = "left"
        editcontrolsleft2 = false
      elseif key == "right" then
        moveleft2 = "right"
        editcontrolsleft2 = false
      elseif key == "space" then
        moveleft2 = "space"
        editcontrolsleft2 = false
      end
    end
  end
  if editcontrolsleft3 == true then
    if #key == 1 then
      moveleft3 = key:lower()
      editcontrolsleft3 = false
    else
      if key == "up" then
        moveleft3 = "up"
        editcontrolsleft3 = false
      elseif key == "down" then
        moveleft3 = "down"
        editcontrolsleft3 = false
      elseif key == "left" then
        moveleft3 = "left"
        editcontrolsleft3 = false
      elseif key == "right" then
        moveleft3 = "right"
        editcontrolsleft3 = false
      elseif key == "space" then
        moveleft3 = "space"
        editcontrolsleft3 = false
      end
    end
  end
  --edit right
  if editcontrolsright1 == true then
    if #key == 1 then
      moveright = key:lower()
      editcontrolsright1 = false
    else
      if key == "up" then
        moveright = "up"
        editcontrolsright1 = false
      elseif key == "down" then
        moveright = "down"
        editcontrolsright1 = false
      elseif key == "left" then
        moveright = "left"
        editcontrolsright1 = false
      elseif key == "right" then
        moveright = "right"
        editcontrolsright1 = false
      elseif key == "space" then
        moveright = "space"
        editcontrolsright1 = false
      end
    end
  end
  if editcontrolsright2 == true then
    if #key == 1 then
      moveright2 = key:lower()
      editcontrolsright2 = false
    else
      if key == "up" then
        moveright2 = "up"
        editcontrolsright2 = false
      elseif key == "down" then
        moveright2 = "down"
        editcontrolsright2 = false
      elseif key == "left" then
        moveright2 = "left"
        editcontrolsright2 = false
      elseif key == "right" then
        moveright2 = "right"
        editcontrolsright2 = false
      elseif key == "space" then
        moveright2 = "space"
        editcontrolsright2 = false
      end
    end
  end
  if editcontrolsright3 == true then
    if #key == 1 then
      moveright3 = key:lower()
      editcontrolsright3 = false
    else
      if key == "up" then
        moveright3 = "up"
        editcontrolsright3 = false
      elseif key == "down" then
        moveright3 = "down"
        editcontrolsright3 = false
      elseif key == "left" then
        moveright3 = "left"
        editcontrolsright3 = false
      elseif key == "right" then
        moveright3 = "right"
        editcontrolsright3 = false
      elseif key == "space" then
        moveright3 = "space"
        editcontrolsright3 = false
      end
    end
  end
  --edit jump
  if editcontrolsjump1 == true then
    if #key == 1 then
      jump1 = key:lower()
      editcontrolsjump1 = false
    else
      if key == "up" then
        jump1 = "up"
        editcontrolsjump1 = false
      elseif key == "down" then
        jump1 = "down"
        editcontrolsjump1 = false
      elseif key == "left" then
        jump1 = "left"
        editcontrolsjump1 = false
      elseif key == "right" then
        jump1 = "right"
        editcontrolsjump1 = false
      elseif key == "space" then
        jump1 = "space"
        editcontrolsjump1 = false
      end
    end
  end
  if editcontrolsjump2 == true then
    if #key == 1 then
      jump2 = key:lower()
      editcontrolsjump2 = false
    else
      if key == "up" then
        jump2 = "up"
        editcontrolsjump2 = false
      elseif key == "down" then
        jump2 = "down"
        editcontrolsjump2 = false
      elseif key == "left" then
        jump2 = "left"
        editcontrolsjump2 = false
      elseif key == "right" then
        jump2 = "right"
        editcontrolsjump2 = false
      elseif key == "space" then
        jump2 = "space"
        editcontrolsjump2 = false
      end
    end
  end
  if editcontrolsjump3 == true then
    if #key == 1 then
      jump3 = key:lower()
      editcontrolsjump3 = false
    else
      if key == "up" then
        jump3 = "up"
        editcontrolsjump3 = false
      elseif key == "down" then
        jump3 = "down"
        editcontrolsjump3 = false
      elseif key == "left" then
        jump3 = "left"
        editcontrolsjump3 = false
      elseif key == "right" then
        jump3 = "right"
        editcontrolsjump3 = false
      elseif key == "space" then
        jump3 = "space"
        editcontrolsjump3 = false
      end
    end
  end
  --edit shoot
  if editcontrolsshoot1 == true then
    if #key == 1 then
      shoot = key:lower()
      editcontrolsshoot1 = false
    else
      if key == "up" then
        shoot = "up"
        editcontrolsshoot1 = false
      elseif key == "down" then
        shoot = "down"
        editcontrolsshoot1 = false
      elseif key == "left" then
        shoot = "left"
        editcontrolsshoot1 = false
      elseif key == "right" then
        shoot = "right"
        editcontrolsshoot1 = false
      elseif key == "space" then
        shoot = "space"
        editcontrolsshoot1 = false
      end
    end
  end
  if editcontrolsshoot2 == true then
    if #key == 1 then
      shoot2 = key:lower()
      editcontrolsshoot2 = false
    else
      if key == "up" then
        shoot2 = "up"
        editcontrolsshoot2 = false
      elseif key == "down" then
        shoot2 = "down"
        editcontrolsshoot2 = false
      elseif key == "left" then
        shoot2 = "left"
        editcontrolsshoot2 = false
      elseif key == "right" then
        shoot2 = "right"
        editcontrolsshoot2 = false
      elseif key == "space" then
        shoot2 = "space"
        editcontrolsshoot2 = false
      end
    end
  end
  if editcontrolsshoot3 == true then
    if #key == 1 then
      shoot3 = key:lower()
      editcontrolsshoot3 = false
    else
      if key == "up" then
        shoot3 = "up"
        editcontrolsshoot3 = false
      elseif key == "down" then
        shoot3 = "down"
        editcontrolsshoot3 = false
      elseif key == "left" then
        shoot3 = "left"
        editcontrolsshoot3 = false
      elseif key == "right" then
        shoot3 = "right"
        editcontrolsshoot3 = false
      elseif key == "space" then
        shoot3 = "space"
        editcontrolsshoot3 = false
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

function drawControl(x, y, width, height, label, controlVar)
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
