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

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('font.TTF', 8)

    scoreFont = love.graphics.newFont('font.TTF', 30)

    player1Score = 0
    player2Score = 0

    Paddle1 = Paddle(5, 20, 5, 25)
    Paddle2 = Paddle(VIRTUAL_WIDTH- 10, VIRTUAL_HEIGHT-30, 5, 25)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })
end

function love.update(dt)

    if ball:collides(Paddle1) then
        ball.dx = -ball.dx
    end

    if ball:collides(Paddle2) then
        ball.dx = -ball.dx
    end

    if ball.y <= 0 then
        ball.dy = -ball.dy
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT - 4
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

    if love.keyboard.isDown('up') then
        Paddle2.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown('down') then
        Paddle2.dy = PADDLE_SPEED

    else
        Paddle2.dy = 0  
    end    

    if gameState == 'play' then 
        ball:update(dt)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        elseif gameState == 'play' then
            gameState = 'start'
            ball:reset()
        end
    end


end    

function love.draw()
    push:apply('start')
    
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    Paddle1:render()
    Paddle2:render()

    ball:render()

    displayFPS()

    love.graphics.setFont(smallFont)

    if gameState == 'start' then    
        love.graphics.printf("hello start state" ,
        0,
        20,
        VIRTUAL_WIDTH,
        'center')
        love.graphics.setFont(scoreFont)
        love.graphics.print(player1Score,VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
        love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 25, VIRTUAL_HEIGHT / 3)
    elseif gameState == 'play' then
        love.graphics.printf("hello play state" ,
        0,
        20,
        VIRTUAL_WIDTH,
        'center')
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


