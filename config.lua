-- Every value below goes into AddCustomApp (server.lua).
Config = {}
Config.Id          = 'sd-computers-mdt'
Config.Label       = 'MDT' 
Config.Description = 'Mobile Data Terminal: police, medical and court terminals.'
Config.Developer   = 'wraith'
Config.Color       = '#1D4ED8'
Config.Pinned      = true 
Config.Groups      = { police = 0, sheriff = 0, sasp = 0, ambulance = 0, judge = 0, lawyer = 0 }
Config.Computers   = nil -- only these computers, e.g. { 'mrpd_pc' } (nil = every computer)

Config.Page        = 'ui/dist/index.html' -- the page, inside this resource
Config.Icon        = 'ui/dist/icon.svg'
Config.DevServer   = nil
