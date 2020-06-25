WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

push = require 'push'

gameState = 'start'

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('font.TTF', 8)

    scoreFont = love.graphics.newFont('font.TTF', 30)

    player1Score = 0
    player2Score = 0

    player1y = 30
    player2y = VIRTUAL_HEIGHT - 40

    ballx = VIRTUAL_WIDTH / 2 - 2
    bally = VIRTUAL_HEIGHT / 2 - 2

    balldx = math.random(2) == 1 and -100 or 100
    balldy = math.random(-50, 50)
    

    

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1y = math.max(0, player1y - PADDLE_SPEED * dt)

    elseif love.keyboard.isDown('s') then
        player1y = math.min(VIRTUAL_HEIGHT -24, player1y + PADDLE_SPEED * dt)

    end

    if love.keyboard.isDown('up') then
        player2y = math.max(0, player2y - PADDLE_SPEED * dt)

    elseif love.keyboard.isDown('down') then
        player2y = math.min(VIRTUAL_HEIGHT - 24, player2y + PADDLE_SPEED * dt)

    end    

    if gameState == 'play' then 
        ballx = ballx + balldx * dt
        bally = bally + balldy * dt
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

            ballx = VIRTUAL_WIDTH / 2 - 2
            bally = VIRTUAL_HEIGHT / 2 - 2
        
            balldx = math.random(2) == 1 and -100 or 100
            balldy = math.random(-50, 50)
        end
    end


end    

function love.draw()
    push:apply('start')
    
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    love.graphics.rectangle('fill', ballx, bally, 5, 5)

    love.graphics.rectangle('fill', 10, player1y, 2, 25)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2y, 2, 25)

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