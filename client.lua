ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
      end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)
	while true do
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local dstCheck = GetDistanceBetweenCoords(pedCoords, Config.Zones.Coords.x,Config.Zones.Coords.y, Config.Zones.Coords.z, true)
		if dstCheck <= 5.0 then
			local text = "Surf Alanı"
			if dstCheck <= 0.85 then
				text = "Surf tahtası için [~g~E~s~] Tuşuna bas."
				if IsControlJustPressed(0, 38) then
                    OpenSurfMenu()
				end
			end
			ESX.Game.Utils.DrawText3D(Config.Zones.Coords, text, 0.9)
		end
		if dstCheck >= 9.5 then
			Citizen.Wait(7000)
		else
			Citizen.Wait(5)
		end
	end
end)

function OpenSurfMenu()

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'open_surf_menu', {
		title    = "Surf Alanı",
		align    = 'top-right',
		elements = {
            {   label = 'Surf Tahtası Kirala : '..Config.RentPrice..' $',    value = 'rent_surf'  },
            {   label = 'Kapat',                                           	 value = 'exit'       }
		}
	},function(data)
		if data.current.value == 'rent_surf' then
            TriggerServerEvent('dr:RentSurfServer', source)
            ESX.UI.Menu.CloseAll()
        elseif data.current.value == 'exit' then
            ESX.UI.Menu.CloseAll()
        end
    end)
end

RegisterNetEvent('dr:RentSurfClient')
AddEventHandler('dr:RentSurfClient', function()
    local playerPed = PlayerPedId()
    ESX.Game.SpawnVehicle('surfboard', Config.Zones.Spawn, Config.Zones.Spawn.h, function(board)
        TaskWarpPedIntoVehicle(playerPed, board, -1)
	end)
	if Config.SendAlert then
		exports['mythic_notify']:SendAlert('inform', 'Surf Tahtası Kiraladın İyi Eğlenceler.', 4000)
	else
		exports['mythic_notify']:DoHudText('inform', 'Surf Tahtası Kiraladın İyi Eğlenceler.', 4000)
	end
end)