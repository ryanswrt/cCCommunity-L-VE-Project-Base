Gamestate.game = Gamestate.new()
local state = Gamestate.game

blockStore = {} --keeps inactive blocks
activeShape = {} --keeps active (moving) blocks
activePos = {} --keeps position of active block
controlls = {} --table of controls
angle = 0 --remnant of stupid rotation
difficulty = 0.1 --smooth falling, better way to do difficulty
score = 0

function state:enter()

--initialize controlls table

controlls.a = function ()
if not checkCollide(-1,0) then
activePos[1] = activePos[1] -1
end
end

controlls.d = function ()
if not checkCollide(1,0) then
activePos[1] = activePos[1] +1
end
end

controlls.s = function ()
if not checkCollide(0,2) then
activePos[2] = activePos[2] +2
end
end

controlls.q = function ()
if not checkCollide(-1,0) then
rotateShape()
end
end

makeField() --generate playing field
generateBlock() --load primary block
end

function state:keypressed(key)
  if key == "escape" then
    Gamestate.switch(Gamestate.menu)
  end
  if controlls[key] then
    controlls[key]()
    end
  end

function state:update(dt)


--love.timer.sleep(500) stupid way to do difficulty

  if checkCollide(0,1) then --checks collision one block below each active block
    for i=1,4 do
      blockStore[activePos[1]+activeShape[1][i]][math.ceil(activePos[2])+activeShape[2][i]] = true --if block collided, unload active block to block store
      end
    checkFilled() --after blocks loaded into block store, check if there are filled lines
    generateBlock() --make a new active block
    else
    activePos[2] = activePos[2]+difficulty*dt*30 --if no collision, move active block down by difficulty level
  end

end

function state:draw()

love.graphics.print("Score :"..score,400,50)
love.graphics.print("Controls are Q A S D",400,150)

love.graphics.setColor(255,255,255)

for i = 1,12 do --draw innactive blocks
for j = 1,28 do
      if blockStore[i][j] then love.graphics.circle("fill",i*10,j*10,5)
      end
    end
  end 

for i = 1,4 do --draw active blocks
      love.graphics.setColor(255,0,0) --make active blocks a different color
      love.graphics.circle("fill",(activePos[1]+activeShape[1][i])*10,(activePos[2]+activeShape[2][i])*10,5)
    end
end


function makeField()

  for i = 1,12 do
    blockStore[i] = {}
    for j = 1,28 do
      if i == 1 or i == 12 or j == 28 then
      blockStore[i][j] = true;
      end
    end
  end
end

function generateBlock()

  angle = 0
  activePos={6,1}

--block shape primatives

l = {{0,0,0,1},{-1,0,1,1}}
i = {{-1,0,1,2},{0,0,0,0}}
j = {{0,0,0,-1},{-1,0,1,1}}
b = {{0,1,0,1},{0,1,1,0}}
z = {{-1,0,0,1},{0,0,1,1}}
t = {{-1,0,0,1},{0,0,1,0}}
f = {{-1,0,0,1},{1,1,0,0}}

  print("l = " .. table.getn(l))
  typeStore={l,i,j,b,z,t,f}
  ran = math.random(7) --select random block
  --ran = 4 easy debug :)
  selected = typeStore[ran]
  print(ran)
  activeShape = selected --put selected block primative into the active slot

end

function checkCollide(i,j)

  for x=1,4 do
    changedPos = activePos
      if blockStore[activePos[1]+activeShape[1][x]+i][math.ceil(activePos[2])+activeShape[2][x]+j] then
      return true
    end
  end
  return false
end
    
function rotateShape()

  centre = {activeShape[1][2],activeShape[2][2]}
  angle = (math.pi/2)
  for i=1,4 do
    rotatedPoint = doRotate({activeShape[1][i],activeShape[2][i]},centre)
    --print(rotatedPoint[1])
    activeShape[1][i] = math.floor(rotatedPoint[1]+0.5)
    activeShape[2][i] = math.floor(rotatedPoint[2]+0.5)
  end

end
  
function doRotate(point,centre)

print(math.deg(angle))


           rotatedPointx = point[1] * math.cos(angle) - point[2] * math.sin(angle)
           rotatedPointy = point[1] * math.sin(angle) + point[2] * math.cos(angle)
           
	   return {rotatedPointx,rotatedPointy}
	   
end

function checkFilled()
  print("checking fill")
  for i = 1, 27 do
    j = 1
    while blockStore[j][i] == true do
      --print("Block is true " .. i .. j )
      if j == 12 then
	print("clearing line")
	clearline(i)
	score = score + 1
	break
      else j = j + 1
      end
    end
  end
end

function clearline(x)
  i = x
  
  while i >= 0 do 

    for j = 2, 11 do
      blockStore[j][i] = blockStore[j][i-1] --replace line contents with line above
    end
  i = i - 1
  print(i)
  
  end
end 
