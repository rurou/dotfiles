-- Force ATOK Roman when entering Zellij mode (Ctrl+a) in Ghostty
-- NOTE: must be global; locals get GC'd and the tap silently dies
imeTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(ev)
  local app = hs.application.frontmostApplication()
  if app and app:bundleID() == "com.mitchellh.ghostty"
     and ev:getFlags():containExactly({ "ctrl" })
     and ev:getKeyCode() == hs.keycodes.map["a"] then
    hs.keycodes.currentSourceID("com.justsystems.inputmethod.atok35.Roman")
  end
  return false  -- pass the key through to Zellij
end)
imeTap:start()
