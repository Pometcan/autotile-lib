--Sprite Create
function createSprite(img,fCounts,w,h)
  if type(img) == type("") then
    img = love.graphics.newImage(img) 
    img:setFilter("nearest","nearest")
  end
  local frame = {}
  frame.img = img
  for i=0,fCounts.col do
    for j=0,fCounts.row do
      table.insert(frame,love.graphics.newQuad(j*w,i*h,w,h,img:getDimensions()))
    end
  end
  return frame
end

