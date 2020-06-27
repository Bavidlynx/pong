WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

gameState = 'start'
AImode = false
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('font.TTF', 8)
    scoreFont = love.graphics.newFont('font.TTF', 30)
    victoryFont = love.graphics.newFont('font.TTF', 40)

    sounds = {
        ['Paddle_hit'] = love.audio.newSource('paddle_hit.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('wall_hit.wav', 'static'),
        ['point_scored'] = love.audio.newSource('point_scored.wav', 'static')
    }

    player1Score = 0
    player2Score = 0

    servingPlayer = math.random(2) == 1 and 1 or 2
    winningPlayer = 0


    Paddle1 = Paddle(5, 20, 5, 25)
    Paddle2 = Paddle(VIRTUAL_WIDTH- 10, VIRTUAL_HEIGHT-30, 5, 25)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    if servingPlayer == 1 then
        ball.dx = 100
    else
        ball.dx = -100
    end

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)

    if ball.x <= 0 then
        player2Score = player2Score + 1
        servingPlayer = 1

        sounds['point_scored']:play()

        ball:reset()
        if player2Score >= 3 then
            gameState = 'victory'
            winningPlayer = 2
        else
            gameState = 'serve'
        end
    end

    if ball.x >= VIRTUAL_WIDTH - 5 then
        player1Score = player1Score + 1
        servingPlayer = 2

        sounds['point_scored']:play()

        ball:reset()
        if player1Score >= 3 then
            gameState = 'victory'
            winningPlayer = 1
        else
            gameState = 'serve'
        end
    end

    if ball:collides(Paddle1) then
        ball.dx = -ball.dx
        
        sounds['Paddle_hit']:play()
    end


    if ball:collides(Paddle2) then
        ball.dx = -ball.dx

        sounds['Paddle_hit']:play()
    end

    if ball.y <= 0 then
        ball.dy = -ball.dy

        sounds['wall_hit']:play()
    end


    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT - 4

        sounds['wall_hit']:play()
    end

    Paddle1:update(dt)
    Paddle2:update(dt)

    if love.keyboard.isDown('w') then
        Paddle1.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown('s') then
        Paddle1.dy = PADDLE_SPEED

    else
        Paddle1.dy = 0
    end

    if AImode == true then
        Paddle2.y = ball.y
    elseif love.keyboard.isDown('up') then
        Paddle2.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown('down') then
        Paddle2.dy = PADDLE_SPEED

    else
        Paddle2.dy = 0  
    end    

    if gameState == 'play' then 
        ball:update(dt)
    end
    if gameState == 'AImode' then 
        ball:update(dt)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
        elseif key == 'enter' or key == 'return' then
            if gameState == 'start' then
                gameState = 'serve'
            elseif gameState == 'serve' then
                gameState = 'play'
                ball:reset()
            elseif gameState == 'victory' then
                gameState = 'start' 
                player1Score = 0
                player2Score = 0
            end
    elseif key == 'a' then
        gameState = 'AImode'
        AImode = true
    end


end    

function love.draw()
    push:apply('start')
    
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    Paddle1:render()
    Paddle2:render()

    ball:render()

    displayFPS()
    if gameState == 'start' then
        love.graphics.printf("Welcome to Pong", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter To Play", 0, 32, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press A To Play Against Compuer", 0, 45, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter To Serve", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press A To Play Against Compuer", 0, 30, VIRTUAL_WIDTH, 'center')
    
    elseif gameState == 'victory' then
        love.graphics.setFont(victoryFont)
        love.graphics.printf("Player" .. tostring(winningPlayer) .. " won!", 0, 135, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("Press Enter To Reset", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
    
    end

    love.graphics.setFont(smallFont)

    if gameState == 'start' or 'play' then    
        love.graphics.setFont(scoreFont)
        love.graphics.print(player1Score,VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
        love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 25, VIRTUAL_HEIGHT / 3)
    end
    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1, 1 , 1, 1)
end


