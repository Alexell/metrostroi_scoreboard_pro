----------------- Metrostroi Score Board -----------------
-- Автор: Alexell
-- Лицензия: MIT
-- Сайт: https://alexell.ru/
-- Steam: https://steamcommunity.com/id/alexell
-- Repo: https://github.com/Alexell/metrostroi_scoreboard
----------------------------------------------------------

if SERVER then
	util.AddNetworkString("MScoreBoard.ServerInfo")
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
		end
	end)

	hook.Add("EntityRemoved","MScoreBoard.DeleteInfo",function (ent)
		local ply = ent.Owner
		if not IsValid(ply) then return end
		if ent:GetClass() == ply:GetNW2String("MSTrainClass") then
			ply:SetNW2String("MSRoute","-")
			ply:SetNW2String("MSWagons","-")
			ply:SetNW2String("MSTrainClass","-")
		end
	end)
end

