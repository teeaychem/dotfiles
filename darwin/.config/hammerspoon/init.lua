-- local ce = hs.loadSpoon('ControlEscape')
-- ce.cancel_delay_seconds = 0.00125
-- ce:start()

-- Hammerspoon's key-string map is not layout-aware for shifted punctuation.
local tabShortcutKeyCodes = {
  previous = 42,
  next = 30,
}

local function sendTabShortcut(direction)
  local keyCode = tabShortcutKeyCodes[direction]
  hs.eventtap.event.newKeyEvent({ "cmd", "shift" }, keyCode, true):post()
  hs.eventtap.event.newKeyEvent({ "cmd", "shift" }, keyCode, false):post()
end

mouseSideButtons = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDown },
 function(e)
   if e:getButtonState(4) then
     sendTabShortcut("previous")
     return true -- to supress original key
   elseif e:getButtonState(3) then
     sendTabShortcut("next")
     return true -- to supress original key
   end

 end
)
mouseSideButtons:start()

local function hasOnlyCommandModifier(e)
  local flags = e:getFlags()
  return flags.cmd and not (flags.alt or flags.ctrl or flags.fn or flags.shift)
end

commandBracketRemap = hs.eventtap.new({ hs.eventtap.event.types.keyDown },
 function(e)
   if not hasOnlyCommandModifier(e) then
     return false
   end

   local characters = e:getCharacters()
   if characters == "[" then
     hs.eventtap.keyStroke({ "shift" }, "8", 10)
     return true
   elseif characters == "]" then
     hs.eventtap.keyStroke({ "shift" }, "9", 10)
     return true
   end

   return false
 end
):start()

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
