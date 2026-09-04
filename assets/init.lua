-- FCP Frame Hotkey: number 1 opens Save Current Frame and stops at the Save dialog.
-- Only enabled while Final Cut Pro is the frontmost application.

local FCP_BUNDLE_ID = "com.apple.FinalCut"
local BUSY = false
local LOG_PATH = "/Users/xin/FCPFrameHotkey.log"

local function log(message)
  hs.printf("[FCP Frame Hotkey] %s", message)
  local file = io.open(LOG_PATH, "a")
  if file then
    file:write(os.date("%Y-%m-%d %H:%M:%S | ") .. message .. "\n")
    file:close()
  end
end

local function chooseSaveCurrentFrame(app)
  local paths = {
    {"文件", "共享", "存储当前帧…"},
    {"文件", "共享", "存储当前帧..."},
    {"文件", "共享", "存储当前帧"},
    {"File", "Share", "Save Current Frame…"},
    {"File", "Share", "Save Current Frame..."},
    {"File", "Share", "Save Current Frame"},
  }
  for _, path in ipairs(paths) do
    if app:selectMenuItem(path) then
      log("Selected menu: " .. table.concat(path, " > "))
      return true
    end
  end
  return false
end

local function exportCurrentFrame()
  if BUSY then return end
  local app = hs.application.frontmostApplication()
  if not app or app:bundleID() ~= FCP_BUNDLE_ID then return end
  BUSY = true
  if not chooseSaveCurrentFrame(app) then
    BUSY = false
    hs.alert.show("未找到 FCP：文件 → 共享 → 存储当前帧")
    log("Save Current Frame menu destination was not found")
    return
  end
  -- FCP first shows the Share summary. Enter activates “Next…”, then automation stops.
  -- The user chooses filename/location and confirms Save manually.
  hs.timer.doAfter(1.2, function()
    hs.eventtap.keyStroke({}, "return", 0)
    hs.timer.doAfter(1.5, function()
      BUSY = false
      log("Save dialog opened; waiting for user confirmation")
    end)
  end)
end

-- Raw event tap is more reliable than enabling/disabling global hotkeys as apps activate.
-- ANSI 1 = keycode 18; numeric keypad 1 = keycode 83.
local keyTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
  local app = hs.application.frontmostApplication()
  if not app or app:bundleID() ~= FCP_BUNDLE_ID then return false end
  local code = event:getKeyCode()
  if code ~= 18 and code ~= 83 then return false end
  local flags = event:getFlags()
  if flags.cmd or flags.ctrl or flags.alt or flags.shift or flags.fn then return false end
  if event:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat) == 1 then
    return true
  end
  log("Key 1 received in Final Cut Pro")
  exportCurrentFrame()
  return true
end):start()

hs.autoLaunch(true)
log("Loaded manual-save mode; active only in Final Cut Pro")
