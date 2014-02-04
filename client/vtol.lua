--------------------------------------------------------------------------------------
--	VTOL Vertical Take-Off & Landing, Plane Reverse, and Auto Land.					--
--																					--
--	By JasonMRC with help from JRDGames [Problem Solvers]							--
--	Some script based of [D4]M1K3J0N3S's Enhanced Woet and Woavaba's BetterBoost.	--
--	This is the Client File.														--
--------------------------------------------------------------------------------------

vtolEnabled = true		-- Allows Vertical take-off.
reverseEnabled = true	-- Allows the plane to go in reverse without affecting normal deceleration by CTRL.
EasyLandEnabled = true	-- If enabled the Landing Gear will come out when within 35m of any surface. Makes normal landing a lot easier.

--		Instruction Text		--
VTOLText = "\"Z\" for Vertical Take-Off"	-- Instruction text to display at the bottom center of the screen when inside a valid plane.
ReverseText = "\"X\" for Reverse Thrust"	-- Instruction text to display at the bottom center of the screen when inside a valid plane.
--	Instruction Text Placement	--
VTOLTextPadding = 25	-- The padding between the bottom of the screen and the text. Default: 25
ReverseTextPadding = 40	-- The padding between the bottom of the screen and the text. Default: 40

--								A note Regarding Nose/Tail Pitch									--
--	This command will force the nose/tail up or down regardless of whether you are flying or not.	--
--	It does not replace the normal up and down function of W and S and does not hinder it either.	--
--	It is added to allow you to level the plane out when hovering using VTOL.						--
--	This is because sometimes the nose or tail will fall downwards when attempting to land.			--
noseEnabled = true	-- Allows the nose to be pitched if speed is less than 25. Sometimes necessary for Vertical landings.
tailEnabled = true	-- Allows the tail to be pitched if speed is less than 25. Sometimes necessary for Vertical landings.
NoseTailSpeed = 25	-- The speed, in meters per second, at which the Nose and Tail may be pitched Default: 25 (Roughly 55.9 MPH or 90KPH

air_vehicles= {}

function AddVehicleAir(id)
	air_vehicles[id] = true
end
--									All air vehicles IDs							--
--	If you want to be authentic to real life, remove all but the Si-47 Leopard.		--
--	The Si-47 Leopard is based off the Harrier Jump Jet, owned by the UK Air Force.	--
--	Listed in order of weight.														--
AddVehicleAir(81)	-- Pell Silverbolt 6, Mass: 1,500
AddVehicleAir(59)	-- Peek Airhawk 225, Mass: 1,500
AddVehicleAir(24)   -- F-33 DragonFly	(DLC), Mass: 5,000
AddVehicleAir(30)	-- Si-47 Leopard	(Realistic), Mass: 5,000
AddVehicleAir(51)	-- Cassius 192, Mass: 12,500
AddVehicleAir(34)	-- G9 Eclipse, Mass: 20,000
AddVehicleAir(39)	-- Aeroliner 474, Mass: 100,000
AddVehicleAir(85)	-- Bering I-86DP, Mass: 100,000

function Activate( args )
	if LocalPlayer:InVehicle() and LocalPlayer:GetState() ~= PlayerState.InVehicle then return end
	if not IsValid(LocalPlayer:GetVehicle()) then return end
	if Game:GetState() ~= GUIState.Game then return end
	
	if Key:IsDown(90) then -- Default: 90, Z
		if air_vehicles[LocalPlayer:GetVehicle():GetModelId()] then
			if vtolEnabled then
				Network:Send( "Vtol", "vtol" )
			end
		end
	end
	if Key:IsDown(88) then -- Default: 88, X
		if air_vehicles[LocalPlayer:GetVehicle():GetModelId()] then
			if reverseEnabled then
				Network:Send( "Vtol", "reverse" )
			end
		end
	end
	if Key:IsDown(87) and LocalPlayer:GetLinearVelocity():Length() <= NoseTailSpeed then -- Default: 87, W
		if air_vehicles[LocalPlayer:GetVehicle():GetModelId()] then
			if noseEnabled then
				Network:Send( "Vtol", "nose" )
			end
		end
	end
	if Key:IsDown(83) and LocalPlayer:GetLinearVelocity():Length() <= NoseTailSpeed then -- Default: 83, S
		if air_vehicles[LocalPlayer:GetVehicle():GetModelId()] then
			if tailEnabled then
				Network:Send( "Vtol", "tail" )
			end
		end
	end
end 

function LandingGear()
		if LocalPlayer:InVehicle() and LocalPlayer:GetState() ~= PlayerState.InVehicle then return end
		if not IsValid(LocalPlayer:GetVehicle()) then return end
		if Game:GetState() ~= GUIState.Game then return end
		
		if air_vehicles[LocalPlayer:GetVehicle():GetModelId()] then
			local pos = LocalPlayer:GetBonePosition( "ragdoll_Spine" )
			local dir = LocalPlayer:GetAngle() * Vector3( 0, -1, 1 )
			local altitude = LocalPlayer:GetPosition().y - 200
			local result = Physics:Raycast( pos, dir, 0, altitude )
			local distance = result.distance

			if distance >= 1000 then return end
			
			if distance <= 35 then
				if EasyLandEnabled or Key:IsDown(90) then
					Input:SetValue(Action.PlaneDecTrust, 1)
				end
			end
		end
	end

function RenderEvent()
	if LocalPlayer:InVehicle() and LocalPlayer:GetState() ~= PlayerState.InVehicle then return end
	if not IsValid(LocalPlayer:GetVehicle()) then return end
	if Game:GetState() ~= GUIState.Game then return end
    if LocalPlayer:GetState() == 2 or LocalPlayer:GetState() == 5 then return end
    
	if air_vehicles[LocalPlayer:GetVehicle():GetModelId()] then
		local padding = VTOLTextPadding
        local vtol_text = VTOLText
        local vtol_size = Render:GetTextSize( vtol_text )
        local vtol_pos = Vector2( 
            (Render.Width - vtol_size.x)/2, 
            (Render.Height - vtol_size.y)-padding )
        Render:DrawText( vtol_pos, vtol_text, Color( 255, 255, 255 ) )
    end
	if air_vehicles[LocalPlayer:GetVehicle():GetModelId()] then
		local padding = ReverseTextPadding
        local reverse_text = ReverseText
        local reverse_size = Render:GetTextSize( reverse_text )
        local reverse_pos = Vector2( 
            (Render.Width - reverse_size.x)/2, 
            (Render.Height - reverse_size.y)-padding )
        Render:DrawText( reverse_pos, reverse_text, Color( 255, 255, 255 ) )
    end
end

Events:Subscribe( "InputPoll", LandingGear)
Events:Subscribe( "PreTick", Activate)
Events:Subscribe( "Render", RenderEvent)

print(vtolEnabled)	--	Prints in the Client's console if Hover is active.