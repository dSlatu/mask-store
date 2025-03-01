ESX = exports['es_extended']:getSharedObject() 

RegisterNetEvent("sMask:buy")
AddEventHandler("sMask:buy", function()
    local xPlayer = ESX.GetPlayerFromId(source) 
    local price = Config.Price

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        TriggerClientEvent('esx:showNotification', source,  "Vous avez payé ~g~"..price.."$")
        TriggerClientEvent('sMask:save', source)
    else 
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez d'argent")
    end
end)
