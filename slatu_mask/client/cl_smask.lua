

ESX = exports['es_extended']:getSharedObject()
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.Events["esx:getSharedObject"], function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
end)

local mask = {} 
for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 1) - 1, 1 do 
    mask[i] = i 
end

local Mask = {
    MaskIndex = 1,
    MaskVariantIndex = 0,
}

local active = false
local MaxVariant = {}

function destroyPlayerPedCam() 	
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityInvincible(PlayerPedId(), false)
end

local open = false
local sMask = RageUI.CreateMenu("Masque", "Slatu Masque")
sMask.Closed = function()
    RageUI.Visible(sMask, false)
    open = false
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
    destroyPlayerPedCam()
end

function GetCurrensMask()
    MaxVariant = {}
    for c = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 1, Mask.MaskIndex)-1 do
        MaxVariant[c] = c
        if MaxVariant[c] > 0 then
            active = true
        end
    end
end


function OpenMask()
    if open then 
        open = false
        RageUI.Visible(sMask, false)
        return
    else
        open = true 
        RageUI.Visible(sMask, true)

        local playerPed = GetPlayerPed(-1)
        SetEntityInvincible(playerPed, true) 
        FreezeEntityPosition(playerPed, true)

        Citizen.CreateThread(function()
            while open do 
                RageUI.IsVisible(sMask, function()
                    RageUI.Separator("")
                    RageUI.Separator("→ ~f~ Choisis ton masque ~f~ ←")
                    RageUI.Separator("")
                    RageUI.List('Masque', mask, Mask.MaskIndex, nil, {}, true, {
                        onListChange = function(Index, Item)
                            Mask.MaskIndex = Index
                            GetCurrensMask()
                            Mask.MaskVariantIndex = 0
                            SetPedComponentVariation(GetPlayerPed(-1), 1, Mask.MaskIndex, Mask.MaskVariantIndex, 2)
                        end
                    })
                    
                    if active then
                        RageUI.List('Variante du masque', MaxVariant, Mask.MaskVariantIndex, nil, {}, true, {
                            onListChange = function(Index, Item)
                                Mask.MaskVariantIndex = Index
                                SetPedComponentVariation(GetPlayerPed(-1), 1, Mask.MaskIndex, Mask.MaskVariantIndex, 2)
                            end
                        })
                    end

                    RageUI.Button("Payer : ~g~" .. Config.Price .. "$" , nil, { RightLabel = "~u~ $" , Color = { BackgroundColor = { 0, 200, 0, 160 } } }, true, {
                       onSelected = function()
                           TriggerServerEvent("sMask:buy")
                           Wait(200)
                           destroyPlayerPedCam()
                           sMask.Closed()
                        end
                    })
                end)
                Wait(0)
            end
        end)
    end
end


function CreatePedCamHead()
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA')
    local coordsCam = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.95)
    local coordsPly = GetEntityCoords(PlayerPedId())
    SetCamCoord(cam, coordsCam)
    PointCamAtCoord(cam, coordsPly['x'], coordsPly['y'], coordsPly['z'] + 0.6)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
end


CreateThread(function()
    while true do
        local pCoords = GetEntityCoords(PlayerPedId())
        local spam = false
        if #(pCoords - Config.Pos) < 1.2 then
            spam = true
            ShowHelpNotification("Appuyez sur [~b~E~w~] pour ~b~accéder au magasin de masques")
            DrawMarker(23, Config.Pos - vector3(0, 0, 1.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 0, 255, 255, false, true, p19, true)                    
            
            if IsControlJustReleased(0, 38) then
                local playerPed = GetPlayerPed(-1)
                FreezeEntityPosition(playerPed, true)
                SetEntityInvincible(playerPed, true)
                CreatePedCamHead()
                OpenMask()
            end
        elseif #(pCoords - Config.Pos) < 1.3 then
            spam = false 
            RageUI.CloseAll()
            destroyPlayerPedCam()
            local playerPed = GetPlayerPed(-1)
            FreezeEntityPosition(playerPed, false)  
            SetEntityInvincible(playerPed, false)
        end

        if spam then
            Wait(1)
        else
            Wait(500)
        end
    end
end)


RegisterNetEvent('sMask:save')
AddEventHandler('sMask:save', function()
    TriggerEvent("skinchanger:change", "mask_2", Mask.MaskVariantIndex)
    TriggerEvent("skinchanger:change", "mask_1", Mask.MaskIndex, -1)
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
end)


function ShowHelpNotification(msg)
    AddTextEntry('HelpNotification', msg)
    BeginTextCommandDisplayHelp('HelpNotification')
    EndTextCommandDisplayHelp(0, false, true, -1)
end
