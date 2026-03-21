local ce = hs.loadSpoon('ControlEscape')
ce.cancel_delay_seconds = 0.00125
ce:start()

local left_square_bracket = 42
local right_square_bracket = 30

mouseSideButtons = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDown },
 function(e)
   if e:getButtonState(4) then
     hs.eventtap.event.newKeyEvent({"command", "shift"}, left_square_bracket, true):post()
     return true -- to supress original key
   elseif e:getButtonState(3) then
     hs.eventtap.event.newKeyEvent({"command", "shift"}, right_square_bracket, true):post()
     return true -- to supress original key
   end

 end
)
mouseSideButtons:start()

eisuuFlag = false

eisuuD = hs.eventtap.new({ hs.eventtap.event.types.keyDown },
 function(e)
   thisKeyCode = e:getCharacters()
   if eisuuFlag == true then
     if thisKeyCode == "v" then
       hs.eventtap.event.newKeyEvent({"command", "shift"}, left_square_bracket, true):post()
       return true
     elseif thisKeyCode == "c" then
       hs.eventtap.event.newKeyEvent({"command", "shift"}, right_square_bracket, true):post()
       return true
     end
   elseif thisKeyCode == " " and e:getKeyCode() == 102 then
     eisuuFlag = true
   else
     eisuuFlag = false
   end
 end
):start()

eisuuU = hs.eventtap.new({ hs.eventtap.event.types.keyUp },
 function(e)
   if e:getKeyCode() == 102 then
     eisuuFlag = false
   end
 end
):start()

hs.hotkey.bind({"cmd"}, 30, function() hs.eventtap.keyStroke({"shift"}, "8", 10) end)
hs.hotkey.bind({"cmd"}, 42, function() hs.eventtap.keyStroke({"shift"}, "9", 10) end)

-- hs.hotkey.bind({'cmd'}, "[", hs.eventtap.keyStroke({"shift"}, "8"), nil, hs.eventtap.keyStroke({"shift"}, "8"))


-- Use to figure out key
-- local inspect = require('inspect')
-- local events = hs.eventtap.event.types
-- keyboardTracker = hs.eventtap.new({ hs.eventtap.event.types.keyDown },
--  function (e)
--    -- local gestureType = e:getKeyCode(true)
--    local gestureType = e
--    print(inspect(e:getRawEventData()))
--    print(inspect(e:getCharacters()))
--    print(inspect(e:getKeyCode()))

--    -- print(hs.keycodes.map[gestureType])
--    -- print(hs.inspect(hs.keycodes.layouts()))
--    -- print(hs.inspect(hs.keycodes.methods()))
--    -- print(hs.keycodes.currentMethod())
--    -- print(hs.keycodes.currentLayout())
--    if gestureType == hs.eventtap.event.types.gesture then
--    end
--    if keyCode == 50 then
--      hs.eventtap.event.newKeyEvent(hs.keycodes.map.alt,true):post()
--      hs.eventtap.event.newKeyEvent(hs.keycodes.map.alt,true):post()
--      return true
--    end
-- end)
-- keyboardTracker:start()

-- https://github.com/mengelbrecht/hammerspoon-config/blob/main/init.lua
