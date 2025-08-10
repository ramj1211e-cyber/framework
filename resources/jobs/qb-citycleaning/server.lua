local QBCore = exports['qb-core']:GetCoreObject()

-- Command to toggle the job
QBCore.Commands.Add('reinigung', 'Starte oder beende den Stadtreinigungsdienst', {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == Config.Job then
        Player.Functions.SetJob('unemployed', 0)
        TriggerClientEvent('QBCore:Notify', source, 'Du bist nicht mehr im Dienst.', 'error')
    else
        Player.Functions.SetJob(Config.Job, 0)
        TriggerClientEvent('QBCore:Notify', source, 'Stadtreinigung: Viel Erfolg!', 'success')
    end
end)

-- Tablet toggle
RegisterNetEvent('qb-citycleaning:server:toggleDuty', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.name == Config.Job then
        Player.Functions.SetJob('unemployed', 0)
        TriggerClientEvent('QBCore:Notify', src, 'Du bist nicht mehr im Dienst.', 'error')
    else
        Player.Functions.SetJob(Config.Job, 0)
        TriggerClientEvent('QBCore:Notify', src, 'Stadtreinigung: Viel Erfolg!', 'success')
    end
end)

-- Reward the player for tasks
RegisterNetEvent('qb-citycleaning:server:reward', function(task)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or Player.PlayerData.job.name ~= Config.Job then return end

    local payment = math.random(Config.MinPay, Config.MaxPay)
    if task == 'graffiti' then payment = payment + 20 end
    Player.Functions.AddMoney('cash', payment, 'city-cleaning')
    TriggerClientEvent('QBCore:Notify', src, ('Du hast $%s erhalten.'):format(payment), 'success')
end)

-- Bonus for clearing all tasks
RegisterNetEvent('qb-citycleaning:server:bonus', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or Player.PlayerData.job.name ~= Config.Job then return end
    Player.Functions.AddMoney('cash', Config.BonusPay, 'city-cleaning-bonus')
    TriggerClientEvent('QBCore:Notify', src, ('Bonus $%s für saubere Arbeit!'):format(Config.BonusPay), 'success')
end)
