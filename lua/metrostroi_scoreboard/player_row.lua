---------------------- Metrostroi Score Board ----------------------
-- Developer: Alexell
-- License: MIT
-- Website: https://alexell.ru/
-- Steam: https://steamcommunity.com/profiles/76561198210303223
-- Source code: https://github.com/Alexell/metrostroi_scoreboard_pro
--------------------------------------------------------------------
include("player_panel.lua")

local gradient = surface.GetTextureID("gui/center_gradient")
local offset = 14 -- смещение от заголовка
local PlayerRow = {}

local function T(str,...)
	return string.format(Metrostroi.GetPhrase(str),...)
end

local function GetTrainName(class)
	local result = "-"
	if class ~= "-" then
		local train_name = T("Entities."..class..".Name")
		local s1,s2 = string.find(train_name," головной") or string.find(train_name," head")
		if s1 then
			result = string.sub(train_name,1,s1-1)..")"
		else
			result = train_name
		end
	end
	return result
end

local function FixedRoute(class,route)
	local result = "-"
	if (class ~= "-" and route ~= "-") then
		local rnum = tonumber(route)
		if table.HasValue({"gmod_subway_81-702","gmod_subway_81-703","gmod_subway_ezh","gmod_subway_ezh3","gmod_subway_ezh3ru1","gmod_subway_81-717_mvm","gmod_subway_81-718","gmod_subway_81-720","gmod_subway_81-720_1","gmod_subway_81-717_freight"},class) then rnum = rnum / 10 end
		result = rnum
	end
	return result
end

function PlayerRow:Init()
	self.Height = 38
	self.NeedHeight = 38
	self.Extended = false
	self.AvatarBTN = vgui.Create("DButton",self)
	self.AvatarBTN.DoClick = function() self.Player:ShowProfile() end
	self.AvatarIMG = vgui.Create("AvatarImage",self.AvatarBTN)
	self.AvatarIMG:SetMouseInputEnabled(false)
	
	self.Nick = vgui.Create("DLabel",self)
	self.Nick:SetCursor("hand")
	self.Nick:SetMouseInputEnabled(true)
	self.Nick.DoClick = function() self:OpenPanel(not self.Extended) end
	self.Team = vgui.Create("DLabel",self)
	self.Route = vgui.Create("DLabel",self)
	self.Wags = vgui.Create("DLabel",self)
	self.Train = vgui.Create("DLabel",self)
	self.Station = vgui.Create("DLabel",self)
	if ScrW() >= 1600 then
		self.Hours = vgui.Create("DLabel",self)
		self.Ping = vgui.Create("DLabel",self)
	end
	self.MuteIcon = vgui.Create("DImageButton",self)
	self.PlayerPanel = vgui.Create("mplayerpanel",self)
end

function PlayerRow:Paint(w,h)
	if not IsValid(self.Player) then
		self:Remove()
		MScoreBoard.Panel:InvalidateLayout()
		return
	end
	local color = Color(100,100,100,255)
	if IsValid(self.Player) then
		color = team.GetColor(self.Player:Team())
	end
	
	if self.Extended or self.Height ~= self.NeedHeight then
		draw.RoundedBox(4,2,16,self:GetWide()-4,self:GetTall()-16,color)
		draw.RoundedBox(4,4,16,self:GetWide()-8,self:GetTall()-18,Color(225,225,225,150))

		surface.SetTexture(gradient)
		surface.SetDrawColor(255,255,255,100)
		surface.DrawTexturedRect(20,16,self:GetWide()-40,self:GetTall()-18)
	end
	
	draw.RoundedBox(4,0,0,self:GetWide(),38,color)
	surface.SetTexture(gradient)
	surface.SetDrawColor(255,255,255,150)
	surface.DrawTexturedRect(0,0,self:GetWide(),38)
end

function PlayerRow:PerformLayout()
	self:SetSize(self:GetWide(),self.Height)
	self.MuteIcon:SetSize(32,32)
	self.MuteIcon:SetPos(self:GetWide()-self.MuteIcon:GetWide(),3)

	self.AvatarBTN:SetPos(3,3)
	self.AvatarBTN:SetSize(32,32)
 	self.AvatarIMG:SetSize(32,32)
	self.Station:SizeToContents()
	self.Train:SizeToContents()
	self.Wags:SizeToContents()
	self.Route:SizeToContents()
	self.Team:SizeToContents()
	self.Nick:SetPos(40,11)
	self.Nick:SizeToContents()

	if ScrW() >= 1600 then
		self.Ping:SetPos(self:GetWide()-offset-55,11)
		self.Ping:SizeToContents()
		self.Hours:SetPos(self:GetWide()-offset-105,11)
		self.Hours:SizeToContents()
		
		self.Station:SetPos(self:GetWide()-offset-500,11)
		self.Station:SetWide(385)
		self.Train:SetPos(self:GetWide()-offset-675,11)
		self.Wags:SetPos(self:GetWide()-offset-735,11)
		self.Route:SetPos(self:GetWide()-offset-805,11)
		self.Team:SetPos(self:GetWide()-offset-1050,11)
		self.Team:SetWide(245)
		self.Nick:SetWide(210)
	else
		self.Station:SetPos(self:GetWide()-offset-350,11)
		self.Station:SetWide(340)
		self.Train:SetPos(self:GetWide()-offset-525,11)
		self.Wags:SetPos(self:GetWide()-offset-585,11)
		self.Route:SetPos(self:GetWide()-offset-655,11)
		self.Team:SetPos(self:GetWide()-offset-900,11)
		self.Team:SetWide(245)
		self.Nick:SetWide(280)
	end
	if ScrW() == 1920 then
		self.Nick:SetWide(380)
		self.Team:SetPos(self:GetWide()-offset-1150,11)
		self.Team:SetWide(340)
	end
	
	if self.Extended or self.Height ~= self.NeedHeight then
		self.PlayerPanel:SetVisible(true)
		self.PlayerPanel:SetPos(18,self.Nick:GetTall()+27)
		self.PlayerPanel:SetSize(self:GetWide()-36, self:GetTall()-self.Nick:GetTall()+ 5)
	else
		self.PlayerPanel:SetVisible(false)
	end
end

function PlayerRow:ApplySchemeSettings()
	-- шрифты
	self.Nick:SetFont("mscoreboardmain")
	self.Team:SetFont("mscoreboardmain")
	self.Route:SetFont("mscoreboardmain")
	self.Wags:SetFont("mscoreboardmain")
	self.Train:SetFont("mscoreboardmain")
	self.Station:SetFont("mscoreboardmain")
	
	if ScrW() >= 1600 then
		self.Hours:SetFont("mscoreboardmain")
		self.Ping:SetFont("mscoreboardmain")
	end
	
	-- цвета
	self.Nick:SetTextColor(Color(0,0,0,255))
	self.Team:SetTextColor(Color(0,0,0,255))

	self.Route:SetTextColor(Color(0,0,0,255))
	self.Wags:SetTextColor(Color(0,0,0,255))
	self.Train:SetTextColor(Color(0,0,0,255))
	self.Station:SetTextColor(Color(0,0,0,255))
	
	if ScrW() >= 1600 then
		self.Hours:SetTextColor(Color(0,0,0,255))
		self.Ping:SetTextColor(Color(0,0,0,255))
	end
end

function PlayerRow:OpenPanel(val)
	if val then
		self.NeedHeight = 82
	else
		self.NeedHeight = 38
	end
	self.Extended = val
end

function PlayerRow:UpdatePlayerData()
	local ply = self.Player
	if not IsValid(ply) then MScoreBoard.Panel:InvalidateLayout() return end
	self.Nick:SetText(ply:Nick())
	self.Team:SetText(team.GetName(ply:Team()))
	self.Route:SetText(FixedRoute(ply:GetNW2String("MSTrainClass","-"),ply:GetNW2String("MSRoute","-")))
	self.Wags:SetText(ply:GetNW2String("MSWagons","-"))
	self.Train:SetText(GetTrainName(ply:GetNW2String("MSTrainClass","-")))
	self.Station:SetText(string.format(ply:GetNW2String("MSStation","-"),T("MScoreBoard.Line")))

	if ScrW() >= 1600 then
		self.Hours:SetText(math.floor(ply:GetUTimeTotalTime()/3600))
		self.Ping:SetText(ply:Ping())
	end
	
	if (ply:GetNW2Bool("MSPlayerDriving")) then
		self.Train:SetTextColor(Color(0,0,0,255))
	else
		if ply:GetNW2String("MSTrainClass","-") == "-" then
			self.Train:SetTextColor(Color(0,0,0,255))
		else
			self.Train:SetTextColor(Color(128,128,128))
		end
	end
	
	if self.Muted == nil or self.Muted ~= self.Player:IsMuted() then
		self.Muted = self.Player:IsMuted()
		if self.Muted then
			self.MuteIcon:SetImage("icon32/muted.png")
		else
			self.MuteIcon:SetImage("icon32/unmuted.png")
		end
		self.MuteIcon.DoClick = function() self.Player:SetMuted(not self.Muted) end
	end
end

function PlayerRow:SetPlayer(ply)
	self.Player = ply
	self:UpdatePlayerData()
	self.AvatarIMG:SetPlayer(ply)
	self.PlayerPanel:SetPlayer(ply)
end

function PlayerRow:Think()
	if self.Height ~= self.NeedHeight then
		self.Height = math.Approach(self.Height,self.NeedHeight,(math.abs(self.Height-self.NeedHeight)+1)*10*FrameTime())
		self:PerformLayout()
		MScoreBoard.Panel:InvalidateLayout()
	end
	if not self.PlayerUpdate or self.PlayerUpdate < CurTime() then
		self.PlayerUpdate = CurTime() + 1
		self:UpdatePlayerData()
	end
end
vgui.Register("mplayerrow",PlayerRow,"DPanel")
