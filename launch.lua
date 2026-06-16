local launch = require 'launch-apps'

local function hideIt(app, hide)
  local appObj = hs.application.get(app)
  if appObj ~= nil and hide then
    appObj:hide()
  end
end

local function launchApps()
  hs.application.enableSpotlightForNameSearches(true)
  for _, mapping in ipairs(launch) do
    local app = mapping[1]
    local bundle = mapping[2]
    local hide = mapping[3]

    if type(app) == 'string' then
      local appObj = hs.application.get(app)
      if appObj == nil then
        appObj = hs.application.open(bundle, 5, true)
        if appObj ~= nil then
          local function hideWithRetry(app, hide, remaining)
            hideIt(app, hide)
            if remaining > 0 then
              hs.timer.doAfter(1, function()
                hideWithRetry(app, hide, remaining - 1)
              end)
            end
          end
          hideWithRetry(bundle, hide, 15)
        end
      end
      hideIt(app, hide)
    end
  end
end

launchApps()

local function hideOnWake(eventType)
  if eventType == hs.caffeinate.watcher.systemDidWake then
    launchApps()
  end
end

local CaffeinateWatcher = hs.caffeinate.watcher.new(hideOnWake)

CaffeinateWatcher:start()
