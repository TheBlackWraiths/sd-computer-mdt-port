local RESOURCE = GetCurrentResourceName()

local function page()
    return Config.DevServer or (RESOURCE .. '/' .. Config.Page)
end

local function register()
    local ok, err = exports['sd-computers']:AddCustomApp({
        id = Config.Id,
        label = Config.Label,
        description = Config.Description,
        developer = Config.Developer,
        color = Config.Color,
        ui = page(),
        icon = RESOURCE .. '/' .. Config.Icon,
        size = { w = 1280, h = 760 },
        pinned = Config.Pinned,
        groups = Config.Groups,
        computers = Config.Computers,
    })
    if ok then
        print(('[%s] registered'):format(Config.Id))
    else
        print(('[%s] registration failed: %s'):format(Config.Id, err or 'unknown error'))
    end
end

AddEventHandler('sd-computers:ready', register)

CreateThread(function()
    if GetResourceState('sd-computers') == 'started' then pcall(register) end
end)
