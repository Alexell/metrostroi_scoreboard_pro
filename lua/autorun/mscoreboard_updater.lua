---------------------- Metrostroi Score Board ----------------------
-- Developer: Alexell
-- License: MIT
-- Website: https://alexell.ru/
-- Steam: https://steamcommunity.com/profiles/76561198210303223
-- Source code: https://github.com/Alexell/metrostroi_scoreboard_pro
--------------------------------------------------------------------

if SERVER then
	util.AddNetworkString("MScoreBoard.ClientInfo")
	util.AddNetworkString("MScoreBoard.EqualRoutes")
	
	local function FixedRoute(class,route)
		local result = "-"
		if (class ~= "-" and route ~= "-") then
			local rnum = tonumber(route)
			if table.HasValue({"gmod_subway_em508","gmod_subway_81-702","gmod_subway_81-703","gmod_subway_81-705_old","gmod_subway_ezh","gmod_subway_ezh3","gmod_subway_ezh3ru1","gmod_subway_81-717_mvm","gmod_subway_81-718","gmod_subway_81-720","gmod_subway_81-720_1","gmod_subway_81-720a","gmod_subway_81-717_freight","gmod_subway_81-717_5a", "gmod_subway_81-717_ars_minsk", "gmod_subway_am"},class) then rnum = rnum / 10 end
			result = rnum
		end
		return result
	end
	
	-- by Agent Smith
	local function CenteringStationPositions()
		if not Metrostroi.StationConfigurations then return end
		local centre
		for k1, v1 in pairs(ents.FindByClass("gmod_track_platform")) do
			if not Metrostroi.StationConfigurations[v1.StationIndex] then continue end
			for k2, v2 in pairs(ents.FindByClass("gmod_track_platform")) do
				if v1.StationIndex == v2.StationIndex and v1.PlatformIndex == 1 and v2.PlatformIndex == 2 then
					local pos1 = LerpVector(0.5, v1.PlatformStart, v2.PlatformStart)
					local pos2 = LerpVector(0.5, v1.PlatformEnd, v2.PlatformEnd)
					if isvector(pos1) and isvector(pos2) then 
						centre = LerpVector(0.5, pos1, pos2) 
					end
					if isvector(centre) and istable(Metrostroi.StationConfigurations[v1.StationIndex].positions) then
						table.insert(Metrostroi.StationConfigurations[v1.StationIndex].positions, 2, {centre, Angle(0, 0, 0)})
					end
				end
			end
		end
	end

	local TrainList = {}
	timer.Simple(1.5,function()
		for _,class in pairs(Metrostroi.TrainClasses) do
			local ENT = scripted_ents.Get(class)
			if not class:find("717_ars_minsk") and (not ENT.Spawner or not ENT.SubwayTrain) then continue end
			table.insert(TrainList,class)
		end
		if not MetrostroiAdvanced then CenteringStationPositions() end
	end)
	
	-- by Agent Smith
	local function GetLocation(pos)
		local ent_station = 0
		local map_pos
		local radius = 4000 -- Радиус по умолчанию для станций на всех картах
		local cur_map = game.GetMap()
		local Sz
		local S
		
		radius = radius*radius

		if Metrostroi.StationConfigurations then
			for k, v in pairs(Metrostroi.StationConfigurations) do
				if isnumber(k) and v.positions[2] then 
					map_pos = v.positions and v.positions[2] 
				else 
					map_pos = v.positions and v.positions[1] 
				end
				if cur_map:find("gm_metro_jar_imagine_line") then
					if v.names[1] == "ДДЭ" or v.names[1] == "Диспетчерская" then continue end
				end
				if map_pos then
					S = pos:DistToSqr(map_pos[1])
					if (pos.z > 0 and map_pos[1].z < 0) or (pos.z < 0 and map_pos[1].z > 0) then
						Sz = math.abs(pos.z) + math.abs(map_pos[1].z)
					end
					if (pos.z > 0 and map_pos[1].z > 0) or (pos.z < 0 and map_pos[1].z < 0) then
						Sz = math.abs(pos.z - map_pos[1].z)
					end
					if S < radius and Sz < 200 then 
						ent_station = k
						radius = S
					end
				end
			end
		end
		return ent_station
	end
	
	local function BuildStationInfo(train)
		local prev_st = 0
		local cur_st = 0
		local next_st = 0
		local line = 0
		local result = ""
		cur_st = train:ReadCell(49160)
		if cur_st > 0 then
			line = train:ReadCell(49168)
			result = line..","..cur_st
		else
			prev_st = train:ReadCell(49162)
			next_st = train:ReadCell(49161)
			if (prev_st > 0 and next_st > 0) then
				line = train:ReadCell(49167)
				result = line..","..prev_st..","..next_st
			else
				cur_st = GetLocation(train:GetPos())
				result = "0,"..cur_st
			end
		end
		return result
	end
	
	timer.Create("MScoreBoard.RouteNumbersChecker",60,0,function()
		local tbl = {}
		for k, v in pairs(player.GetAll()) do
			local rnumber = tonumber(v:GetNW2String("MSRoute","1000")) or 1000
			table.insert(tbl, {v, rnumber})
		end	
		for k, v in pairs(tbl) do
			for k2, v2 in pairs(tbl) do
				if k2 > k and v[1] != v2[1] and v[2] == v2[2] and (v[2] != 1000 and v2[2] != 1000) then 
					if not v[1]:GetNW2Bool("MSGuestDriving") and not v2[1]:GetNW2Bool("MSGuestDriving") then
						net.Start("MScoreBoard.EqualRoutes")
							net.WriteString(v[1]:Nick())
							net.WriteString(v2[1]:Nick())
						net.Broadcast()
					end
				end
			end
		end
	end)
	
	timer.Create("MScoreBoard.ServerUpdate",3,0,function()
		for train in pairs(Metrostroi.SpawnedTrains) do
			if not IsValid(train) then continue end
			local class = train:GetClass()
			if not table.HasValue(TrainList,class) then continue end
			local owner = train.Owner
			if not IsValid(owner) then continue end
			
			local route = 0
			if class:find("722") or class:find("7175p") then
				if train.RouteNumberSys then
					route = train.RouteNumberSys.CurrentRouteNumber
				end
			elseif class:find("717_6") or class:find("740_4") then
				if train.ASNP then
					route = train.ASNP.RouteNumber
				end
			else
				if train.RouteNumber then
					route = train.RouteNumber.RouteNumber
				end
			end
			route = FixedRoute(class,route)
			
			-- owner:SetNW2String("MSTrainClass",train:GetClass())
			-- костыль для грузового, т.к. у него сзади спавнится номерной мвм
			if not owner:GetNW2String("MSTrainClass"):find("717_freight") then owner:SetNW2String("MSTrainClass",class) end
			owner:SetNW2String("MSStation",BuildStationInfo(train))
			owner:SetNW2String("MSRoute",tostring(route))
			owner:SetNW2String("MSWagons",#train.WagonList)			
			local driver = train.DriverSeat:GetPassenger(0)
			if not IsValid(driver) then continue end
			if driver != owner then
				driver:SetNW2Bool("MSGuestDriving",true)
				driver:SetNW2String("MSHostDriver", owner:Nick())
				if not driver:GetNW2String("MSTrainClass"):find("717_freight") then driver:SetNW2String("MSTrainClass",class) end
				driver:SetNW2String("MSStation",BuildStationInfo(train))
				driver:SetNW2String("MSRoute",tostring(route))
			end
		end
		for k, v in pairs(player.GetAll()) do
			if v.Star then
				v:SetNW2Bool("MSPlayerStar", true)
			end
			local train = v:GetTrain()
			if IsValid(train) and train.DriverSeat == v:GetVehicle() then
				v:SetNW2Bool("MSPlayerDriving",true)
			else
				v:SetNW2Bool("MSPlayerDriving",false)
				if v:GetNW2Bool("MSGuestDriving") then
					v:SetNW2String("MSRoute","-")
					v:SetNW2String("MSTrainClass","-")
					v:SetNW2String("MSStation","0")
					v:SetNW2Bool("MSGuestDriving", false)
				end
				if not v:GetNW2String("MSTrainClass"):find("subway") then
					v:SetNW2String("MSStation", "0,"..GetLocation(v:GetPos()))
				end
			end
		end
	end)

	hook.Add("EntityRemoved","MScoreBoard.DeleteInfo",function(ent)
		local ply = ent.Owner
		if not IsValid(ply) then return end
		if ent:GetClass() == ply:GetNW2String("MSTrainClass") then
			ply:SetNW2String("MSRoute","-")
			ply:SetNW2String("MSWagons","-")
			ply:SetNW2String("MSTrainClass","-")
			ply:SetNW2String("MSStation","0")
		end
	end)
else
	-- CLIENT
end
