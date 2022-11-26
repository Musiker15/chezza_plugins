ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

_menuPool  = NativeUI.CreatePool()

local properties = {}
local propertyOwner = {}
local ownedProperties = {}
local trustedProperties = {}
local playersInProperties = {}
local vanishedUser = {}
local isinProperty = false
local gotAllProperties = false
local isinMarker = false
local isNearMarker = false
local isinRoomMenu = false
local currentLocation = nil
local propertyID = nil
local isinLeaveMarker = false
local ownedByCharname = nil
local currentPropertyData = nil
local onlyVisit = false
local currentEnterLoc = {}
local currentMapBlip
local propertyBlips = {}

-- local oxInvName = 'property_' .. propertyID
-- 			if exports['ox_inventory']:openInventory('stash', oxInvName) == false then
-- 				TriggerServerEvent('ox:loadStash', oxInvName)
-- 				exports['ox_inventory']:openInventory('stash', oxInvName)
-- 				wardrobeMenu:Visible(not wardrobeMenu:Visible())
-- 			end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)

	TriggerServerEvent('myProperties:getProperties')
	TriggerServerEvent('myProperties:registerPlayer') -- muss bei playerloaded ausgeführt werden

	ESX.TriggerServerCallback('myProperties:getLastProperty', function(propertyName)
		if propertyName ~= 0 then
			for k, props in pairs(propertyOwner) do
				if tonumber(props.id) == tonumber(propertyName) then
					local name = props.property
					for k2, v in pairs(properties) do
						if v.name == name then
						
							-- hier muss eine abfrage rein, ob der spieler access hat. Wenn nein, muss onlyVisit gesetzt werden
							-- um zu verhindern, dass man nach dem Rejoinen full access hat.
						
							propertyID = props.id
							TriggerServerEvent('myProperties:enterProperty', tonumber(propertyName), v)
						end
					end
					break
				end
			end
			
		end
	end)
	

end)


function refreshBlips()
	if propertyBlips ~= nil then
		for k, v in pairs(propertyBlips) do
			RemoveBlip(v)
		end
	end

	for k, prop in pairs(properties) do
		local coords = prop.entering

		if prop.is_buyable then
			if prop.is_unique then
				if propertyOwner ~= nil and #propertyOwner > 0 then
					for k2, owned in pairs(propertyOwner) do
						if owned.property == prop.name then
							prop.showBlip = false
							-- Haus gehört jemandem
							break
						elseif k2 == #propertyOwner then
							prop.showBlip = true
							if Config.ShowAvailableBlips then
								local blip = AddBlipForCoord(coords.x, coords.y)
								SetBlipSprite(blip, 40)
								SetBlipDisplay(blip, 6)
								SetBlipScale(blip, 0.7)
								SetBlipColour(blip, 4)
								SetBlipAsShortRange(blip, true)
								BeginTextCommandSetBlipName("STRING");
								AddTextComponentString(Translation[Config.Locale]['blip_available_prop'])
								EndTextCommandSetBlipName(blip)
								table.insert(propertyBlips, blip)
							end
						end
					end
				else
					prop.showBlip = true
					if Config.ShowAvailableBlips then
						local blip = AddBlipForCoord(coords.x, coords.y)
						SetBlipSprite(blip, 40)
						SetBlipDisplay(blip, 6)
						SetBlipScale(blip, 0.7)
						SetBlipColour(blip, 4)
						SetBlipAsShortRange(blip, true)
						BeginTextCommandSetBlipName("STRING");
						AddTextComponentString(Translation[Config.Locale]['blip_available_prop'])
						EndTextCommandSetBlipName(blip)
						table.insert(propertyBlips, blip)
					end
				end
			else
				prop.showBlip = true
				if Config.ShowAvailableBlips then
					local blip = AddBlipForCoord(coords.x, coords.y)
					SetBlipSprite(blip, 40)
					SetBlipDisplay(blip, 6)
					SetBlipScale(blip, 0.7)
					SetBlipColour(blip, 4)
					SetBlipAsShortRange(blip, true)
					BeginTextCommandSetBlipName("STRING");
					AddTextComponentString(Translation[Config.Locale]['blip_available_prop'] )
					EndTextCommandSetBlipName(blip)
					table.insert(propertyBlips, blip)
				end	
			end
		end

		for k2, ownedprop in pairs(ownedProperties) do
			if ownedprop.property == prop.name then
				
				local blip = AddBlipForCoord(coords.x, coords.y)
				SetBlipSprite(blip, 40)
				SetBlipDisplay(blip, 6)
				SetBlipScale(blip, 1.0)
				SetBlipColour(blip, 2)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING");
				AddTextComponentString(Translation[Config.Locale]['blip_prop_owned'])
				EndTextCommandSetBlipName(blip)
				table.insert(propertyBlips, blip)
				--[[--]]
			end
		end

		if #trustedProperties > 0 then
			for k3, trustProp in pairs(trustedProperties) do
				if trustProp.property == prop.name then
					local blip = AddBlipForCoord(coords.x, coords.y)
					SetBlipSprite(blip, 40)
					SetBlipDisplay(blip, 6)
					SetBlipScale(blip, 1.0)
					SetBlipColour(blip, 3)
					SetBlipAsShortRange(blip, true)
					BeginTextCommandSetBlipName("STRING");
					if trustProp.owner ~= nil then
						AddTextComponentString(Translation[Config.Locale]['blip_keyowner'] .. trustProp.owner)
					else
						AddTextComponentString(Translation[Config.Locale]['blip_keyowner_unknown'])
					end
					EndTextCommandSetBlipName(blip)
					table.insert(propertyBlips, blip)
				end
			end
		end
	end
end

Citizen.CreateThread(function()
		

	Citizen.Wait(3000)

	if Config.Debug then
		TriggerServerEvent('myProperties:getProperties') --DEBUG
	end
	
	while not gotAllProperties do
		Wait(100)
	end

	refreshBlips()

end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)

		if isinProperty then
		
			if currentPropertyData ~= nil then
			
				DrawMarker(27, currentPropertyData.room_menu.x, currentPropertyData.room_menu.y, currentPropertyData.room_menu.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0*1.5, 1.0*1.5, 1.0, 136, 0, 136, 75, false, false, 2, false, false, false, false)
				DrawMarker(27, currentPropertyData.inside.x, currentPropertyData.inside.y, currentPropertyData.inside.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0*1.0, 1.0*1.0, 1.0, 136, 0, 136, 75, false, false, 2, false, false, false, false)
			
			end
		
		end

		if isNearMarker then
			DrawMarker(27, currentEnterLoc.x, currentEnterLoc.y, currentEnterLoc.z - 0.99, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9*0.9, 0.9*0.9, 1.0, 136, 0, 136, 75, false, false, 2, false, false, false, false)
		end

		if isinMarker then
			_menuPool:ProcessMenus()
			showInfobar(Translation[Config.Locale]['show_info'])
			if IsControlJustReleased(0, 38) then
				for k, prop in pairs(properties) do
					if currentLocation == prop.id then
						if prop.depends ~= 'Collector' then -- Wenn nur eine Wohnung
							if #ownedProperties > 0 then
								for i=1, #ownedProperties, 1 do
									if ownedProperties[i].property == prop.name then
										propertyID = ownedProperties[i].id
										generateEstateMenu(prop, true)
										break
									else 
										if i == #ownedProperties then
											generateEstateMenu(prop, false)
										end
									end
								end
							else
								generateEstateMenu(prop, false)
							end
						else -- wenn mehrere
							local propsDepend = {}
							for k2, propdep in pairs(properties) do
								if propdep.depends == prop.name then
									table.insert(propsDepend, {
										name = propdep.name,
										label = propdep.label,
									})
								end
								if k2 == #properties then
									generateSelectMenu(prop, propsDepend)
								end
							end
						end
						break
					end
				end
				
			end
		elseif isinLeaveMarker then
			_menuPool:ProcessMenus()
			showInfobar(Translation[Config.Locale]['leave_prop_infobar'])
			if IsControlJustReleased(0, 38) then
				generateDoorMenu()
			end
		elseif isinRoomMenu then
			_menuPool:ProcessMenus()
			showInfobar(Translation[Config.Locale]['access_wardrobe'])
			if IsControlJustReleased(0, 38) then
				for i=1, #propertyOwner, 1 do
					if propertyOwner[i].id == propertyID then
						generateWardrobeMenu(propertyOwner[i].owner)
						break
					end
				end
			end
		else
			_menuPool:CloseAllMenus()
		end
		

	end

end)

function setNearestBlip(loc)
 if currentMapBlip ~= nil then
	RemoveBlip(currentMapBlip)
 end
 currentMapBlip = AddBlipForCoord(loc.x, loc.y)
 SetBlipSprite(currentMapBlip, 40)
 SetBlipDisplay(currentMapBlip, 6)
 SetBlipScale(currentMapBlip, 0.7)
 SetBlipColour(currentMapBlip, 4)
 SetBlipAsShortRange(blip, true)
 BeginTextCommandSetBlipName("STRING");
 AddTextComponentString(Translation[Config.Locale]['blip_available_prop'])
 EndTextCommandSetBlipName(currentMapBlip)

end

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(400)

		isinMarker = false
		isNearMarker = false
		isinLeaveMarker = false
		isinRoomMenu = false


		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local closestDistance = 10000

		for k, prop in pairs(properties) do
			--[[if prop.depends ~= 'Collector' then
				local distanceLeave = Vdist(playerCoords, prop.inside.x, prop.inside.y, prop.inside.z)

				if distanceLeave <= 1.5 then
					isinLeaveMarker = true
					currentLocation = prop.id
				end
			end--]]
			
			if prop.is_single then
				local coords = prop.entering
				local distance = Vdist(playerCoords, coords.x, coords.y, coords.z)
				
				if Config.ShowOnlyNearestProperty then
					if distance < closestDistance and prop.showBlip then
						closestDistance = distance
						setNearestBlip(coords)
					end
				end

				if distance <= 1.5 then
					isNearMarker = true
					isinMarker = true
					currentEnterLoc = coords
					currentLocation = prop.id
				elseif distance <= 25.0 then
					isNearMarker = true
					currentEnterLoc = coords
				end

			end
		end

		if isinProperty then
			if currentPropertyData ~= nil then
				local distanceLeave = Vdist(playerCoords, currentPropertyData.inside.x, currentPropertyData.inside.y, currentPropertyData.inside.z)
				if distanceLeave <= 1.5 then
					isinLeaveMarker = true
				end
				local distanceRoommenu = Vdist(playerCoords, currentPropertyData.room_menu.x, currentPropertyData.room_menu.y, currentPropertyData.room_menu.z)
				if distanceRoommenu <= 1.5 then
					isinRoomMenu = true
				end
			end

		end


	end


end)

local wardrobeMenu = nil

function generateWardrobeMenu(owner)

    _menuPool:Remove()
	collectgarbage()
	
	if wardrobeMenu ~= nil and wardrobeMenu:Visible() then
		wardrobeMenu:Visible(false)
	end
	
	wardrobeMenu = NativeUI.CreateMenu(Translation[Config.Locale]['prop'], nil)
	_menuPool:Add(wardrobeMenu)

	local isOwner = false
	for k, ownedProp in pairs(ownedProperties) do
		if ownedProp.id == propertyID then
			isOwner = true
			break
		end
	end

	if isOwner then
		local trustedPlayersList = {}
		local currentDeposit = 0
		local currentBlackDeposit = 0
		print('initial set: ' .. currentBlackDeposit)

		local trust = _menuPool:AddSubMenu(wardrobeMenu, Translation[Config.Locale]['manage_keys'])
		local highestIndex = 0
		
		for k, props in pairs(propertyOwner) do
			if propertyID == props.id then
				trustedPlayersList = props.trusted
				
				for i=1, #props.trusted, 1 do

					local trustedPlayer = NativeUI.CreateItem(props.trusted[i].name, Translation[Config.Locale]['remove_key_desc'])
					if Config.useNativeUIReloaded then
						trust.SubMenu:AddItem(trustedPlayer)
					else
						trust:AddItem(trustedPlayer)
					end

					highestIndex = highestIndex + 1
					
				end
			end
		end

		local add
		if Config.useNativeUIReloaded then
			add = _menuPool:AddSubMenu(trust.SubMenu, Translation[Config.Locale]['give_key'])
		else
			add = _menuPool:AddSubMenu(trust, Translation[Config.Locale]['give_key'])
		end
		
		local playersInArea = ESX.Game.GetPlayersInArea(currentPropertyData.room_menu, 10.0)

		local gotOSResult = false
		if Config.useOneSyncInfinity then
			ESX.TriggerServerCallback('myProperties:getPlayersInArea', function(playersInArea_res)
				playersInArea = playersInArea_res
				gotOSResult = true
			end, currentPropertyData.room_menu, 10.0)
		end

		for i=1, 10, 1 do
			if not gotOSResult then
				Citizen.Wait(100)
			end
		end

		for k, player in pairs(playersInArea) do
			--if player ~= GetPlayerServerId(-1) then
				
				local playeradd
				if Config.useOneSyncInfinity then
					local playername = 'Playername'
					if player.name ~= nil then
						playername = player.name
					end
					playeradd = NativeUI.CreateItem(player.name, Translation[Config.Locale]['give_key_desc'] .. playername .. Translation[Config.Locale]['give_key_desc2'])
					if Config.useNativeUIReloaded then
						add.SubMenu:AddItem(playeradd)
					else
						add:AddItem(playeradd)
					end
				else
					playeradd = NativeUI.CreateItem(GetPlayerName(player), Translation[Config.Locale]['give_key_desc'] .. GetPlayerName(player) .. Translation[Config.Locale]['give_key_desc2'])
					if Config.useNativeUIReloaded then
						add.SubMenu:AddItem(playeradd)
					else
						add:AddItem(playeradd)
					end
				end

				if Config.useNativeUIReloaded then
					add.SubMenu.OnItemSelect = function(sender, item, index)
						if Config.useOneSyncInfinity then
							TriggerServerEvent('myProperties:updateTrusted', "add", playersInArea[index].id, propertyID)
						else
							TriggerServerEvent('myProperties:updateTrusted', "add", GetPlayerServerId(playersInArea[index]), propertyID)
						end
						
					end
				else
					add.OnItemSelect = function(sender, item, index)
						if Config.useOneSyncInfinity then
							TriggerServerEvent('myProperties:updateTrusted', "add", playersInArea[index].id, propertyID)
						else
							TriggerServerEvent('myProperties:updateTrusted', "add", GetPlayerServerId(playersInArea[index]), propertyID)
						end
						
					end
				end
				
			--end
		end
		
		if Config.useNativeUIReloaded then
			trust.SubMenu.OnItemSelect = function(sender, item, index)
				if index <= highestIndex then
					TriggerServerEvent('myProperties:updateTrusted', "del", trustedPlayersList[index].steamID, propertyID)
				end
			end
		else
			trust.OnItemSelect = function(sender, item, index)
				if index <= highestIndex then
					TriggerServerEvent('myProperties:updateTrusted', "del", trustedPlayersList[index].steamID, propertyID)
				end
			end
		end

		
	end

	local wardrobe = _menuPool:AddSubMenu(wardrobeMenu, Translation[Config.Locale]['wardrobe'])
	local selectedIndex = 1
	if Config.useMyClothesAPI then
		ESX.TriggerServerCallback('clothes:requestData', function(dressing)
			for i=1, #dressing, 1 do
				local dress
				if Config.useNativeUIReloaded then
					dress = _menuPool:AddSubMenu(wardrobe.SubMenu, dressing[i].name)
				else
					dress = _menuPool:AddSubMenu(wardrobe, dressing[i].name)
				end
				
				local takeOn = NativeUI.CreateItem(Translation[Config.Locale]['outfin_use'], '~b~')
				local remove = NativeUI.CreateItem(Translation[Config.Locale]['outfit_remove'], '~b~')

				if Config.useNativeUIReloaded then
					dress.SubMenu:AddItem(takeOn)
					dress.SubMenu:AddItem(remove)

					wardrobe.SubMenu.OnIndexChange = function(sender, index)
						selectedIndex = index
					end
				else
					dress:AddItem(takeOn)
					dress:AddItem(remove)
	
					wardrobe.OnIndexChange = function(sender, index)
						selectedIndex = index
					end
				end
				
				if Config.useNativeUIReloaded then
					dress.SubMenu.OnItemSelect = function(sender, item, index)
						if item == takeOn then
							TriggerEvent('skinchanger:getSkin', function(skin)
		
								--ESX.TriggerServerCallback('lils_properties:getPlayerOutfit', function(clothes)
					
								TriggerEvent('skinchanger:loadClothes', skin, dressing[selectedIndex].clothesData)
								TriggerEvent('esx_skin:setLastSkin', skin)
				
								TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
								end)
					
								--end, selectedIndex)
					
							end)
						elseif item == remove then
							TriggerServerEvent('clothes:removeOutfit', dressing[selectedIndex].id)
							ShowNotification(Translation[Config.Locale]['outfit_delete'] .. dressing[selectedIndex].name .. Translation[Config.Locale]['outfit_delete2'])
							_menuPool:CloseAllMenus()
						end
					end
				else
					dress.OnItemSelect = function(sender, item, index)
						if item == takeOn then
							TriggerEvent('skinchanger:getSkin', function(skin)
		
								--ESX.TriggerServerCallback('lils_properties:getPlayerOutfit', function(clothes)
					
								TriggerEvent('skinchanger:loadClothes', skin, dressing[selectedIndex].clothesData)
								TriggerEvent('esx_skin:setLastSkin', skin)
				
								TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
								end)
					
								--end, selectedIndex)
					
							end)
						elseif item == remove then
							TriggerServerEvent('clothes:removeOutfit', dressing[selectedIndex].id)
							ShowNotification(Translation[Config.Locale]['outfit_delete'] .. dressing[selectedIndex].name .. Translation[Config.Locale]['outfit_delete2'])
							_menuPool:CloseAllMenus()
						end
					end
				end
				
				_menuPool:RefreshIndex()
				_menuPool:MouseEdgeEnabled (false)
			end
		end)
	else
		ESX.TriggerServerCallback('myProperties:getPlayerDressing', function(dressing)
			for i=1, #dressing, 1 do
				local dress
				if Config.useNativeUIReloaded then
					dress = _menuPool:AddSubMenu(wardrobe.SubMenu, dressing[i])
				else
					dress = _menuPool:AddSubMenu(wardrobe, dressing[i])
				end
					local takeOn = NativeUI.CreateItem(Translation[Config.Locale]['outfin_use'], '~b~')
				local remove = NativeUI.CreateItem(Translation[Config.Locale]['outfit_remove'], '~b~')

				if Config.useNativeUIReloaded then
					dress.SubMenu:AddItem(takeOn)
					dress.SubMenu:AddItem(remove)
		
					wardrobe.SubMenu.OnIndexChange = function(sender, index)
						selectedIndex = index
					end
		
					dress.SubMenu.OnItemSelect = function(sender, item, index)
						if item == takeOn then
							TriggerEvent('skinchanger:getSkin', function(skin)
		
								ESX.TriggerServerCallback('myProperties:getPlayerOutfit', function(clothes)
					
									TriggerEvent('skinchanger:loadClothes', skin, clothes)
									TriggerEvent('esx_skin:setLastSkin', skin)
					
									TriggerEvent('skinchanger:getSkin', function(skin)
									TriggerServerEvent('esx_skin:save', skin)
									end)
					
								end, selectedIndex)
					
							end)
						elseif item == remove then
							TriggerServerEvent('myProperties:removeOutfit', selectedIndex)
							ShowNotification(Translation[Config.Locale]['outfit_removed'] .. dressing[selectedIndex] .. Translation[Config.Locale]['outfit_removed2'])
							_menuPool:CloseAllMenus()
						end
					end
				else
					dress:AddItem(takeOn)
					dress:AddItem(remove)
		
					wardrobe.OnIndexChange = function(sender, index)
						selectedIndex = index
					end
		
					dress.OnItemSelect = function(sender, item, index)
						if item == takeOn then
							TriggerEvent('skinchanger:getSkin', function(skin)
		
								ESX.TriggerServerCallback('myProperties:getPlayerOutfit', function(clothes)
					
									TriggerEvent('skinchanger:loadClothes', skin, clothes)
									TriggerEvent('esx_skin:setLastSkin', skin)
					
									TriggerEvent('skinchanger:getSkin', function(skin)
									TriggerServerEvent('esx_skin:save', skin)
									end)
					
								end, selectedIndex)
					
							end)
						elseif item == remove then
							TriggerServerEvent('myProperties:removeOutfit', selectedIndex)
							ShowNotification(Translation[Config.Locale]['outfit_removed'] .. dressing[selectedIndex] .. Translation[Config.Locale]['outfit_removed2'])
							_menuPool:CloseAllMenus()
						end
					end
				end
				
				_menuPool:RefreshIndex()
				_menuPool:MouseEdgeEnabled (false)
			end
		end)
	end
	

	if not onlyVisit then
		local inventory_item
		local inventory_sub
		local tresor_sub

		if Config.useOxInventory then
			inventory_item = NativeUI.CreateItem(Translation[Config.Locale]['store'], '~b~')
			wardrobeMenu:AddItem(inventory_item)

			inventory_item.Activated = function(sender, index)
				--exports['linden_inventory']:OpenStash({ id = 'myProperty', slots = 20, owner = ESX.GetPlayerData().identifier()})
				local oxInvName = 'property_' .. propertyID
				if exports['ox_inventory']:openInventory('stash', oxInvName) == false then
					TriggerServerEvent('ox:loadStash', oxInvName)
					exports['ox_inventory']:openInventory('stash', oxInvName)
					wardrobeMenu:Visible(not wardrobeMenu:Visible())
				end
			end
		elseif Config.useCoreInventory then
			inventory_item = NativeUI.CreateItem(Translation[Config.Locale]['store'], '~b~')
			wardrobeMenu:AddItem(inventory_item)

			inventory_item.Activated = function(sender, index)
				--exports['linden_inventory']:OpenStash({ id = 'myProperty', slots = 20, owner = ESX.GetPlayerData().identifier()})
				local InvName = 'property_' .. propertyID
				TriggerServerEvent('core_inventory:server:openInventory', InvName, "stash")
				wardrobeMenu:Visible(not wardrobeMenu:Visible())
			end
		elseif Config.useChezzaInventory then
			inventory_item = NativeUI.CreateItem(Translation[Config.Locale]['store'], '~b~')
			wardrobeMenu:AddItem(inventory_item)

			inventory_item.Activated = function(sender, index)
				for koP, house in pairs(ownedProperties) do
					if Config.sameInventory then
						TriggerEvent('inventory:openInventory', {
							type = "house_" .. house.id,
							id = house.id,
							title = house.property,
							weight = 500,
							delay = 250,
							save = true
						})
					else
						TriggerEvent('inventory:openInventory', {
							type = "house_" .. house.id,
							id = ESX.GetPlayerData().identifier,
							title = house.property,
							weight = 500,
							delay = 250,
							save = true
						})
					end
				end

				_menuPool:CloseAllMenus()
			end
		else
			inventory_sub = _menuPool:AddSubMenu(wardrobeMenu, Translation[Config.Locale]['store'])
			tresor_sub = _menuPool:AddSubMenu(wardrobeMenu, Translation[Config.Locale]['weaponary'])
		end

		
		

		ESX.TriggerServerCallback('myProperties:getPropertyInventory', function(inventory)

			--local money = NativeUI.CreateItem('Bargeld: ', '~b~')
			--money:RightLabel(inventory.money)

			local inventoryItems = {}
			local wepaonsList = inventory.weapons

			if not Config.useOxInventory and not Config.useCoreInventory and not Config.useChezzaInventory then
				for k, item in pairs(inventory.items) do
					if item.count > 0 then
						local invitem = NativeUI.CreateItem(item.label, '~b~')
						invitem:RightLabel(item.count .. '~b~x')
						if Config.useNativeUIReloaded then
							inventory_sub.SubMenu:AddItem(invitem)
						else
							inventory_sub:AddItem(invitem)
						end
						
						table.insert(inventoryItems, {
							name = item.name,
							label = item.label,
							count = item.count,
						})
					end
					--item.name
				end

				for k, weapon in pairs(inventory.weapons) do
					local weaponinv = NativeUI.CreateItem(ESX.GetWeaponLabel(weapon.name), '~b~')
					weaponinv:RightLabel(weapon.ammo .. Translation[Config.Locale]['ammo']) 
					
					if Config.useNativeUIReloaded then
						tresor_sub.SubMenu:AddItem(weaponinv)
					else
						tresor_sub:AddItem(weaponinv)
					end
					--weapon.name
				end
			end




			if Config.useNativeUIReloaded then
				if not Config.useOxInventory and not Config.useCoreInventory and not Config.useChezzaInventory then
					inventory_sub.SubMenu.OnItemSelect = function(sender, item, index)

						local res_amount = CreateDialog(Translation[Config.Locale]['insert_withdraw'])
							if tonumber(res_amount) then
								local quantity = tonumber(res_amount)
								TriggerServerEvent('myProperties:getItem', propertyID, 'item_standard', inventoryItems[index].name, quantity)
								_menuPool:CloseAllMenus()
							end
		
					end

					tresor_sub.SubMenu.OnItemSelect = function(sender, item, index)
						TriggerServerEvent('myProperties:getItem', propertyID, 'item_weapon', wepaonsList[index].name, wepaonsList[index].ammo)
						_menuPool:CloseAllMenus()
					end
				end

				
			else
				if not Config.useOxInventory and not Config.useCoreInventory and not Config.useChezzaInventory then
					inventory_sub.OnItemSelect = function(sender, item, index)

						local res_amount = CreateDialog(Translation[Config.Locale]['insert_withdraw'])
							if tonumber(res_amount) then
								local quantity = tonumber(res_amount)
								TriggerServerEvent('myProperties:getItem', propertyID, 'item_standard', inventoryItems[index].name, quantity)
								_menuPool:CloseAllMenus()
							end
		
					end

					tresor_sub.OnItemSelect = function(sender, item, index)
						TriggerServerEvent('myProperties:getItem', propertyID, 'item_weapon', wepaonsList[index].name, wepaonsList[index].ammo)
						_menuPool:CloseAllMenus()
					end
				end
	
				
			end
			

			_menuPool:RefreshIndex()
		end, propertyID)

		if not Config.useOxInventory and not Config.useCoreInventory and not Config.useChezzaInventory then
			local putItem = _menuPool:AddSubMenu(wardrobeMenu, Translation[Config.Locale]['store_item'])

			ESX.TriggerServerCallback('myProperties:getPlayerInventory', function(inventory)
			
				local itemstoSelect = {}

				for k, itemininv in pairs(inventory.items) do
					if itemininv.count > 0 then
						local invitem = NativeUI.CreateItem(itemininv.label, '~b~')
						invitem:RightLabel(itemininv.count .. '~b~x')
						if Config.useNativeUIReloaded then
							putItem.SubMenu:AddItem(invitem)
						else
							putItem:AddItem(invitem)
						end

						table.insert(itemstoSelect, {
							type = 'item_standard',
							name = itemininv.name,
						})
					end

				end

				local playerPed  = GetPlayerPed(-1)
				local weaponList = ESX.GetWeaponList()

				for k, weaponsininv in pairs(weaponList) do

					local weaponHash = GetHashKey(weaponsininv.name)
					if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[k].name ~= 'WEAPON_UNARMED' then
						local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
						local weaponitem = NativeUI.CreateItem(weaponsininv.label, '~b~')
						weaponitem:RightLabel(ammo .. Translation[Config.Locale]['ammo'])
						if Config.useNativeUIReloaded then
							putItem.SubMenu:AddItem(weaponitem)
						else
							putItem:AddItem(weaponitem)
						end
						

						table.insert(itemstoSelect, {
							type = 'item_weapon',
							name = weaponsininv.name,
							ammo = ammo,
						})
					end

				end

				if Config.useNativeUIReloaded then
					putItem.SubMenu.OnItemSelect = function(sender, item, index)
					
						local selectedItem = itemstoSelect[index]
						
						if selectedItem.type == 'item_weapon' then
							print('got put item: ' .. selectedItem.name .. ' x' .. selectedItem.ammo)
							TriggerServerEvent('myProperties:putItem', propertyID, 'item_weapon', selectedItem.name, selectedItem.ammo)
							_menuPool:CloseAllMenus()
						elseif selectedItem.type == 'item_standard' then
							local res_amount = CreateDialog(Translation[Config.Locale]['insert_deposit'])
							if tonumber(res_amount) then
								local quantity = tonumber(res_amount)
								TriggerServerEvent('myProperties:putItem', propertyID, 'item_standard', selectedItem.name, quantity)
								_menuPool:CloseAllMenus()
							end
						end
		
					end
				else
					putItem.OnItemSelect = function(sender, item, index)
					
						local selectedItem = itemstoSelect[index]
						
						if selectedItem.type == 'item_weapon' then
							print('got put item: ' .. selectedItem.name .. ' x' .. selectedItem.ammo)
							TriggerServerEvent('myProperties:putItem', propertyID, 'item_weapon', selectedItem.name, selectedItem.ammo)
							_menuPool:CloseAllMenus()
						elseif selectedItem.type == 'item_standard' then
							local res_amount = CreateDialog(Translation[Config.Locale]['insert_deposit'])
							if tonumber(res_amount) then
								local quantity = tonumber(res_amount)
								TriggerServerEvent('myProperties:putItem', propertyID, 'item_standard', selectedItem.name, quantity)
								_menuPool:CloseAllMenus()
							end
						end
		
					end
				end
				

			
			end)
		end

		for k, props in pairs(propertyOwner) do
			if propertyID == props.id then
				currentDeposit = props.deposit
				print(currentBlackDeposit)
				print('from db: ' .. props.blackMoneyDeposit)
				currentBlackDeposit = props.blackMoneyDeposit
				print(currentBlackDeposit)
			end

		end
		local propDeposit = _menuPool:AddSubMenu(wardrobeMenu, Translation[Config.Locale]['wallet'])

		local depositBalance = NativeUI.CreateItem(Translation[Config.Locale]['credit'], Translation[Config.Locale]['current_credit'] .. currentDeposit .. Translation[Config.Locale]['currency'])
		depositBalance:RightLabel('~g~' .. currentDeposit .. Translation[Config.Locale]['currency'])
		if Config.useNativeUIReloaded then
			propDeposit.SubMenu:AddItem(depositBalance)
		else
			propDeposit:AddItem(depositBalance)
		end
		print('show ' .. tostring(currentBlackDeposit))
		local blackMoneyBalance = NativeUI.CreateItem(Translation[Config.Locale]['black_credit'], Translation[Config.Locale]['current_blackcredit'] .. currentBlackDeposit .. Translation[Config.Locale]['currency'])
		blackMoneyBalance:RightLabel('~g~' .. currentBlackDeposit .. Translation[Config.Locale]['currency'])
		if Config.useNativeUIReloaded then
			propDeposit.SubMenu:AddItem(blackMoneyBalance)
		else
			propDeposit:AddItem(blackMoneyBalance)
		end

		local depositMoney = NativeUI.CreateItem(Translation[Config.Locale]['money_deposit'], '~b~')
		if Config.useNativeUIReloaded then
			propDeposit.SubMenu:AddItem(depositMoney)
		else
			propDeposit:AddItem(depositMoney)
		end

		local depositBlackMoney = NativeUI.CreateItem(Translation[Config.Locale]['blackmoney_deposit'], '~b~')
		if Config.useNativeUIReloaded then
			propDeposit.SubMenu:AddItem(depositBlackMoney)
		else
			propDeposit:AddItem(depositBlackMoney)
		end
		
		local withdrawMoney = NativeUI.CreateItem(Translation[Config.Locale]['money_withdraw'], '~b~')
		if Config.useNativeUIReloaded then
			propDeposit.SubMenu:AddItem(withdrawMoney)
		else
			propDeposit:AddItem(withdrawMoney)
		end

		local withdrawBlackMoney = NativeUI.CreateItem(Translation[Config.Locale]['blackmoney_withdraw'], '~b~')
		if Config.useNativeUIReloaded then
			propDeposit.SubMenu:AddItem(withdrawBlackMoney)
		else
			propDeposit:AddItem(withdrawBlackMoney)
		end
		
		if Config.useNativeUIReloaded then
			propDeposit.SubMenu.OnItemSelect = function(sender, item, index)

				if item == depositMoney then
					local res_amount = CreateDialog(Translation[Config.Locale]['insert_deposit'])
					if tonumber(res_amount) then
						local quantity = tonumber(res_amount)
						TriggerServerEvent('myProperties:editPropDeposit', false, 'deposit', quantity, propertyID)
						_menuPool:CloseAllMenus()
					end
				elseif item == depositBlackMoney then
					local res_amount = CreateDialog(Translation[Config.Locale]['insert_deposit'])
					if tonumber(res_amount) then
						local quantity = tonumber(res_amount)
						TriggerServerEvent('myProperties:editPropDeposit', true, 'deposit', quantity, propertyID)
						_menuPool:CloseAllMenus()
					end
				elseif item == withdrawMoney then
					local res_amount = CreateDialog(Translation[Config.Locale]['insert_withdraw'])
					if tonumber(res_amount) then
						local quantity = tonumber(res_amount)
						TriggerServerEvent('myProperties:editPropDeposit', false, 'withdraw', quantity, propertyID)
						_menuPool:CloseAllMenus()
					end
				elseif item == withdrawBlackMoney then
					local res_amount = CreateDialog(Translation[Config.Locale]['insert_withdraw'])
					if tonumber(res_amount) then
						local quantity = tonumber(res_amount)
						TriggerServerEvent('myProperties:editPropDeposit', true, 'withdraw', quantity, propertyID)
						_menuPool:CloseAllMenus()
					end
				end
	
			end
		else
			propDeposit.OnItemSelect = function(sender, item, index)

				if item == depositMoney then
					local res_amount = CreateDialog(Translation[Config.Locale]['insert_deposit'])
					if tonumber(res_amount) then
						local quantity = tonumber(res_amount)
						TriggerServerEvent('myProperties:editPropDeposit', false, 'deposit', quantity, propertyID)
						_menuPool:CloseAllMenus()
					end
				elseif item == depositBlackMoney then
					local res_amount = CreateDialog(Translation[Config.Locale]['insert_deposit'])
					if tonumber(res_amount) then
						local quantity = tonumber(res_amount)
						TriggerServerEvent('myProperties:editPropDeposit', true, 'deposit', quantity, propertyID)
						_menuPool:CloseAllMenus()
					end
				elseif item == withdrawMoney then
					local res_amount = CreateDialog(Translation[Config.Locale]['insert_withdraw'])
					if tonumber(res_amount) then
						local quantity = tonumber(res_amount)
						TriggerServerEvent('myProperties:editPropDeposit', false, 'withdraw', quantity, propertyID)
						_menuPool:CloseAllMenus()
					end
				elseif item == withdrawBlackMoney then
					local res_amount = CreateDialog(Translation[Config.Locale]['insert_withdraw'])
					if tonumber(res_amount) then
						local quantity = tonumber(res_amount)
						TriggerServerEvent('myProperties:editPropDeposit', true, 'withdraw', quantity, propertyID)
						_menuPool:CloseAllMenus()
					end
				end
	
			end
		end
		

	end

	
	
	
	wardrobeMenu:Visible(not wardrobeMenu:Visible())

	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
	_menuPool:ControlDisablingEnabled(false)

end

local doorMenu = nil

function generateDoorMenu()
    _menuPool:Remove()
    collectgarbage()

	if doorMenu ~= nil and doorMenu:Visible() then
		doorMenu:Visible(false)
	end

    doorMenu = NativeUI.CreateMenu(currentPropertyData.type, nil)
	_menuPool:Add(doorMenu)

		local invite = _menuPool:AddSubMenu(doorMenu, Translation[Config.Locale]['invite'])
		local playersInArea = ESX.Game.GetPlayersInArea(currentPropertyData.entering, 10.0)

		local gotOSResult = false
		if Config.useOneSyncInfinity then
			ESX.TriggerServerCallback('myProperties:getPlayersInArea', function(playersInArea_res)
				playersInArea = playersInArea_res
				gotOSResult = true
			end, currentPropertyData.entering, 10.0)
		end

		for i=1, 10, 1 do
			if not gotOSResult then
				Citizen.Wait(100)
			end
		end

		for k, player in pairs(playersInArea) do
			local playerInvite
			if Config.useOneSyncInfinity then
				playerInvite = NativeUI.CreateItem(player.name, Translation[Config.Locale]['invite_player'] .. player.name .. Translation[Config.Locale]['invite_player2'])
				if Config.useNativeUIReloaded then
					invite.SubMenu:AddItem(playerInvite)
				else
					invite:AddItem(playerInvite)
				end
				
			else
				playerInvite = NativeUI.CreateItem(GetPlayerName(player), Translation[Config.Locale]['invite_player'] .. GetPlayerName(player) .. Translation[Config.Locale]['invite_player2'])
				if Config.useNativeUIReloaded then
					invite.SubMenu:AddItem(playerInvite)
				else
					invite:AddItem(playerInvite)
				end
			end
			
		end

		if Config.useNativeUIReloaded then
			invite.SubMenu.OnItemSelect = function(sender, item, index)
			
				if Config.useOneSyncInfinity then
					TriggerServerEvent('myProperties:invitePlayer', playersInArea[index].id, propertyID, currentPropertyData)
					ShowNotification(Translation[Config.Locale]['invited_player'] .. playersInArea[index].name .. Translation[Config.Locale]['invited_player2'])
				else
					TriggerServerEvent('myProperties:invitePlayer', GetPlayerServerId(playersInArea[index]), propertyID, currentPropertyData)
					ShowNotification(Translation[Config.Locale]['invited_player'] .. GetPlayerName(playersInArea[index]) .. Translation[Config.Locale]['invited_player2'])
				end
				
			end
		else
			invite.OnItemSelect = function(sender, item, index)
			
				if Config.useOneSyncInfinity then
					TriggerServerEvent('myProperties:invitePlayer', playersInArea[index].id, propertyID, currentPropertyData)
					ShowNotification(Translation[Config.Locale]['invited_player'] .. playersInArea[index].name .. Translation[Config.Locale]['invited_player2'])
				else
					TriggerServerEvent('myProperties:invitePlayer', GetPlayerServerId(playersInArea[index]), propertyID, currentPropertyData)
					ShowNotification(Translation[Config.Locale]['invited_player'] .. GetPlayerName(playersInArea[index]) .. Translation[Config.Locale]['invited_player2'])
				end
				
			end
		end
		

	local changePropPlate
	if not onlyVisit then
		
		local lockedStates = {
			Translation[Config.Locale]['lock_only_key'],
			Translation[Config.Locale]['lock_open'],
			--'nur Besitzer', -- needed for- in otherApartments.OnItemSelect .. and i dont want whis :crying:
		}

		local lock = NativeUI.CreateListItem(Translation[Config.Locale]['doorlock'], lockedStates, 1, Translation[Config.Locale]['doorlock_desc'])
		doorMenu:AddItem(lock)

		doorMenu.OnListSelect = function(sender, item, index)
			if item == lock then
				ShowNotification(Translation[Config.Locale]['doorlock_changed'] .. lockedStates[index])
				TriggerServerEvent('myProperties:saveLockState', propertyID, index)
			end
		end

		changePropPlate = NativeUI.CreateItem(Translation[Config.Locale]['doorbell'], Translation[Config.Locale]['doorbell_desc'])
		changePropPlate:RightLabel('~r~' .. Config.ChangeDoorbellPrice .. Translation[Config.Locale]['currency'])
		doorMenu:AddItem(changePropPlate)
	end

	local leave = NativeUI.CreateItem(Translation[Config.Locale]['leave_prop_pre'] .. currentPropertyData.type .. Translation[Config.Locale]['leave_prop'], '~b~')
	leave:RightLabel('~b~→→→')
	doorMenu:AddItem(leave)

	doorMenu.OnItemSelect = function(sender, item, index)
		if item == leave then
			TriggerServerEvent('myProperties:leaveProperty', currentPropertyData)
			doorMenu:Visible(false)
		elseif changePropPlate ~= nil and item == changePropPlate then
			local res_plate = CreateDialog(Translation[Config.Locale]['doorbell'])
			if res_plate ~= nil and res_plate ~= '' then
				TriggerServerEvent('myProperties:editPropPlate', propertyID, res_plate)
				_menuPool:CloseAllMenus()
			end
		end
	end
	

	doorMenu:Visible(not doorMenu:Visible())

	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
	_menuPool:ControlDisablingEnabled(false)
end

local SelectMenu = nil

function generateSelectMenu(base, PropsBelongtoBase)
    _menuPool:Remove()
    collectgarbage()
	
	if SelectMenu ~= nil and SelectMenu:Visible() then
		SelectMenu:Visible(false)
	end

    SelectMenu = NativeUI.CreateMenu(base.label, '~b~' .. #PropsBelongtoBase .. Translation[Config.Locale]['collector_propamount'])
	_menuPool:Add(SelectMenu)
	

	for k, prop in pairs(PropsBelongtoBase) do
		local found = false
		for k2, ownedProps in pairs(ownedProperties) do
			if ownedProps.property == prop.name then
				local select = NativeUI.CreateItem(Translation[Config.Locale]['owned_prefix'] .. prop.label, '~b~')
				SelectMenu:AddItem(select)
				found = true
				break
			end
		end
		if not found then
			local select2 = NativeUI.CreateItem(prop.label, '~b~')
			SelectMenu:AddItem(select2)
		end
	end



	SelectMenu.OnItemSelect = function(sender, item, index)

		local selectedProp = {}
		for k2, prope in pairs(properties) do
			if prope.name == PropsBelongtoBase[index].name then
				selectedProp = prope
				break
			end
		end

		SelectMenu:Visible(false)
		if #ownedProperties > 0 then
			for i=1, #ownedProperties, 1 do
				if ownedProperties[i].property == selectedProp.name then
					propertyID = ownedProperties[i].id
					generateEstateMenu(selectedProp, true)
					break
				else 
					if i == #ownedProperties then
						generateEstateMenu(selectedProp, false)
					end
				end
			end
		else
			generateEstateMenu(selectedProp, false)
		end

	end

	_menuPool:CloseAllMenus()
	SelectMenu:Visible(not SelectMenu:Visible())

	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
	_menuPool:ControlDisablingEnabled(false)

end

local menu = nil

function generateEstateMenu(prop, owns)
    _menuPool:Remove()
    collectgarbage()

	if menu ~= nil and menu:Visible() then
		menu:Visible(false)
	end

    menu = NativeUI.CreateMenu(Translation[Config.Locale]['prop'], nil)
    _menuPool:Add(menu)

	local coords = prop.entering
	local s1 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
	local street1 = GetStreetNameFromHashKey(s1)

	local isOwned = NativeUI.CreateItem(Translation[Config.Locale]['info_owned'], '~b~')
	if owns then
		isOwned:RightLabel(Translation[Config.Locale]['info_yes'])
	else
		isOwned:RightLabel(Translation[Config.Locale]['info_no'])
	end
	local type = NativeUI.CreateItem(Translation[Config.Locale]['info_type'], '~b~')
	type:RightLabel(prop.type)
	local name = NativeUI.CreateItem(Translation[Config.Locale]['info_name'], '~b~')
	name:RightLabel(prop.label)
	local adress = NativeUI.CreateItem(Translation[Config.Locale]['info_adress'], '~b~')
	adress:RightLabel(street1)
	local unique = NativeUI.CreateItem(Translation[Config.Locale]['unique'], '~b~')
	if prop.is_unique then
		unique:RightLabel(Translation[Config.Locale]['info_yes'])
	else
		unique:RightLabel(Translation[Config.Locale]['info_no'])
	end

	
	menu:AddItem(type)
	menu:AddItem(name)
	menu:AddItem(adress)
	menu:AddItem(unique)
	local spacer = NativeUI.CreateItem('~b~', '~b~')
	menu:AddItem(spacer)
	menu:AddItem(isOwned)
		
	if owns then

		--local myapartment = _menuPool:AddSubMenu(menu, '~b~' .. prop.type .. ' verwalten', nil, nil)
		
		local enter = NativeUI.CreateItem(Translation[Config.Locale]['enter_prop'], '~b~')
		enter:RightLabel('~b~→→→')
		menu:AddItem(enter)

		menu.OnItemSelect = function(sender, item, index)

			if item == enter then
				TriggerServerEvent('myProperties:enterProperty', propertyID, prop)
				_menuPool:CloseAllMenus()
			end

		end
		

	end

	local propertyIsSold = false

	if prop.is_unique then
		for k, ownedProps in pairs(propertyOwner) do
			if ownedProps.property == prop.name then
				
				--local isBought = NativeUI.CreateItem('~r~Wohnung nicht mehr verfügbar!')
				local owner = NativeUI.CreateItem(Translation[Config.Locale]['owner'], '~b~')
				owner:RightLabel(ownedProps.charname)
				
				--if not owns then
				--	menu:AddItem(isBought)
				--end
				menu:AddItem(owner)
				propertyIsSold = true
				break
			end
		
		end
	
	end
		
		--if #trustedProperties > 0 then
		local propertiesToSelect = {}
		local otherApartments = _menuPool:AddSubMenu(menu, Translation[Config.Locale]['enter_key_prop'])
		for k2, trusted in pairs(trustedProperties) do
			if trusted.property == prop.name then
				local enterTrusted = NativeUI.CreateItem(Translation[Config.Locale]['prop_of'] .. trusted.owner , Translation[Config.Locale]['have_key'])
				enterTrusted:RightLabel('~b~→→→')
				if Config.useNativeUIReloaded then
					otherApartments.SubMenu:AddItem(enterTrusted)
				else
					otherApartments:AddItem(enterTrusted)
				end
				
				table.insert(propertiesToSelect, {
					id = trusted.id,
					type = 'key',
				})
			end
		end

		for k3, public in pairs(propertyOwner) do
			if public.property == prop.name then
				if public.locked == 2 then
					local enterPublic = NativeUI.CreateItem(Translation[Config.Locale]['prop_of'] .. public.charname , Translation[Config.Locale]['open_for_everybody'])
					enterPublic:RightLabel('~g~→→→')

					if Config.useNativeUIReloaded then
						otherApartments.SubMenu:AddItem(enterPublic)
					else
						otherApartments:AddItem(enterPublic)
					end
					
					table.insert(propertiesToSelect, {
						id = public.id,
						type = 'public',
					})
				end
			end
		end
		--[[TriggerServerEvent('myProperties:getPlayersInProperties')
		while playersInProperties == nil do
			Wait(10)
		end
		for k3, playerinprop in pairs(playersInProperties) do
			print(playerinprop.property)
			if playerinprop.property == prop.name then
				local enterForeign = _menuPool:AddSubMenu(otherApartments, 'Wohnung von ' .. playerinprop.name)
				local clock = NativeUI.CreateItem('Klingeln', '~b~')
				enterForeign:AddItem(clock)
			end
		end--]]
		if Config.useNativeUIReloaded then
			otherApartments.SubMenu.OnItemSelect = function(sender, item, index)
				TriggerServerEvent('myProperties:enterProperty', propertiesToSelect[index].id, prop)
				propertyID = propertiesToSelect[index].id
				_menuPool:CloseAllMenus()
	
				if propertiesToSelect[index].type == 'public' then
					onlyVisit = true
				end
			end
		else
			otherApartments.OnItemSelect = function(sender, item, index)
				TriggerServerEvent('myProperties:enterProperty', propertiesToSelect[index].id, prop)
				propertyID = propertiesToSelect[index].id
				_menuPool:CloseAllMenus()
	
				if propertiesToSelect[index].type == 'public' then
					onlyVisit = true
				end
			end
		end
		
		--end


	if not owns then
		if prop.is_buyable then
			if not propertyIsSold then
				local buy = NativeUI.CreateItem(Translation[Config.Locale]['buy'], '~b~')
				buy:RightLabel(prop.price .. Translation[Config.Locale]['currency'])
				menu:AddItem(buy)
				local rent = NativeUI.CreateItem(Translation[Config.Locale]['rent'], '~b~')
				rent:RightLabel(prop.price / Config.CalculateRentPrice .. Translation[Config.Locale]['rent_per_day'])
				menu:AddItem(rent)
				--local running = NativeUI.CreateItem('Laufende Kosten: ' , '~b~')
				--running:RightLabel(prop.price / 800 + 12 .. '$ / Tag')
				--menu:AddItem(running)

				menu.OnItemSelect = function(sender, item, index)

					if item == buy then
						TriggerServerEvent('myProperties:buy', prop.name, "BUY", prop.price)
						_menuPool:CloseAllMenus()
					elseif item == rent then
						TriggerServerEvent('myProperties:buy', prop.name, "RENT", prop.price / Config.CalculateRentPrice)
						_menuPool:CloseAllMenus()
					end

				end
			end
		end
	else
		local price = 0
		local rented = false
		for k, propOwner in pairs(propertyOwner) do
			if propOwner.id == propertyID then
				price = propOwner.price
				rented = propOwner.rented
				break
			end
		end
		if rented == 1 then
			local sell = _menuPool:AddSubMenu(menu, Translation[Config.Locale]['cancel_rent'])
			local rented = NativeUI.CreateItem(Translation[Config.Locale]['rented'], '~b~')
			rented:RightLabel(Translation[Config.Locale]['info_yes'])
			
			local confirm = NativeUI.CreateItem(Translation[Config.Locale]['cancel_prop'], '~b~')
			

			if Config.useNativeUIReloaded then
				sell.SubMenu:AddItem(confirm)
				sell.SubMenu:AddItem(rented)

				sell.SubMenu.OnItemSelect = function(sender, item, index)

					if item == confirm then
						TriggerServerEvent('myProperties:RemoveOwnedProperty', prop.name, 'SOURCE')
						_menuPool:CloseAllMenus()
					end
		
				end
			else
				sell:AddItem(confirm)
				sell:AddItem(rented)

				sell.OnItemSelect = function(sender, item, index)

					if item == confirm then
						TriggerServerEvent('myProperties:RemoveOwnedProperty', prop.name, 'SOURCE')
						_menuPool:CloseAllMenus()
					end
		
				end
			end

			
		else
			local sell = _menuPool:AddSubMenu(menu, Translation[Config.Locale]['sell_prop'])
			local rented = NativeUI.CreateItem(Translation[Config.Locale]['rented'], '~b~')
			rented:RightLabel(Translation[Config.Locale]['info_no'])
			
			local confirm = NativeUI.CreateItem(Translation[Config.Locale]['confirm'], Translation[Config.Locale]['confirm_desc'] .. price / 4 .. Translation[Config.Locale]['confirm_desc2'])
			confirm:RightLabel('~g~'.. price / Config.CalculateSellPrice .. '$')
			

			if Config.useNativeUIReloaded then
				sell.SubMenu:AddItem(rented)
				sell.SubMenu:AddItem(confirm)
				sell.SubMenu.OnItemSelect = function(sender, item, index)

					if item == confirm then
						TriggerServerEvent('myProperties:RemoveOwnedProperty', prop.name, 'SOURCE')
						TriggerServerEvent('myProperties:pay', price / Config.CalculateSellPrice)
						_menuPool:CloseAllMenus()
					end
		
				end
			else
				sell:AddItem(rented)
				sell:AddItem(confirm)
				sell.OnItemSelect = function(sender, item, index)

					if item == confirm then
						TriggerServerEvent('myProperties:RemoveOwnedProperty', prop.name, 'SOURCE')
						TriggerServerEvent('myProperties:pay', price / Config.CalculateSellPrice)
						_menuPool:CloseAllMenus()
					end
		
				end
			end
			
		end



	end
	




	menu:Visible(not menu:Visible())

	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
	_menuPool:ControlDisablingEnabled(false)
end


-- OLD VANISHING
-- Citizen.CreateThread(function()

-- 	while true do
-- 		Citizen.Wait(0)
-- 		local playerPed = PlayerPedId()
-- 		if isinProperty then
-- 			for k, user in pairs(vanishedUser) do
-- 				if user ~= playerPed then
-- 					--SetEntityLocallyInvisible(user)
-- 					--SetEntityNoCollisionEntity(playerPed,  user,  true)
-- 					SetEntityLocallyInvisible(user)
--                     SetEntityVisible(user, false, 0)
--                     SetEntityNoCollisionEntity(playerPed, user, true)
-- 				end

-- 			end
-- 		end

-- 	end

-- end)

-- RegisterNetEvent('myProperties:setPlayerInvisible')
-- AddEventHandler('myProperties:setPlayerInvisible', function(playerEnter, instanceId)

	
-- 	local otherPlayer = GetPlayerFromServerId(playerEnter)
	
-- 	if otherPlayer ~= nil then
-- 		local otherPlayerPed = GetPlayerPed(otherPlayer)
-- 		table.insert(vanishedUser, otherPlayerPed)
-- 	end

-- end)

-- RegisterNetEvent('myProperties:setPlayerVisible')
-- AddEventHandler('myProperties:setPlayerVisible', function(playerEnter)


-- 	local otherPlayer = GetPlayerFromServerId(playerEnter)
-- 	local otherPlayerPed = GetPlayerPed(otherPlayer)
	
-- 	for k, vanish in pairs(vanishedUser) do
-- 		if vanish == otherPlayerPed then
-- 			table.remove(vanishedUser, k)
-- 		end
-- 	end

-- end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		if isinProperty then
			for k, user in pairs(vanishedUser) do
				if user ~= playerPed then
					-- NetworkConcealEntity(user, true)
					-- SetEntityLocallyInvisible(user)/*
					-- SetEntityNoCollisionEntity(playerPed,  user,  true)
					SetEntityLocallyInvisible(user)
                    SetEntityVisible(user, false, 0)
                    SetEntityNoCollisionEntity(playerPed, user, true)
				end
			end
		elseif #vanishedUser > 0 then
			for k, user in pairs(vanishedUser) do
				if user ~= playerPed then
					NetworkConcealEntity(user, false)
				end
			end
			vanishedUser = {}
		end
	end
end)

RegisterNetEvent('myProperties:setPlayerInvisible')
AddEventHandler('myProperties:setPlayerInvisible', function(playerEnter, instanceId)
	local otherPlayer = GetPlayerFromServerId(playerEnter)
	if otherPlayer ~= nil then
		local otherPlayerPed = GetPlayerPed(otherPlayer)
		if otherPlayerPed ~= GetPlayerPed(-1) then
			table.insert(vanishedUser, otherPlayerPed)
			NetworkConcealEntity(otherPlayerPed, true)
		end
	end
end)

RegisterNetEvent('myProperties:setPlayerVisible')
AddEventHandler('myProperties:setPlayerVisible', function(playerEnter)
	local otherPlayer = GetPlayerFromServerId(playerEnter)
	local otherPlayerPed = GetPlayerPed(otherPlayer)
	for k, vanish in pairs(vanishedUser) do
		if vanish == otherPlayerPed then
			table.remove(vanishedUser, k)
			NetworkConcealEntity(otherPlayerPed, false)
		end
	end
end)


RegisterNetEvent('myProperties:enterProperty')
AddEventHandler('myProperties:enterProperty', function(prop)
	_menuPool:CloseAllMenus()
	local playerPed = PlayerPedId()
	local coords = prop.inside
	if prop.ipls ~= '[]' then
		RemoveIpl("apa_v_mp_h_01_b")
		RequestIpl(prop.ipls)
		while not IsIplActive(prop.ipls) do
			Citizen.Wait(0)
		end
	end

	SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
	NetworkSetVoiceChannel(propertyID)
    NetworkSetTalkerProximity(0.0)
	isinProperty = true
	currentPropertyData = prop
	TriggerServerEvent('myProperties:saveLastProperty', propertyID)

end)

RegisterNetEvent('myProperties:leaveProperty')
AddEventHandler('myProperties:leaveProperty', function(prop)

    Citizen.InvokeNative(0xE036A705F989E049)
    NetworkSetTalkerProximity(2.5)
	isinProperty = false	
	onlyVisit = false
	--vanishedUser = {}
	local playerPed = PlayerPedId()
	local coords = prop.entering
	SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
	RemoveIpl(prop.ipls)
	TriggerServerEvent('myProperties:saveLastProperty', 0)

end)

RegisterNetEvent('myProperties:sendPropertiesToClient')
AddEventHandler('myProperties:sendPropertiesToClient', function(properties_res, owner_res, steamID)

	properties = properties_res
	propertyOwner = owner_res
	ownedProperties = {}
	trustedProperties = {}

	for k, v in pairs(propertyOwner) do
		if steamID == v.owner then
			table.insert(ownedProperties, {
				id = v.id,
				property = v.property,
			})
		end
		for i=1, #v.trusted, 1 do
			if v.trusted[i].steamID ~= nil then
				if v.trusted[i].steamID == steamID then
					table.insert(trustedProperties, {
						id = v.id,
						property = v.property,
						owner = v.charname,
					})
				end
			end

		end
	end

	gotAllProperties = true
	Citizen.Wait(1000)
	refreshBlips()


end)

RegisterNetEvent('myProperties:updatePropertyOwner')
AddEventHandler('myProperties:updatePropertyOwner', function(line, updatedTable, steamID)

	propertyOwner[line] = updatedTable

	ownedProperties = {}
	trustedProperties = {}

	for k, v in pairs(propertyOwner) do
		if steamID == v.owner then
			table.insert(ownedProperties, {
				id = v.id,
				property = v.property,
			})
		end
		for i=1, #v.trusted, 1 do
			if v.trusted[i].steamID ~= nil then
				if v.trusted[i].steamID == steamID then
					table.insert(trustedProperties, {
						id = v.id,
						property = v.property,
						owner = v.charname,
					})
				end
			end

		end
	end

end)

-- This event is there to avoid performing the event above on each change of the lock for everyone.
RegisterNetEvent('myProperties:updateLockState')
AddEventHandler('myProperties:updateLockState', function(line, newLockState)

	propertyOwner[line].locked = newLockState

end)

RegisterNetEvent('myProperties:hasInvitation')
AddEventHandler('myProperties:hasInvitation', function(ID, propertyData)

	hasInvite = true

	Citizen.CreateThread(function()
	
		while hasInvite do
			Citizen.Wait(0)
			if IsControlJustReleased(0, 38) then
				TriggerServerEvent('myProperties:enterProperty', ID, propertyData)
				propertyID = ID
				hasInvite = false
				onlyVisit = true
			end

		end
	
	end)

	Citizen.Wait(10000)
	if hasInvite then
		hasInvite = false
		ShowNotification(Translation[Config.Locale]['invitation_expired'])
	end

end)

--[[RegisterNetEvent('myProperties:receiveCharName')
AddEventHandler('myProperties:receiveCharName', function(charname)
	
	ownedByCharname = charname
	print(ownedByCharname)
end)--]]

--[[RegisterNetEvent('myProperties:updatePlayersInProperties')
AddEventHandler('myProperties:updatePlayersInProperties', function(playersInProps)

	playersInProperties = playersInProps
end)--]]



