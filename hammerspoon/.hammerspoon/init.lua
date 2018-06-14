-- Use Cmd+\ to show 1Password everywhere except Atom
function activate_1password()
  local client = hs.application.frontmostApplication()
  if client:title() == 'Atom' then
    hs.eventtap.keyStroke({"cmd"}, "f12")
  else
    hs.eventtap.keyStroke({"cmd"}, "f11")
  end
end
hs.hotkey.bind({"cmd"}, "\\", activate_1password)
