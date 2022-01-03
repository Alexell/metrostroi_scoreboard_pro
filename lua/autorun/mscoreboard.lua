---------------------- Metrostroi Score Board ----------------------
-- Developer: Alexell
-- License: MIT
-- Website: https://alexell.ru/
-- Steam: https://steamcommunity.com/profiles/76561198210303223
-- Source code: https://github.com/Alexell/metrostroi_scoreboard_pro
--------------------------------------------------------------------

MScoreBoard = MScoreBoard or {}
CreateConVar("mscoreboard_website", "https://metrostroi.net/profile/", FCVAR_REPLICATED)
if SERVER then
	AddCSLuaFile("metrostroi_scoreboard/mscoreboard.lua")
	AddCSLuaFile("metrostroi_scoreboard/player_row.lua")
	AddCSLuaFile("metrostroi_scoreboard/player_panel.lua")
else
	include("metrostroi_scoreboard/mscoreboard.lua")
	
	timer.Simple(2,function()
		function GAMEMODE:ScoreboardShow()
			MScoreBoard:Show()
		end

		function GAMEMODE:ScoreboardHide()
			MScoreBoard:Hide()
		end
	end)
end


