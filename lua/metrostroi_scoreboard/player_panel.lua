-------------------- Metrostroi Score Board --------------------
-- Developer: Alexell
-- License: MIT
-- Website: https://alexell.ru/
-- Steam: https://steamcommunity.com/profiles/76561198210303223
-- Source code: https://github.com/Alexell/metrostroi_scoreboard
----------------------------------------------------------------

local function PlayerPermission(ply,permission)
	if ULib then
		return ULib.ucl.query(ply,permission)
	else
		return ply:IsAdmin()
	end
end

local PlayerPanel = {}

function PlayerPanel:Init()
		self.BtnWeb = vgui.Create("DImageButton",self)
		self.BtnWeb.DoClick = function() gui.OpenURL(MScoreBoard.Website..self.Player:SteamID()) end
	if (PlayerPermission(LocalPlayer(),"ulx prid")) then
		self.BtnPR = vgui.Create("DImageButton",self)
		self.BtnPR.DoClick = function() LocalPlayer():ConCommand("ulx prid "..self.Player:SteamID()) end
	end
	if (PlayerPermission(LocalPlayer(),"ulx goto")) then
		self.BtnGoTo = vgui.Create("DImageButton",self)
		self.BtnGoTo.DoClick = function() LocalPlayer():ConCommand("ulx goto "..self.Player:Nick()) end -- со SteamID работать не хочет
	end
	if (MetrostroiAdvanced and PlayerPermission(LocalPlayer(),"ulx traintp")) then
		self.BtnTrainTP = vgui.Create("DImageButton",self)
		self.BtnTrainTP.DoClick = function() LocalPlayer():ConCommand("ulx traintp "..self.Player:Nick()) end -- со SteamID работать не хочет
	end
	
end

function PlayerPanel:Paint(w,h)
	return true
end

function PlayerPanel:PerformLayout()
	local offset = 0
	self.BtnWeb:SetSize(32,32)
	self.BtnWeb:SetPos(0,0)
	self.BtnWeb:SetImage("mscoreboard/ms_profile_web.png")
	offset = offset + 37
	if (self.BtnPR) then
		self.BtnPR:SetSize(32,32)
		self.BtnPR:SetPos(offset,0)
		self.BtnPR:SetImage("mscoreboard/ms_profile.png")
		offset = offset + 37
	end
	if (self.BtnGoTo) then
		self.BtnGoTo:SetSize(32,32)
		self.BtnGoTo:SetPos(offset,0)
		self.BtnGoTo:SetImage("mscoreboard/ms_goto.png")
		offset = offset + 37
	end
	if (self.BtnTrainTP) then
		self.BtnTrainTP:SetSize(32,32)
		self.BtnTrainTP:SetPos(offset,0)
		self.BtnTrainTP:SetImage("mscoreboard/ms_traintp.png")
		offset = offset + 37
	end
end

function PlayerPanel:ApplySchemeSettings()
	return true
end

function PlayerPanel:SetPlayer(ply)
	self.Player = ply
end
vgui.Register("mplayerpanel",PlayerPanel,"Panel")