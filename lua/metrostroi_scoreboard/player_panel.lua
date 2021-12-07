---------------------- Metrostroi Score Board ----------------------
-- Developer: Alexell
-- License: MIT
-- Website: https://alexell.ru/
-- Steam: https://steamcommunity.com/profiles/76561198210303223
-- Source code: https://github.com/Alexell/metrostroi_scoreboard_pro
--------------------------------------------------------------------
local function T(str,...)
	return string.format(Metrostroi.GetPhrase(str),...)
end

local function PlayerPermission(ply,permission)
	if ULib then
		return ULib.ucl.query(ply,permission)
	else
		return ply:IsAdmin()
	end
end

local AdminBtn = {}
function AdminBtn:DoClick()
	if not self:GetParent().Player then return end
	timer.Simple(0.1, MScoreBoard.Panel:Update())
end
function AdminBtn:Paint(w,h)
	local color = Color(127,127,127,70) -- должен быть одинаковый c фоном иконок
	draw.RoundedBox(4,0,0,self:GetWide(),self:GetTall(),color)	
	draw.SimpleText(self.Text,"mscoreboardmain",self:GetWide()/2,self:GetTall()/2, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	return true
end
vgui.Register("msadminbtn",AdminBtn,"Button")

local PlayerPanel = {}
function PlayerPanel:Init()
	if (MScoreBoard.Website ~= "0") then
		self.BtnWeb = vgui.Create("DImageButton",self)
		self.BtnWeb.DoClick = function() gui.OpenURL(MScoreBoard.Website..self.Player:SteamID()) end
	end
	if (PlayerPermission(LocalPlayer(),"ulx prid")) then
		self.BtnPR = vgui.Create("DImageButton",self)
		self.BtnPR.DoClick = function() RunConsoleCommand("ulx","prid",self.Player:SteamID()) end
	end
	if (PlayerPermission(LocalPlayer(),"ulx goto")) then
		self.BtnGoTo = vgui.Create("DImageButton",self)
		self.BtnGoTo.DoClick = function() RunConsoleCommand("ulx","goto",self.Player:Nick()) end
	end
	if (MetrostroiAdvanced and PlayerPermission(LocalPlayer(),"ulx traintp")) then
		self.BtnTrainTP = vgui.Create("DImageButton",self)
		self.BtnTrainTP.DoClick = function() RunConsoleCommand("ulx","traintp",self.Player:Nick()) end
	end

	if (PlayerPermission(LocalPlayer(),"ulx ban")) then
		self.BtnBan = vgui.Create("msadminbtn",self)
		self.BtnBan.Text = T("MScoreBoard.Ban")
		self.BtnBan.DoClick = function() xgui.ShowBanWindow(self.Player,self.Player:SteamID(),false) end
	end
	if (PlayerPermission(LocalPlayer(),"ulx kick")) then
		self.BtnKick = vgui.Create("msadminbtn",self)
		self.BtnKick.Text = T("MScoreBoard.Kick")
		self.BtnKick.DoClick = function() RunConsoleCommand("ulx","kick",self.Player:Nick(),T("MScoreBoard.Kicked")) end
	end
end

function PlayerPanel:Paint(w,h)
	return true
end

function PlayerPanel:PerformLayout()
	-- левая сторона
	local offsetL = 0
	if (self.BtnWeb) then
	self.BtnWeb:SetSize(32,32)
	self.BtnWeb:SetPos(0,0)
	self.BtnWeb:SetImage("mscoreboard/ms_profile_web.png")
	offsetL = offsetL + self.BtnWeb:GetWide() + 5
	end
	if (self.BtnPR) then
		self.BtnPR:SetSize(32,32)
		self.BtnPR:SetPos(offsetL,0)
		self.BtnPR:SetImage("mscoreboard/ms_profile.png")
		offsetL = offsetL + self.BtnPR:GetWide() + 5
	end
	if (self.BtnGoTo) then
		if (self.Player ~= LocalPlayer()) then
			self.BtnGoTo:SetSize(32,32)
			self.BtnGoTo:SetPos(offsetL,0)
			self.BtnGoTo:SetImage("mscoreboard/ms_goto.png")
			offsetL = offsetL + self.BtnGoTo:GetWide() + 5
		else
			self.BtnGoTo:SetVisible(false)
		end
	end
	if (self.BtnTrainTP) then
		if (self.Player:GetNW2String("MSTrainClass","-") ~= "-") then
			self.BtnTrainTP:SetSize(32,32)
			self.BtnTrainTP:SetPos(offsetL,0)
			self.BtnTrainTP:SetImage("mscoreboard/ms_traintp.png")
			offsetL = offsetL + self.BtnTrainTP:GetWide() + 5
		else
			self.BtnTrainTP:SetVisible(false)
		end
	end
	
	-- правая сторона
	local offsetR = 50
	if (self.BtnBan) then
		if (self.Player ~= LocalPlayer()) then
			self.BtnBan:SetSize(50,20)
			self.BtnBan:SetPos(self:GetWide()-offsetR,7)
			offsetR = offsetR + self.BtnBan:GetWide() + 5
		else
			self.BtnBan:SetVisible(false)
		end
	end
	if (self.BtnKick) then
		if (self.Player ~= LocalPlayer()) then
			self.BtnKick:SetSize(50,20)
			self.BtnKick:SetPos(self:GetWide()-offsetR,7)
			offsetR = offsetR + self.BtnKick:GetWide() + 5
		else
			self.BtnKick:SetVisible(false)
		end
	end
end

function PlayerPanel:ApplySchemeSettings()
	return true
end

function PlayerPanel:SetPlayer(ply)
	self.Player = ply
end
vgui.Register("mplayerpanel",PlayerPanel,"Panel")