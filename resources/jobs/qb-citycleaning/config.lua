Config = {}

-- Job name as defined in QB-Core shared/jobs.lua
Config.Job = 'stadtreinigung'

-- Location for duty tablet
Config.Depot = vector3(-321.59, -1545.58, 30.72)

-- Vehicle spawn point
Config.VehicleSpawn = vector4(-333.45, -1539.07, 30.72, 270.0)

-- Available work vehicles
Config.Vehicles = {'trash', 'sweeper'}

-- Uniform presets
Config.Uniforms = {
    male = {
        ['tshirt_1'] = 59, ['tshirt_2'] = 0,
        ['torso_1'] = 56, ['torso_2'] = 0,
        ['arms'] = 41,
        ['pants_1'] = 36, ['pants_2'] = 0,
        ['shoes_1'] = 25, ['shoes_2'] = 0,
        ['helmet_1'] = 62, ['helmet_2'] = 0,
        ['vest_1'] = 65, ['vest_2'] = 0
    },
    female = {
        ['tshirt_1'] = 36, ['tshirt_2'] = 0,
        ['torso_1'] = 48, ['torso_2'] = 0,
        ['arms'] = 36,
        ['pants_1'] = 35, ['pants_2'] = 0,
        ['shoes_1'] = 26, ['shoes_2'] = 0,
        ['helmet_1'] = 62, ['helmet_2'] = 0,
        ['vest_1'] = 65, ['vest_2'] = 0
    }
}

-- Payment range per task
Config.MinPay = 50
Config.MaxPay = 100
Config.BonusPay = 250

-- Locations where trash can spawn
Config.TrashSpots = {
    vector3(-324.96, -1531.57, 27.54),
    vector3(-341.25, -1568.61, 25.23),
    vector3(-350.96, -1495.83, 30.74)
}

-- Prop model for trash bags
Config.TrashModel = 'prop_rub_binbag_sd_01'

-- Locations for graffiti
Config.GraffitiSpots = {
    vector3(-325.12, -1524.8, 27.54),
    vector3(-344.5, -1549.3, 27.74),
    vector3(-352.1, -1509.1, 29.72)
}

-- Prop model used as graffiti placeholder
Config.GraffitiModel = 'prop_fncresidue_01a'
