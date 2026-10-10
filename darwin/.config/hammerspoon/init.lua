-- local ce = hs.loadSpoon('ControlEscape')
-- ce.cancel_delay_seconds = 0.00125
-- ce:start()

local generatedShortcutTag = 0x48535441
local eventUserData = hs.eventtap.event.properties.eventSourceUserData

-- Match the resulting character, including Shift, rather than a key position.
local function sendCharacterShortcut(modifiers, character)
  for keyCode = 0, 127 do
    local down = hs.eventtap.event.newKeyEvent(modifiers, keyCode, true)
    if down:getCharacters(true) == character then
      local up = hs.eventtap.event.newKeyEvent(modifiers, keyCode, false)
      down:setProperty(eventUserData, generatedShortcutTag):post()
      up:setProperty(eventUserData, generatedShortcutTag):post()
      return
    end
  end
end

local mouseShortcuts = {
  [4] = { { "cmd", "shift" }, "}" },
  [3] = { { "cmd", "shift" }, "{" },
}

mouseSideButtons = hs.eventtap.new({ hs.eventtap.event.types.otherMouseDown },
 function(e)
   for button, shortcut in pairs(mouseShortcuts) do
     if e:getButtonState(button) then
       sendCharacterShortcut(table.unpack(shortcut))
       return true
     end
   end
   return false
 end
):start()

local function hasOnlyCommandModifier(e)
  local flags = e:getFlags()
  return flags.cmd and not (flags.alt or flags.ctrl or flags.fn or flags.shift)
end

commandBracketRemap = hs.eventtap.new({ hs.eventtap.event.types.keyDown },
 function(e)
   if e:getProperty(eventUserData) == generatedShortcutTag then
     return false
   end
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

-- Match the character produced by the source keyboard, retaining Shift's
-- effect while checking the other modifiers separately.
commandBraceRemap = hs.eventtap.new({ hs.eventtap.event.types.keyDown },
 function(e)
   if e:getProperty(eventUserData) == generatedShortcutTag then
     return false
   end
   local flags = e:getFlags()
   if flags.cmd and not (flags.ctrl or flags.alt or flags.fn)
       and e:getCharacters(true) == "{" then
     hs.eventtap.keyStrokes("(")
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
