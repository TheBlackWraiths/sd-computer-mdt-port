local APP = Config.Id

local ACTIONS = {}
for _, action in ipairs({
    'bootstrap', 'home',
    'dispatch:state', 'dispatch:setStatus', 'dispatch:attach', 'dispatch:detach', 'dispatch:locate',
    'persons:search', 'persons:get', 'persons:notes', 'persons:flags',
    'vehicles:search', 'vehicles:get', 'vehicles:update',
    'weapons:search', 'weapons:get', 'weapons:create', 'weapons:update',
    'reports:list', 'reports:get', 'reports:save', 'reports:delete',
    'cases:list', 'cases:get', 'cases:save', 'cases:delete', 'cases:note', 'cases:assign', 'cases:linkReport',
    'warrants:list', 'warrants:get', 'warrants:issue', 'warrants:close', 'warrants:void', 'warrants:update',
    'offences:list',
    'roster:list', 'roster:setCallsign', 'roster:setRadio', 'me:update',
    'chat:history', 'chat:send',
    'bulletins:list', 'bulletins:save', 'bulletins:delete',
    'jail:list', 'jail:quote', 'jail:book',
    'sops:list', 'sops:save', 'sops:remove', 'sops:reset',
    'affairs:list', 'affairs:get', 'affairs:officer', 'affairs:file', 'affairs:update', 'affairs:note', 'affairs:close',
    'patients:search', 'patients:get', 'patients:update',
    'protocols:list', 'protocols:save', 'protocols:delete',
    'court:list', 'court:get', 'court:citizen', 'court:file', 'court:manage', 'court:note', 'court:rule',
    'expunge:list', 'expunge:file', 'expunge:rule',
    'shares:list', 'shares:create', 'shares:revoke',
    'logs:list',
}) do ACTIONS[action] = true end

local VEHICLE_ACTIONS = {
    ['vehicles:search'] = true,
    ['vehicles:get']    = true,
    ['persons:get']     = true,
}

local modelNames = {}

local function vehicleLabel(raw)
    if raw == nil or raw == '' then return '' end
    local key = tostring(raw)
    if modelNames[key] then return modelNames[key] end

    local numeric = tonumber(raw)
    local hash = numeric and math.floor(numeric) or joaat(key)
    local label = key
    if IsModelInCdimage(hash) then
        local name = GetDisplayNameFromVehicleModel(hash)
        local text = name and GetLabelText(name) or nil
        if text and text ~= 'NULL' then label = text
        elseif name and name ~= 'CARNOTFOUND' then label = name:lower():gsub('^%l', string.upper) end
    elseif numeric then
        label = ''
    end
    modelNames[key] = label
    return label
end

local NAME_DEPTH <const> = 6

local function nameVehicles(node, depth)
    if type(node) ~= 'table' or depth > NAME_DEPTH then return end
    if node.plate ~= nil and node.model ~= nil then node.model = vehicleLabel(node.model) end
    for _, value in pairs(node) do nameVehicles(value, depth + 1) end
end

RegisterNUICallback('mdt', function(data, cb)
    local action = type(data) == 'table' and data.action or nil
    if type(action) ~= 'string' or not ACTIONS[action] then
        return cb({ success = false, message = 'Unknown MDT action' })
    end

    local payload = type(data.payload) == 'table' and data.payload or {}
    local ok, res = pcall(lib.callback.await, 'sd-phone:server:mdt:' .. action, false, payload)
    if not ok or type(res) ~= 'table' then
        return cb({ success = false, message = 'The terminal did not answer' })
    end

    if VEHICLE_ACTIONS[action] then nameVehicles(res, 0) end
    cb(res)
end)

RegisterNUICallback('setWaypoint', function(data, cb)
    local x = type(data) == 'table' and tonumber(data.x) or nil
    local y = type(data) == 'table' and tonumber(data.y) or nil
    if not x or not y then return cb({ success = false }) end
    SetNewWaypoint(x + 0.0, y + 0.0)
    lib.notify({ description = 'Waypoint set.', type = 'success' })
    cb({ success = true })
end)

local function push(action, data)
    pcall(function() exports['sd-computers']:SendAppMessage(APP, action, data) end)
end

RegisterNetEvent('sd-phone:client:mdt:dispatch', function(data) push('dispatch', data) end)
RegisterNetEvent('sd-phone:client:mdt:call', function(data) push('call', data) end)
RegisterNetEvent('sd-phone:client:mdt:chat', function(data) push('chat', data) end)
RegisterNetEvent('sd-phone:client:mdt:bulletin', function(data) push('bulletin', data) end)
RegisterNetEvent('sd-phone:client:mdt:warrant', function(data) push('warrant', data) end)
RegisterNetEvent('sd-phone:client:mdt:shares', function(data) push('shares', data) end)
RegisterNetEvent('sd-phone:client:mdt:sops', function() push('sops', {}) end)
