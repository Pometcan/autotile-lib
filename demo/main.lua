
local mode = "create"
local select = {false,0,0,0,0}
local mbtn = 0
local grid = false

require("tile")
require("sprite")
love.load = function ()
  lgrap = love.graphics
  lgrap.setBackgroundColor(unpack({0.1,0.5,0.8}))
  ww = lgrap.getWidth()
  wh = lgrap.getHeight()
  tilePic = {}
  for i = 1, 3 do
    tilePic[i] = createSprite("imgs/tile"..i..".png",{row=3,col=3},32,32)
  end
  tilePic[4] = createSprite("imgs/tile4.png",{row=3,col=3},8,8)
  tilemap = {}
end

love.draw = function ()
    tiledraw()
    if mode == "edit" then
      lgrap.print("Mode : Edit",10,10)
    elseif mode == "create" then
      lgrap.print("Mode : Create",10,10)
    elseif mode == "move" then
      lgrap.print("Mode : Move",10,10)
    elseif mode == "remove" then
      lgrap.print("Mode : Remove",10,10)
    end
    lgrap.print("Grid : "..tostring(grid),10,30)
    lgrap.print("select : "..select[2].." : "..select[3].." : "..select[4].." : "..select[5],10,50)
    lgrap.setColor(0.6,0.1,0.1,0.2)
    lgrap.rectangle("fill",select[2],select[3],select[4],select[5])
    lgrap.setColor(1,1,1,1)
    lgrap.rectangle("line",select[2],select[3],select[4],select[5])
    lgrap.print("Keys\nmode key : a | grid key : s | tile control key : d | change sprite : mouse scroll click",10,wh-30)
end

love.mousemoved = function(x,y)
  if select[1] == false and mbtn == 1 and select[2] ~= 0 then
    select[4] = x-math.abs(select[2])
    select[5] = y-math.abs(select[3])
  end

  if (mbtn == 1 or mbtn == 2) and mode == "edit" then
    tilemouse(x,y,mbtn)
  end
  --tilesource({x=x,y=y})
end

love.mousepressed = function(x,y,btn)
  if mode == "edit" then
    tilemouse(x,y,btn)
  elseif mode == "create" then
    if btn == 1 then
      select[1] = false
      select[2] = x
      select[3] = y
    end
  elseif mode == "move" then
    tilemove(tilesource({x=x,y=y}),x,y)
  elseif mode == "remove" then
    tileremove(tilesource({x=x,y=y}))
  end
  mbtn = btn
end

love.mousereleased = function(x,y,btn)
  if mode == "create" and btn == 1 then
    select[4] = x-math.abs(select[2])
    select[5] = y-math.abs(select[3])
    tilescale(false,select[4],select[5],32,{x=select[2],y=select[3],sprite = tilePic,spritechange=true})
    for i = 2, #select do
      select[i] = 0
    end
  end
  mbtn = 0
end

love.keypressed = function(key)
  tilekeyboard(key,{grid = "s", control = "d"})
  if key == "a" then
    if mode == "create" then
      mode = "edit"
    elseif mode == "edit" then
      mode = "move"
    elseif mode == "move" then
      mode = "remove"
    elseif mode == "remove" then
      mode = "create"
    end
  elseif key == "s" then
    grid = not grid
  end
end
