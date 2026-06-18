--- launch.lua — Launch and re-launch background apps.
--  Runs on config load and on system wake via init.lua's wakeHandler.
--  Hides app windows after launch, retrying up to 15 times because some
--  apps (Mail, Calendar) re-show their window after initial hide.

local launch = require('launch-apps')
hs.application.enableSpotlightForNameSearches(true)

local function hideIt(app, hide)
  local appObj = hs.application.get(app)
  if appObj ~= nil and hide then
    appObj:hide()
  end
end

local function launchApps()
  for _, mapping in ipairs(launch) do
    local app = mapping[1]
    local bundle = mapping[2]
    local hide = mapping[3]

    if type(app) == 'string' then
      local appObj = hs.application.get(app)
      if appObj == nil then
        appObj = hs.application.open(bundle, 5, true)
        if appObj ~= nil then
          local function hideWithRetry(appName, shouldHide, remaining)
            hideIt(appName, shouldHide)
            if remaining > 0 then
              hs.timer.doAfter(1, function()
                hideWithRetry(appName, shouldHide, remaining - 1)
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

return launchApps
