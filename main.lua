-- libs
mclass 		= require("MiddleClass.lua")
mstate 		= require("MindState.lua")
goo 		= require("goo/goo.lua")
anim 		= require("anim/anim")
anal 		= require("libs/anal/AnAL.lua")
gamestate	= require("libs/hump/gamestate.lua")
vector		= require("libs/hump/vector.lua")
timer		= require("libs/hump/timer.lua")
camera		= require("libs/hump/camera.lua")
ring		= require("libs/hump/ringbuffer")
sequence	= require("libs/hump/sequence.lua")
soundmanager	= require("libs/soundmanager.lua")
utils		= require("utils")

--states
require("states/menu")
require("states/intro")
require("states/game")
require("states/death")



function love.load()
  love.graphics.setBackgroundColor(1, 1, 4)
  love.graphics.setCaption("cC Community Project")

  --Set Random Seed
  math.randomseed(os.time());
  math.random()
  math.random()
  math.random()

  --load resources
  images = {}
  loadfromdir(images, "gfx", "png", love.graphics.newImage)

  sounds = {}
  loadfromdir(sounds, "sfx", "ogg", love.sound.newSoundData)

  music = {}
  loadfromdir(music, "music", "ogg", love.audio.newSource)

  --start gamestate
  Gamestate.registerEvents()
  Gamestate.switch(Gamestate[(arg[2] and arg[2]:match("--state=(.+)") or "intro")])
  
  end