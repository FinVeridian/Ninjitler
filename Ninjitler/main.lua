function love.load()
    love.window.setMode(1000, 1000, {resizable = true})
    love.window.maximize()

    titlex = love.graphics.getWidth() / 2
    titley = love.graphics.getHeight() / 2
    
    warning = true
    time = 0

    shoottime = 0

    startBUTTx = titlex - 75
    startBUTTy = titley + 100
    startBUTTw = 200
    startBUTTh = 50

    startgame = false

    groundlevelx = 0
    groundlevely = love.graphics.getHeight() - 50
    groundlevelw = love.graphics.getWidth()
    groundlevelh = 100

    playerx = 50
    playery = groundlevely - 100
    playerw = 50
    playerh = 100

    love.keyboard.setKeyRepeat(true)

    pause = false

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

    background = love.graphics.newImage("background.png")

    animationFrame = 1
    animationTime = 0
    frameDuration = 0.75
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
    if pause == false and startgame == true then
        if love.keyboard.isDown("left") then
            playerx = playerx - 5
            facing = "left"
        end

        if love.keyboard.isDown("right") then
            playerx = playerx + 5
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
            end
            for _, projectile in ipairs(projectiles) do
                love.graphics.rectangle("fill", projectile.x, projectile.y, projectile.width, projectile.height)
            end
        end
    end
end

function love.mousepressed(x, y, k)
    if k == 1 then
        if startgame == false and warning == false then
            if x > startBUTTx and x < startBUTTx + startBUTTw and y > startBUTTy and y < startBUTTy + startBUTTh then
                startgame = true
            end
        end
        if warning == true then
            warning = false
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
            
            --jump
            
            if key == "space" or key == "up" then
                if  isGrounded or jump == 1 then
                    velocityy = -500
                    isGrounded = false
                    jump = jump + 1
                end
            end

            if key == "s" and shoottime >= 1 then
                shootProjectile()
                shoottime = 0
            end
        elseif pause == true then
            if key == "escape" then
                pause = false
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
