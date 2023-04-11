local log = hs.logger.new('apps')

local hyperModeAppMappings = require('apps-def')

local function switchOrHide(app)
  local curApp = hs.application.frontmostApplication()
  if app == curApp:path() then
    curApp:hide()
  else
    hs.application.launchOrFocus(app)
    -- hs.application.open(app)
  end
end

local function handleHotkey(key, app)
  if type(app) == 'string' then
    switchOrHide(app)
  elseif type(app) == 'function' then
    app()
  else
    log.e('Invalid mapping for hyper +', key)
  end
end

local function apps(hx)
  -- hs.application.enableSpotlightForNameSearches(true)
  for _, mapping in ipairs(hyperModeAppMappings) do
    local key = mapping[1]
    local app = mapping[2]
    if key then
      hs.hotkey.bind(hx, key, nil, function()
        handleHotkey(key, app)
      end)
    end
  end
end

return apps
