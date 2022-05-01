---------------------- Metrostroi Score Board ----------------------
-- Developer: Alexell
-- License: MIT
-- Website: https://alexell.ru/
-- Steam: https://steamcommunity.com/profiles/76561198210303223
-- Source code: https://github.com/Alexell/metrostroi_scoreboard_pro
--------------------------------------------------------------------
include("player_row.lua")

local function T(str,...)
	return string.format(Metrostroi.GetPhrase(str),...)
end
surface.CreateFont("mscoreboardtitle",{
	font = "verdana",
	size = 16,
	weight = 600
})
surface.CreateFont("mscoreboardmain",{
	font = "verdana",
	size = 16,
	weight = 100
})
local gradient = surface.GetTextureID("gui/center_gradient")

-- Цветовая схема
local ms_head_backcolor_r = CreateClientConVar("ms_head_backcolor_r","0",true,false)
local ms_head_backcolor_g = CreateClientConVar("ms_head_backcolor_g","0",true,false)
local ms_head_backcolor_b = CreateClientConVar("ms_head_backcolor_b","0",true,false)
local ms_head_backcolor_a = CreateClientConVar("ms_head_backcolor_a","180",true,false)
local ms_head_fontcolor_r = CreateClientConVar("ms_head_fontcolor_r","255",true,false)
local ms_head_fontcolor_g = CreateClientConVar("ms_head_fontcolor_g","255",true,false)
local ms_head_fontcolor_b = CreateClientConVar("ms_head_fontcolor_b","255",true,false)
local ms_center_backcolor_r = CreateClientConVar("ms_center_backcolor_r","0",true,false)
local ms_center_backcolor_g = CreateClientConVar("ms_center_backcolor_g","0",true,false)
local ms_center_backcolor_b = CreateClientConVar("ms_center_backcolor_b","0",true,false)
local ms_center_backcolor_a = CreateClientConVar("ms_center_backcolor_a","180",true,false)
local ms_center_fontcolor_r = CreateClientConVar("ms_center_fontcolor_r","255",true,false)
local ms_center_fontcolor_g = CreateClientConVar("ms_center_fontcolor_g","255",true,false)
local ms_center_fontcolor_b = CreateClientConVar("ms_center_fontcolor_b","255",true,false)
local ms_center_framecolor_r = CreateClientConVar("ms_center_framecolor_r","204",true,false)
local ms_center_framecolor_g = CreateClientConVar("ms_center_framecolor_g","204",true,false)
local ms_center_framecolor_b = CreateClientConVar("ms_center_framecolor_b","204",true,false)
local ms_center_framecolor_a = CreateClientConVar("ms_center_framecolor_a","100",true,false)
local ms_foot_backcolor_r = CreateClientConVar("ms_foot_backcolor_r","0",true,false)
local ms_foot_backcolor_g = CreateClientConVar("ms_foot_backcolor_g","0",true,false)
local ms_foot_backcolor_b = CreateClientConVar("ms_foot_backcolor_b","0",true,false)
local ms_foot_backcolor_a = CreateClientConVar("ms_foot_backcolor_a","180",true,false)
local ms_foot_fontcolor_r = CreateClientConVar("ms_foot_fontcolor_r","255",true,false)
local ms_foot_fontcolor_g = CreateClientConVar("ms_foot_fontcolor_g","255",true,false)
local ms_foot_fontcolor_b = CreateClientConVar("ms_foot_fontcolor_b","255",true,false)

-- Схема по умолчанию
function MScoreBoard.ResetColors()
	RunConsoleCommand("ms_head_backcolor_r","0")
	RunConsoleCommand("ms_head_backcolor_g","0")
	RunConsoleCommand("ms_head_backcolor_b","0")
	RunConsoleCommand("ms_head_backcolor_a","180")
	RunConsoleCommand("ms_head_fontcolor_r","255")
	RunConsoleCommand("ms_head_fontcolor_g","255")
	RunConsoleCommand("ms_head_fontcolor_b","255")
	RunConsoleCommand("ms_center_backcolor_r","0")
	RunConsoleCommand("ms_center_backcolor_g","0")
	RunConsoleCommand("ms_center_backcolor_b","0")
	RunConsoleCommand("ms_center_backcolor_a","180")
	RunConsoleCommand("ms_center_fontcolor_r","255")
	RunConsoleCommand("ms_center_fontcolor_g","255")
	RunConsoleCommand("ms_center_fontcolor_b","255")
	RunConsoleCommand("ms_center_framecolor_r","204")
	RunConsoleCommand("ms_center_framecolor_g","204")
	RunConsoleCommand("ms_center_framecolor_b","204")
	RunConsoleCommand("ms_center_framecolor_a","100")
	RunConsoleCommand("ms_foot_backcolor_r","0")
	RunConsoleCommand("ms_foot_backcolor_g","0")
	RunConsoleCommand("ms_foot_backcolor_b","0")
	RunConsoleCommand("ms_foot_backcolor_a","180")
	RunConsoleCommand("ms_foot_backcolor_a","180")
	RunConsoleCommand("ms_foot_fontcolor_r","255")
	RunConsoleCommand("ms_foot_fontcolor_g","255")
	RunConsoleCommand("ms_foot_fontcolor_b","255")
end
concommand.Add("mscoreboard_reset",MScoreBoard.ResetColors)

local function MSPanel(panel)
    panel:ClearControls()
    panel:SetPadding(0)
    panel:SetSpacing(0)
    panel:Dock(FILL)
	panel:ControlHelp("Metrostroi Scoreboard Pro (by Alexell)")
	
	panel:Help(T("MSCP.Header1"))
	local Header1 = vgui.Create("DColorMixer")
	Header1:SetConVarR("ms_head_backcolor_r")
	Header1:SetConVarG("ms_head_backcolor_g")
	Header1:SetConVarB("ms_head_backcolor_b")
	Header1:SetConVarA("ms_head_backcolor_a")
	panel:AddItem(Header1)
	
	panel:Help(T("MSCP.Header2"))
	local Header2 = vgui.Create("DColorMixer")
	Header2:SetConVarR("ms_head_fontcolor_r")
	Header2:SetConVarG("ms_head_fontcolor_g")
	Header2:SetConVarB("ms_head_fontcolor_b")
	Header2:SetAlphaBar(false)
	panel:AddItem(Header2)
	
	panel:Help(T("MSCP.Frame1"))
	local Frame1 = vgui.Create("DColorMixer")
	Frame1:SetConVarR("ms_center_backcolor_r")
	Frame1:SetConVarG("ms_center_backcolor_g")
	Frame1:SetConVarB("ms_center_backcolor_b")
	Frame1:SetConVarA("ms_center_backcolor_a")
	panel:AddItem(Frame1)
	
	panel:Help(T("MSCP.Frame2"))
	local Frame2 = vgui.Create("DColorMixer")
	Frame2:SetConVarR("ms_center_fontcolor_r")
	Frame2:SetConVarG("ms_center_fontcolor_g")
	Frame2:SetConVarB("ms_center_fontcolor_b")
	Frame2:SetAlphaBar(false)
	panel:AddItem(Frame2)

	panel:Help(T("MSCP.Frame3"))
	local Frame3 = vgui.Create("DColorMixer")
	Frame3:SetConVarR("ms_center_framecolor_r")
	Frame3:SetConVarG("ms_center_framecolor_g")
	Frame3:SetConVarB("ms_center_framecolor_b")
	Frame3:SetConVarA("ms_center_framecolor_a")
	panel:AddItem(Frame3)

	panel:Help(T("MSCP.Footer1"))
	local Footer1 = vgui.Create("DColorMixer")
	Footer1:SetConVarR("ms_foot_backcolor_r")
	Footer1:SetConVarG("ms_foot_backcolor_g")
	Footer1:SetConVarB("ms_foot_backcolor_b")
	Footer1:SetConVarA("ms_foot_backcolor_a")
	panel:AddItem(Footer1)
	
	panel:Help(T("MSCP.Footer2"))
	local Footer2 = vgui.Create("DColorMixer")
	Footer2:SetConVarR("ms_foot_fontcolor_r")
	Footer2:SetConVarG("ms_foot_fontcolor_g")
	Footer2:SetConVarB("ms_foot_fontcolor_b")
	Footer2:SetAlphaBar(false)
	panel:AddItem(Footer2)
	
	panel:Button(T("MSCP.Reset"),"mscoreboard_reset",true)
end

hook.Add("PopulateToolMenu", "MScoreBoardClientPanel", function()
    spawnmenu.AddToolMenuOption("Utilities","MScoreboard Pro","MSClientPanel",T("MSCP.Colors"),"","",MSPanel)
end)

-- поправки на разрешение экрана
local scrw = 1280 -- для мониторов шириной меньше 1600px
local scrh = ScrH() * 0.65

if ScrW() >= 1600 then
	scrw = ScrW() * 0.85
end
	
-- ОСНОВНАЯ ПАНЕЛЬ --
local Board = {}

function Board:Init()
	self.Server = vgui.Create("DLabel",self)
	self.CLTime = vgui.Create("DLabel",self)
	self.SVTime = vgui.Create("DLabel",self)
	self.Info = vgui.Create("DLabel",self)
	
	self.Nick = vgui.Create("DLabel",self)
	self.Group = vgui.Create("DLabel",self)
	self.Route = vgui.Create("DLabel",self)
	self.Wagons = vgui.Create("DLabel",self)
	self.Train = vgui.Create("DLabel",self)
	self.Station = vgui.Create("DLabel",self)

	if ScrW() >= 1600 then
		self.Hours = vgui.Create("DLabel",self)
		self.Ping = vgui.Create("DLabel",self)
	end
	
	self.Pass = vgui.Create("DLabel",self)
	self.MuteAll = false
	self.MuteAllIcon = vgui.Create("DImageButton",self)
	
	self.PlayerRows = {}
	self.Frame = vgui.Create("mplayersframe",self)
end

function Board:Paint(w,h)
	local headcolor = Color(ms_head_backcolor_r:GetInt(),ms_head_backcolor_g:GetInt(),ms_head_backcolor_b:GetInt(),ms_head_backcolor_a:GetInt())
	
	-- блок для названия сервера
	draw.RoundedBox(10,10,10,self:GetWide() - 20, 50 ,headcolor)
	
	-- блок для информации шапки
	draw.RoundedBox(5,10,65,self:GetWide() - 20, 30,headcolor)
	
	-- блок для игроков
	local centercolor = Color(ms_center_backcolor_r:GetInt(),ms_center_backcolor_g:GetInt(),ms_center_backcolor_b:GetInt(),ms_center_backcolor_a:GetInt())
	draw.RoundedBox(5,10,100,self:GetWide() - 20, self:GetTall() - 135,centercolor)
	
	self.Server:SetText(GetHostName())
	self.CLTime:SetText(T("MScoreBoard.CLTime")..": "..os.date("%H:%M:%S",os.time()))
	self.SVTime:SetText(T("MScoreBoard.SVTime")..": "..os.date("!%H:%M:%S",Metrostroi.GetSyncTime()))
	
	self.Nick:SetText(T("MScoreBoard.Nick"))
	self.Group:SetText(T("MScoreBoard.Rank"))
	self.Route:SetText(T("MScoreBoard.Route"))
	self.Wagons:SetText(T("MScoreBoard.Wagons"))
	self.Train:SetText(T("MScoreBoard.Train"))
	self.Station:SetText(T("MScoreBoard.Station"))
	
	if ScrW() >= 1600 then
		self.Hours:SetText(T("MScoreBoard.Hours"))
		self.Ping:SetText(T("MScoreBoard.Ping"))
	end

	-- блок для информации подвала
	local footcolor = Color(ms_foot_backcolor_r:GetInt(),ms_foot_backcolor_g:GetInt(),ms_foot_backcolor_b:GetInt(),ms_foot_backcolor_a:GetInt())
	draw.RoundedBox(5,10,self:GetTall()-30,self:GetWide() - 20, 30,footcolor)
end

function Board:PerformLayout()
	self:SetSize(scrw,scrh)
	self:SetPos((ScrW() - self:GetWide()) / 2, (ScrH() - self:GetTall()) / 2)
	
	-- лейблы шапки
	self.Server:SizeToContents()
	self.Server:SetPos((self:GetWide() / 2) - (self.Server:GetWide() / 2), 20)
	
	self.CLTime:SizeToContents()
	self.CLTime:SetPos(20, 68)
	
	self.SVTime:SizeToContents()
	self.SVTime:SetPos(self:GetWide() - self.SVTime:GetWide() - 20, 68)
	
	self.Info:SizeToContents()
	self.Info:SetPos((self:GetWide() / 2) - (self.Info:GetWide() / 2), 68)
	
	-- лейблы заголовка
	self.Nick:SizeToContents()
	self.Group:SizeToContents()
	self.Route:SizeToContents()
	self.Wagons:SizeToContents()
	self.Train:SizeToContents()
	self.Station:SizeToContents()

	self.Frame:SetPos(17,120)
	self.Frame:SetSize(self:GetWide() - 34, self:GetTall() - 163)
	
	if ScrW() >= 1600 then
		self.Hours:SizeToContents()
		self.Ping:SizeToContents()
	end

	self.Nick:SetPos(63, 102)

	if ScrW() >= 1600 then
		self.Ping:SetPos(self.Frame:GetWide()-60-2, 102)
		self.Hours:SetPos(self.Frame:GetWide()-105, 102)
		self.Station:SetPos(self.Frame:GetWide()-500-2, 102)
		self.Train:SetPos(self.Frame:GetWide()-735-2, 102)
		self.Wagons:SetPos(self.Frame:GetWide()-810-2, 102)
		self.Route:SetPos(self.Frame:GetWide()-900-1, 102)
		self.Group:SetPos(self.Frame:GetWide()-1100-2, 102)
	else
		self.Station:SetPos(self.Frame:GetWide()-350, 102)
		self.Train:SetPos(self.Frame:GetWide()-525, 102)
		self.Wagons:SetPos(self.Frame:GetWide()-585, 102)
		self.Route:SetPos(self.Frame:GetWide()-655, 102)
		self.Group:SetPos(self.Frame:GetWide()-900, 102)
	end
	
	if ScrW() == 1920 then
		self.Group:SetPos(self.Frame:GetWide()-1150,102)
	end
	
	-- лейблы подвала
	self.Pass:SizeToContents()
	self.Pass:SetPos(20, self:GetTall()-27)
	self.MuteAllIcon:SetSize(32,32)
	self.MuteAllIcon:SetPos(self:GetWide()-self.MuteAllIcon:GetWide()-10, self:GetTall()-31)
end

function Board:ApplySchemeSettings()
	-- шрифты
	self.Server:SetFont("ScoreboardDefaultTitle")
	self.CLTime:SetFont("ScoreboardDefault")
	self.SVTime:SetFont("ScoreboardDefault")
	self.Info:SetFont("ScoreboardDefault")
	
	self.Nick:SetFont("mscoreboardtitle")
	self.Group:SetFont("mscoreboardtitle")
	self.Route:SetFont("mscoreboardtitle")
	self.Wagons:SetFont("mscoreboardtitle")
	self.Train:SetFont("mscoreboardtitle")
	self.Station:SetFont("mscoreboardtitle")
	
	if ScrW() >= 1600 then
		self.Hours:SetFont("mscoreboardtitle")
		self.Ping:SetFont("mscoreboardtitle")
	end
	
	self.Pass:SetFont("ScoreboardDefault")
end

function Board:AddPlayerRow(ply)
	local row = vgui.Create("mplayerrow",self.Frame)
	row:SetPlayer(ply)
	row:SetCursor("user")
	
	self.Frame.ScrollPanel:AddItem(row)
	row:Dock(TOP)
	row:DockMargin(3,3,3,0)
	self.PlayerRows[ply] = row
end

function Board:GetPlayerRow(ply)
	return self.PlayerRows[ply]
end

function Board:MuteAllPlayers(val)
	for _,ply in pairs(player.GetAll()) do
		ply:SetMuted(val)
	end
end

function Board:Update()
	if not self or not self:IsVisible() then return end
	
	local PlayerList = player.GetAll()
	table.sort(PlayerList,function(a,b)
		if a:Team() == TEAM_CONNECTING then return false end
		if b:Team() == TEAM_CONNECTING then return true end
		if a:Team() ~= b:Team() then
			return a:Team() < b:Team()
		end
	end)
	
	local muted = 0
	for _,ply in pairs(PlayerList) do
		if not self:GetPlayerRow(ply) then
			self:AddPlayerRow(ply)
		end
		if ply:IsMuted() then muted = muted + 1 end
	end

	local headtextcolor = Color(ms_head_fontcolor_r:GetInt(),ms_head_fontcolor_g:GetInt(),ms_head_fontcolor_b:GetInt(),255)
	self.Server:SetTextColor(headtextcolor)
	self.CLTime:SetTextColor(headtextcolor)
	self.SVTime:SetTextColor(headtextcolor)
	self.Info:SetTextColor(headtextcolor)
	
	local centertextcolor = Color(ms_center_fontcolor_r:GetInt(),ms_center_fontcolor_g:GetInt(),ms_center_fontcolor_b:GetInt(),255)
	self.Nick:SetTextColor(centertextcolor)
	self.Group:SetTextColor(centertextcolor)
	self.Route:SetTextColor(centertextcolor)
	self.Wagons:SetTextColor(centertextcolor)
	self.Train:SetTextColor(centertextcolor)
	self.Station:SetTextColor(centertextcolor)
	
	local foottextcolor = Color(ms_foot_fontcolor_r:GetInt(),ms_foot_fontcolor_g:GetInt(),ms_foot_fontcolor_b:GetInt(),255)
	self.Pass:SetTextColor(foottextcolor)
	
	if ScrW() >= 1600 then
		self.Hours:SetTextColor(centertextcolor)
		self.Ping:SetTextColor(centertextcolor)
	end

	self.Info:SetText(T("MScoreBoard.Players")..": "..#PlayerList.." | "..T("MScoreBoard.Wagons")..": "..GetGlobalInt("metrostroi_train_count",0))
	self.Pass:SetText(T("MScoreBoard.TransPass",LocalPlayer():Frags()))
	if (muted < #PlayerList) then
		self.MuteAllIcon:SetImage("icon32/unmuted.png")
		self.MuteAll = false
	else
		self.MuteAllIcon:SetImage("icon32/muted.png")
		self.MuteAll = true
	end
	self.MuteAllIcon.DoClick = function() Board:MuteAllPlayers(not self.MuteAll) end
	self:InvalidateLayout()
end
vgui.Register("MetrostroiScoreBoard",Board,"Panel")
timer.Create("MScoreBoardThink",0.6,0,function()
	if MScoreBoard.Panel then
		MScoreBoard.Panel:Update()
	end
end)

-- ФРЕЙМ ИГРОКОВ --
local Frame = {}

function Frame:Init()
	self.ScrollPanel = vgui.Create("DScrollPanel",self)
end

function Frame:Paint(w,h)
	-- светлый блок
	local framecolor = Color(ms_center_framecolor_r:GetInt(),ms_center_framecolor_g:GetInt(),ms_center_framecolor_b:GetInt(),ms_center_framecolor_a:GetInt())
	draw.RoundedBox(5,0,0,w,h,framecolor)
	
	-- градиент поверх
	surface.SetTexture(gradient)
	surface.SetDrawColor(255,255,255,100)
	surface.DrawTexturedRect(0,0,w,h)
end

function Frame:PerformLayout()
	self:SetSize(self:GetParent():GetWide()-35,self:GetParent():GetTall()-163)
	self.ScrollPanel:Dock(FILL)
	local ScrollBar = self.ScrollPanel:GetVBar()
	ScrollBar:SetSize(0,0)
end
vgui.Register("mplayersframe",Frame,"Panel")

-- Глобальные функции
function MScoreBoard:Show()
	if MScoreBoard.Panel then
		MScoreBoard.Panel:Remove()
		MScoreBoard.Panel = nil
	end
	MScoreBoard.Panel = vgui.Create("MetrostroiScoreBoard")
	MScoreBoard.Panel:Update()
	gui.EnableScreenClicker(true)

	function MScoreBoard:Hide()
		for _,v in pairs(MScoreBoard.Panel.PlayerRows) do	-- принудительно удаляем VolumeFrame
			if v.VolumeFrame then v.VolumeFrame:Remove() end
		end
		MScoreBoard.Panel:Remove()
		MScoreBoard.Panel = nil
		gui.EnableScreenClicker(false)
	end
end

net.Receive("MScoreBoard.EqualRoutes",function(len,ply)
	local nick1 = net.ReadString()
	local nick2 = net.ReadString()
	chat.AddText(Color(222, 0, 0),T("MScoreBoard.Players2").." "..nick1.." "..T("MScoreBoard.And").." "..nick2.." "..T("MScoreBoard.EqualRoute").."!")
	chat.AddText(Color(222, 0, 0),T("MScoreBoard.ChangeRoute")..".")
end)
