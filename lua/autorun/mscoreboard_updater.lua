----------------- Metrostroi Score Board -----------------
-- Автор: Alexell
-- Лицензия: MIT
-- Сайт: https://alexell.ru/
-- Steam: https://steamcommunity.com/id/alexell
-- Repo: https://github.com/Alexell/metrostroi_scoreboard
----------------------------------------------------------

if SERVER then
	util.AddNetworkString("MScoreBoard.ServerInfo")
	
	local function GetStationName(st_id,name_num)
		if Metrostroi.StationConfigurations[st_id] then
			return Metrostroi.StationConfigurations[st_id].names[name_num]
		else
			return ""
		end
	end
	
	local function BuildStationInfo(train)
		local prev_st = ""
		local cur_st = ""
		local next_st = ""
		local line = 0
		local result = ""
		
		-- TODO: нужно сделать так чтобы name_num был 1 для языка ru и другим для других языков. Свериться со всеми StationConfigurations карт.
		cur_st = GetStationName(train:ReadCell(49160),1)
		prev_st = GetStationName(train:ReadCell(49162),1)
		next_st = GetStationName(train:ReadCell(49161),1)
		if cur_st == "" then
			line = train:ReadCell(49167)
			result = "["..line.." путь] "..prev_st.." => "..next_st
		else
			line = train:ReadCell(49168)
			result = "["..line.." путь] "..cur_st
		end
		return result
	end
	
	timer.Create("MScoreBoard.ServerUpdate",3,0,function()
		local TrainCount = Metrostroi.TrainCount()
		if TrainCount >= 0 then
			net.Start("MScoreBoard.ServerInfo")
				net.WriteInt(TrainCount,6)
			net.Broadcast()
		end
		
		for k,v in pairs(ents.GetAll()) do
			if v.Base ~= "gmod_subway_base" and not scripted_ents.IsBasedOn(v:GetClass(), "gmod_subway_base") or IsValid(v.FrontTrain) and IsValid(v.RearTrain) then continue end
			local ply = v.Owner
			if (v:GetNW2String("RouteNumber") != "") then
				ply:SetNW2String("MSRoute",v:GetNW2String("RouteNumber"))
			end
			ply:SetNW2String("MSWagons",#v.WagonList)
			ply:SetNW2String("MSTrainClass",v:GetClass())
			ply:SetNW2String("MSStation",BuildStationInfo(v))
		end
		
		for k, v in pairs(player.GetAll()) do
			local train = v:GetTrain()
			if (IsValid(train) and train.DriverSeat == v:GetVehicle() and train.Owner == v) then
				v:SetNW2Bool("MSPlayerDriving",true)
			else
				v:SetNW2Bool("MSPlayerDriving",false)
			end
		end
	end)

	hook.Add("EntityRemoved","MScoreBoard.DeleteInfo",function (ent)
		local ply = ent.Owner
		if not IsValid(ply) then return end
		if ent:GetClass() == ply:GetNW2String("MSTrainClass") then
			ply:SetNW2String("MSRoute","-")
			ply:SetNW2String("MSWagons","-")
			ply:SetNW2String("MSTrainClass","-")
			ply:SetNW2String("MSStation","-")
		end
	end)
end
