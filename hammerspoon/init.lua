-- Force ATOK Roman when entering Zellij mode (Ctrl+a) in Ghostty
local ATOK_ROMAN = "com.justsystems.inputmethod.atok35.Roman"

local tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(ev)
  local app = hs.application.frontmostApplication()
  if app and app:bundleID() == "com.mitchellh.ghostty"
     and ev:getFlags():containExactly({ "ctrl" })
     and ev:getKeyCode() == hs.keyboard.map["a"] then
    hs.keycodes.currentSourceID(ATOK_ROMAN)
  end
  return false  -- pass the key through to Zellij
end)
tap:start()
