class 'VTOL'

function VTOL:__init()
	VTOLActive			=	true	--	Whether or not VTOL is active by default.			Default: true
	AutoLandActive		=	true	--	Whether or not Auto Land is active by default.		Default: true
	ReverseThrustActive	=	true	--	Whether or not Reverse Thrust is active by default.	Default: true
	VTOLKey				=	90		--	The key to activate VTOL, this is Z by default.									Default: 90
	VTOLLandKey			=	162		--	The key to switch VTOL to down instead of up, this is Left Control by default.	Default: 162
	ReverseKey			=	88		--	The key to activate Reverse Thrust, this is X by default.						Default: 88
	NoseKey				=	87		--	The key to pitch the nose, this is W by default.								Default: 87
	TailKey				=	83		--	The key to pitch the tail, this is S by default.								Default: 83
	PlaneVehicles		=	{24, 30, 34, 39, 51, 59, 81, 85}	--	A list of all vehicle IDs of planes.
	PitchSpeedLimit		=	25		--	The max speed in MPS that forced pitching of the nose/tail is allowed. 			Default: 25
	
	--	Info Text Config	--
	DisplayPosX			=	0.5		--	The Horizontal Position of the info text.	Default: 0.95
	DisplayPosY			=	0.95	--	The Vertical Position of the info text.		Default: 0.95
	TextFontSize		=	14		--	The font size of the info text.				Default: 14
	
	--	Thrust Config	--
	MaxThrust				=	10		--	The maximum thrust speed.						Default: 10
	MinThrust				=	0.1		--	The minimum thrust speed.						Default: 0.1
	CurrentThrust			=	0		--	The starting thrust speed.						Default: 0
	MaxVTOLLandThrust		=	10		--	The maximum VTOL down thrust speed.				Default: 10
	MinVTOLLandThrust		=	0.001	--	The minimum VTOL down thrust speed.				Default: 0.001
	VTOLLandThrust			=	2		--	The starting VTOL down thrust speed.			Default: 2
	MaxReverseThrust		=	1.5		--	The maximum speed a plane can go in reverse.	Default: 1.5
	ThrustIncreaseFactor	=	1.05	--	How quickly thrust is increased.				Default: 1.05
	ThrustDecreaseFactor	=	0.9		--	How quickly thrust is decreased.				Default: 0.9
	VTOLLandThrustFactor	=	0.95	--	how quickly speed is slowed when going into a VTOL Land.	Default: 
	ThrustDecreaseInteger	=	1		--	How quickly, in seconds, the system checks to see if thrust should decrease.	Default: 1
	ThrustDecreaseTimer		=	Timer()
	
	self.Version		=	"2.0"	--	Which version of VTOL this script is. DO NOT CHANGE.
	
	print(tostring(self) .. " " .. tostring(self.Version) .. " loaded.")
	
	Events:Subscribe("LocalPlayerEnterVehicle", self, self.LocalPlayerEnterVehicle)
	Events:Subscribe("LocalPlayerChat", self, self.LocalPlayerChat)
	Events:Subscribe("MouseScroll", self, self.MouseScroll)
	Events:Subscribe("InputPoll", self, self.LandingGear)
	Events:Subscribe("PostTick", self, self.PostTick)
	Events:Subscribe("Render", self, self.Render)
	Events:Subscribe("PreTick", self, self.Thrust)
end

function VTOL:MouseScroll(args)
	if args.delta == 1 then
		VTOLLandThrust	=	VTOLLandThrust * 1.1
	elseif args.delta == -1 then
		VTOLLandThrust	=	VTOLLandThrust * 0.9
	end
	if VTOLLandThrust < MinVTOLLandThrust then
		VTOLLandThrust	=	MinVTOLLandThrust
	elseif VTOLLandThrust > MaxVTOLLandThrust then
		VTOLLandThrust	=	MaxVTOLLandThrust
	end
end

function VTOL:LocalPlayerChat(args)
	local msg	=	string.split(args.text, " ")	--	Split at Spaces.
    if	string.lower(msg[1]) == "/vtol" then
			if VTOLActive then
				VTOLActive = false
				Chat:Print("VTOL Disabled.", Color.Red)
			else
				VTOLActive = true
				Chat:Print("VTOL Enabled.", Color.Green)
			end
	elseif string.lower(msg[1]) == "/autoland" then
		if AutoLandActive then
			AutoLandActive = false
			Chat:Print("AutoLand Disabled.", Color.Red)
		else
			AutoLandActive = true
			Chat:Print("AutoLand Enabled.", Color.Green)
		end
	elseif string.lower(msg[1]) == "/reversethrust" then
		if ReverseThrustActive then
			ReverseThrustActive = false
			Chat:Print("Reverse Thrust Disabled.", Color.Red)
		else
			ReverseThrustActive = true
			Chat:Print("Reverse Thrust Enabled.", Color.Green)
		end
	end
end

function VTOL:LandingGear()
	LocalVehicle	=	LocalPlayer:GetVehicle()
	if not LocalVehicle then return end
	if LocalVehicle:GetDriver() ~= LocalPlayer then return end
	LocalVehicleModel	=	LocalVehicle:GetModelId()
	if self:CheckList(PlaneVehicles, LocalVehicleModel) then
		local VehiclePosition	=	LocalVehicle:GetPosition()
		local VehicleAngle		=	LocalVehicle:GetAngle()
		local Direction			=	VehicleAngle * Vector3(0, -1, 0)
		local Altitude			=	VehiclePosition.y - 200
		local RayResult			=	Physics:Raycast(VehiclePosition, Direction, 0, Altitude)
		local Distance			=	RayResult.distance
		if Key:IsDown(VTOLKey) then
			if Game:GetState() == GUIState.Game then
				Input:SetValue(Action.PlaneDecTrust, 1)
			end
		elseif Distance <= 35 and AutoLandActive then
			if Game:GetState() == GUIState.Game then
				Input:SetValue(Action.PlaneDecTrust, 1)
			end
		end
	end
end

function VTOL:LocalPlayerEnterVehicle()
	CurrentThrust	=	0
	VTOLLandThrust	=	1
end

function VTOL:Render()
	if Game:GetState() ~= GUIState.Game then return end
	local ScreenSize			=	Render.Size
	LocalVehicle	=	LocalPlayer:GetVehicle()
	if not LocalVehicle then return end
	if LocalVehicle:GetDriver() ~= LocalPlayer then return end
	LocalVehicleModel	=	LocalVehicle:GetModelId()
	if self:CheckList(PlaneVehicles, LocalVehicleModel) then
	--	if CurrentThrust > MinThrust then
	--		self:DrawTextOnScreen(Vector2(ScreenSize.x/2, ScreenSize.y*.9), CurrentThrust .. " Thrust", Color.Green, 15, anchored)
	--	end
		local Offset = 0
		if VTOLActive then
			self:DrawTextOnScreen(Vector2(ScreenSize.x * DisplayPosX, ScreenSize.y * DisplayPosY + Offset), "Z for Vertical Take-Off", Color.White, TextFontSize)
			Offset	=	Offset + TextFontSize
			self:DrawTextOnScreen(Vector2(ScreenSize.x * DisplayPosX, ScreenSize.y * DisplayPosY + Offset), "Ctrl + Z for Vertical Landing", Color.White, TextFontSize)
			Offset	=	Offset + TextFontSize
		end
		if ReverseThrustActive then
			self:DrawTextOnScreen(Vector2(ScreenSize.x * DisplayPosX, ScreenSize.y * DisplayPosY + Offset), "X for Reverse Thrust", Color.White, TextFontSize)
		end
	end
end

function VTOL:CheckThrust()
	if Key:IsDown(VTOLLandKey) then return end
	CurrentThrust	=	CurrentThrust * ThrustIncreaseFactor
	if CurrentThrust < MinThrust then
		CurrentThrust	=	MinThrust
	elseif CurrentThrust > MaxThrust then
		CurrentThrust	=	MaxThrust
	end
	ReverseThrust	=	CurrentThrust
	if ReverseThrust > MaxReverseThrust then
		ReverseThrust = MaxReverseThrust
	end
end

function VTOL:Thrust(args)
	if Game:GetState() ~= GUIState.Game then return end
	LocalVehicle	=	LocalPlayer:GetVehicle()
	if not LocalVehicle then return end
	if LocalVehicle:GetDriver() ~= LocalPlayer then return end
	LocalVehicleModel	=	LocalVehicle:GetModelId()
	if self:CheckList(PlaneVehicles, LocalVehicleModel) then
		local VehicleVelocity	=	LocalVehicle:GetLinearVelocity()
		if IsValid(LocalVehicle) then
			if Key:IsDown(VTOLKey) and VTOLActive then
				self:CheckThrust()
				local SetThrust			=	Vector3(VehicleVelocity.x, CurrentThrust, VehicleVelocity.z)
				if Key:IsDown(VTOLLandKey) then
					SetThrust			=	Vector3(VehicleVelocity.x * VTOLLandThrustFactor, -VTOLLandThrust, VehicleVelocity.z * VTOLLandThrustFactor)
				end
				local SendInfo	=	{}
					SendInfo.Player		=	LocalPlayer
					SendInfo.Vehicle	=	LocalVehicle
					SendInfo.Thrust		=	SetThrust
				Network:Send("ActivateThrust", SendInfo)
			end
			if Key:IsDown(ReverseKey) and ReverseThrustActive then
				self:CheckThrust()
				local VehicleAngle		=	LocalVehicle:GetAngle()
				local SetThrust			=	VehicleVelocity + VehicleAngle * Vector3(0, 0, ReverseThrust)
				local SendInfo	=	{}
					SendInfo.Player		=	LocalPlayer
					SendInfo.Vehicle	=	LocalVehicle
					SendInfo.Thrust		=	SetThrust
				Network:Send("ActivateThrust", SendInfo)
			end
			if VehicleVelocity:Length() <= PitchSpeedLimit then
				if Key:IsDown(NoseKey) then
					local VehicleAngle		=	LocalVehicle:GetAngle()
					local SetThrust			=	VehicleAngle * Vector3(-0.25, 0, 0)
					local SendInfo	=	{}
						SendInfo.Player		=	LocalPlayer
						SendInfo.Vehicle	=	LocalVehicle
						SendInfo.Thrust		=	SetThrust
					Network:Send("ActivateAngularThrust", SendInfo)
				end
				if Key:IsDown(TailKey) then
					local VehicleAngle		=	LocalVehicle:GetAngle()
					local SetThrust			=	VehicleAngle * Vector3(0.25, 0, 0)
					local SendInfo	=	{}
						SendInfo.Player		=	LocalPlayer
						SendInfo.Vehicle	=	LocalVehicle
						SendInfo.Thrust		=	SetThrust
					Network:Send("ActivateAngularThrust", SendInfo)
				end
			end
		end
	end
end

function VTOL:PostTick()
	if Key:IsDown(VTOLKey) then return end
	if ThrustDecreaseTimer:GetSeconds() >= ThrustDecreaseInteger then
		ThrustDecreaseTimer:Restart()
		if CurrentThrust > 0 then
			if CurrentThrust > MaxThrust/2 then
				CurrentThrust	=	CurrentThrust * ThrustDecreaseFactor / 2
			else
				CurrentThrust	=	CurrentThrust * ThrustDecreaseFactor
			end
		end
	end
end

function VTOL:CheckList(tableList, modelID)
	for k,v in pairs(tableList) do
		if v == modelID then return true end
	end
	return false
end

--	Anchored:	1 is left, 2 is right.
function VTOL:DrawTextOnScreen(pos, text, color, fontsize, anchored)
	local ScreenSize			=	Render.Size
	local DisplayText			=	text
	local EffectiveFontSize		=	fontsize * ScreenSize.y / 1000
	local Textsize				=	Render:GetTextSize(DisplayText, EffectiveFontSize)
	local DisplayPosition	=	Vector2(pos.x - Textsize.x / 2, pos.y  - Textsize.y / 2)
	if anchored then
		if anchored == 1 then		--	Left Align
			DisplayPosition		=	Vector2(pos.x, pos.y  - Textsize.y / 2)
		elseif anchored == 2 then	--	Right Align
			DisplayPosition		=	Vector2(pos.x - Textsize.x, pos.y  - Textsize.y / 2)
		end
	end
	
    Render:DrawText(DisplayPosition + Vector2(1, 1), DisplayText, Color(0, 0, 0, 200), EffectiveFontSize)
    Render:DrawText(DisplayPosition, DisplayText, color, EffectiveFontSize)
end

VTOL = VTOL()