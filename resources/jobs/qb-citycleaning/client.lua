local QBCore = exports['qb-core']:GetCoreObject()

local onDuty = false
local trashObjects = {}
local graffitiObjects = {}
local trashCount, graffitiCount = 0, 0

-- spawn trash bags
local function spawnTrash()
    for _, spot in pairs(Config.TrashSpots) do
        local obj = CreateObjectNoOffset(GetHashKey(Config.TrashModel), spot.x, spot.y, spot.z, false, false, true)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
        trashObjects[obj] = true
        trashCount = trashCount + 1
    end
end

-- spawn graffiti objects
local function spawnGraffiti()
    for _, spot in pairs(Config.GraffitiSpots) do
        local obj = CreateObjectNoOffset(GetHashKey(Config.GraffitiModel), spot.x, spot.y, spot.z, false, false, true)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
        graffitiObjects[obj] = true
        graffitiCount = graffitiCount + 1
    end
end

local function spawnTasks()
    trashCount, graffitiCount = 0, 0
    spawnTrash()
    spawnGraffiti()
end

local function cleanupTasks()
    for obj in pairs(trashObjects) do DeleteObject(obj) end
    for obj in pairs(graffitiObjects) do DeleteObject(obj) end
    trashObjects, graffitiObjects = {}, {}
    trashCount, graffitiCount = 0, 0
end

-- tablet menu
local function openTablet()
    local menu = {
        {header = 'Stadtreinigung', isMenuHeader = true},
        {header = onDuty and 'Dienst beenden' or 'Dienst beginnen', params = {event = 'qb-citycleaning:client:ToggleDuty'}},
        {header = 'Arbeitsfahrzeug holen', params = {event = 'qb-citycleaning:client:SpawnVehicle'}},
        {header = 'Uniform anlegen', params = {event = 'qb-citycleaning:client:WearUniform'}},
        {header = 'Uniform ausziehen', params = {event = 'qb-citycleaning:client:RemoveUniform'}},
        {header = 'Schließen', params = {event = 'qb-menu:client:closeMenu'}}
    }
    exports['qb-menu']:openMenu(menu)
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - Config.Depot)
        if dist < 2.0 then
            DrawText3D(Config.Depot.x, Config.Depot.y, Config.Depot.z + 0.5, '[E] Tablet öffnen')
            if IsControlJustReleased(0, 38) then
                openTablet()
            end
            Wait(0)
        else
            Wait(1000)
        end
    end
end)

RegisterNetEvent('qb-citycleaning:client:ToggleDuty', function()
    TriggerServerEvent('qb-citycleaning:server:toggleDuty')
end)

RegisterNetEvent('qb-citycleaning:client:SpawnVehicle', function()
    if not onDuty then
        QBCore.Functions.Notify('Nicht im Dienst', 'error')
        return
    end
    local model = Config.Vehicles[math.random(#Config.Vehicles)]
    QBCore.Functions.SpawnVehicle(model, function(veh)
        SetVehicleNumberPlateText(veh, 'REIN' .. tostring(math.random(100, 999)))
        SetEntityHeading(veh, Config.VehicleSpawn.w)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    end, Config.VehicleSpawn, true)
end)

RegisterNetEvent('qb-citycleaning:client:WearUniform', function()
    local gender = QBCore.Functions.GetPlayerData().charinfo.gender == 0 and 'male' or 'female'
    TriggerEvent('qb-clothing:client:loadOutfit', Config.Uniforms[gender])
end)

RegisterNetEvent('qb-citycleaning:client:RemoveUniform', function()
    TriggerServerEvent('qb-clothing:loadPlayerSkin')
end)

-- handle job updates
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    onDuty = job.name == Config.Job
    if onDuty then
        spawnTasks()
    else
        cleanupTasks()
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    local playerJob = QBCore.Functions.GetPlayerData().job
    onDuty = playerJob.name == Config.Job
    if onDuty then spawnTasks() end
end)

-- interaction loop
CreateThread(function()
    while true do
        if onDuty then
            local sleep = 1000
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            for obj in pairs(trashObjects) do
                local objPos = GetEntityCoords(obj)
                local dist = #(pos - objPos)
                if dist < 2.0 then
                    sleep = 0
                    DrawText3D(objPos.x, objPos.y, objPos.z + 1.0, '[E] Müll aufheben')
                    if IsControlJustReleased(0, 38) then
                        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_BUM_WASH', 0, true)
                        Wait(4000)
                        ClearPedTasksImmediately(ped)
                        DeleteObject(obj)
                        trashObjects[obj] = nil
                        trashCount = trashCount - 1
                        TriggerServerEvent('qb-citycleaning:server:reward', 'trash')
                    end
                end
            end
            for obj in pairs(graffitiObjects) do
                local objPos = GetEntityCoords(obj)
                local dist = #(pos - objPos)
                if dist < 2.0 then
                    sleep = 0
                    DrawText3D(objPos.x, objPos.y, objPos.z + 1.0, '[E] Graffiti entfernen')
                    if IsControlJustReleased(0, 38) then
                        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
                        Wait(4000)
                        ClearPedTasksImmediately(ped)
                        DeleteObject(obj)
                        graffitiObjects[obj] = nil
                        graffitiCount = graffitiCount - 1
                        TriggerServerEvent('qb-citycleaning:server:reward', 'graffiti')
                    end
                end
            end
            if trashCount == 0 and graffitiCount == 0 and (next(trashObjects) or next(graffitiObjects)) == nil then
                TriggerServerEvent('qb-citycleaning:server:bonus')
            end
            Wait(sleep)
        else
            Wait(1000)
        end
    end
end)

function DrawText3D(x, y, z, text)
    SetDrawOrigin(x, y, z, 0)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end
