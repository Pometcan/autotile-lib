tile = {}
grid = true

function tilescale(map,w,h,s,pro)
  if w > s or h > s then
    if map == false then
      map = {}
    end
    for i = 1, (h/s) do
      table.insert(map,{})
      for j = 1, (w/s) do
        table.insert(map[i],0)
        map.properties = {i=i, j=j, x=pro.x or 0,y=pro.y or 0,w=w,h=h,s=s,sprite=pro.sprite,spritechange=pro.spritechange or false, number=1}
      end
    end
    table.insert(tile,map)
    return map
  end
end

function tilemove(map,x,y)
  for _, maps in ipairs(tile) do
      if maps == map then
        maps.properties = {
          x=x-(maps.properties.w/2), y=y-(maps.properties.h/2),
          i=maps.properties.i,
          j=maps.properties.j,
          w=maps.properties.w,
          h=maps.properties.h,
          s=maps.properties.s,
          sprite=maps.properties.sprite,
          spritechange=maps.properties.spritechange,
          number=maps.properties.number
        }
        return maps
      end
    end
end

function tileremove(stuff)
  if stuff ~= nil then
    table.remove(tile,tilesource(stuff))
  end
end

function tilesource(stuff)
  if stuff == nil then
  elseif stuff.name ~= nil then
    for _, map in ipairs(tile) do
      if map.properties.name == stuff.name then
        return map
      end
    end
  elseif stuff.x ~= nil or stuff.y ~= nil then
    for _, map in ipairs(tile) do
      if tile ~= nil and stuff.x > map.properties.x and stuff.y > map.properties.y and stuff.x < (map.properties.x+map.properties.w) and stuff.y < (map.properties.y+map.properties.h) then
        return map
      end
    end
  end
end

function tiledraw()
  for _, map in ipairs(tile) do
    for colindex, col in ipairs(map) do
      for rowindex, row in ipairs(col) do
      if map.properties.spritechange and row ~= nil and row ~= 0 then
        lgrap.draw(
        map.properties.sprite[row].img,
        map.properties.sprite[row][tilecontrol(map,colindex,rowindex,row)],
        (rowindex-1)*map.properties.s+map.properties.x,
        (colindex-1)*map.properties.s+map.properties.y)
      elseif not map.properties.spritechange then
        lgrap.draw(
        map.properties.sprite.img,
        map.properties.sprite[tilecontrol(map,colindex,rowindex,row)],
        (rowindex-1)*map.properties.s+map.properties.x,
        (colindex-1)*map.properties.s+map.properties.y)
      end
      if row ==  0 and not grid then
        lgrap.rectangle("line",map.properties.s*(rowindex-1)+map.properties.x,map.properties.s*(colindex-1)+map.properties.y,map.properties.s,map.properties.s)
      end
      --[[if kosul ~= 0 then
        if map.properties.spritechange == true then
          local mapsprite = map[colindex][rowindex] 
          if mapsprite ~= 0 then
            lgrap.draw(
            map.properties.sprite[mapsprite].img,
            map.properties.sprite[mapsprite][kosul],
            (rowindex-1)*map.properties.s+map.properties.x,
            (colindex-1)*map.properties.s+map.properties.y)
          end
        else
          lgrap.draw(
          map.properties.sprite.img,
          map.properties.sprite[kosul],
          (rowindex-1)*map.properties.s+map.properties.x,
          (colindex-1)*map.properties.s+map.properties.y)
        end
      elseif kosul == 0 and grid == false then
        lgrap.rectangle("line",map.properties.s*(rowindex-1)+map.properties.x,map.properties.s*(colindex-1)+map.properties.y,map.properties.s,map.properties.s)
      end]]
      end
    end
  end
end

function tilecontrol(map,col,row,tilenumber)
  local tilen = tilenumber or 0
  local kosul = 0
  local left = false
  local right = false
  local up = false
  local down = false
  if tilen == 0 then
    if (row ~= 1) then
      left = map[col][row-1] ~= 0
    end
    if (row ~= map.properties.j) then 
      right = map[col][row+1] ~= 0
    end
    if (col ~= 1) then
      up = map[col-1][row] ~= 0
    end
    if (col ~= map.properties.i) then
      down = map[col+1][row] ~= 0
    end
  else
    if (row ~= 1) then
      left = map[col][row-1] == tilen
    end
    if (row ~= map.properties.j) then 
      right = map[col][row+1] == tilen
    end
    if (col ~= 1) then
      up = map[col-1][row] == tilen
    end
    if (col ~= map.properties.i) then
      down = map[col+1][row] == tilen
    end
  end
  if row ~= 0 or not grid then
    if (left and right and up and down) then
      kosul = 2
    elseif (left and right and up) then
      kosul = 11
    elseif (left and right and down) then
      kosul = 9
    elseif (left and up and down) then
      kosul = 12
    elseif (right and up and down) then
      kosul = 10
    elseif (left and right) then
      kosul = 3
    elseif (left and up) then
      kosul = 7
    elseif (left and down) then
      kosul = 8
    elseif (right and up) then
      kosul = 6
    elseif (right and down) then
      kosul = 5
    elseif (down and up) then
      kosul = 4
    elseif down then
      kosul = 13
    elseif right then
      kosul = 14
    elseif up then
      kosul = 15
    elseif left then
      kosul = 16
    elseif not (left and right and up and down) and row ~= 0 then
      kosul = 1
    end
  end
  return kosul
end

function tilemouse(x,y,btn)
  for _, map in ipairs(tile) do
    local r = math.floor((y-map.properties.y)/32)+1
    local c = math.floor((x-map.properties.x)/32)+1

    if not (r > map.properties.i or c > map.properties.j or c <= 0 or r <= 0) then
      --print(r,c)
      if btn == 1 then
        map[r][c] = map.properties.number
      elseif btn == 2 then
        map[r][c] = 0
      elseif btn == 3 and map.properties.spritechange == true and map.properties.number <= #map.properties.sprite then
        map.properties.number = map.properties.number + 1
        if map.properties.number == #map.properties.sprite +1 then
          map.properties.number = 1
        end
      end
    end
  end
end

function tilekeyboard(key,keys)
  if key ==  keys.grid then
    grid = not grid
  elseif key == keys.control then
    print("number of tile : "..#tile,"\n",unpack(tile))
  end
end
