--------------------------------------------------------------------------------------
--	VTOL Vertical Take-Off & Landing, Plane Reverse, and Auto Land.					--
--																					--
--	By JasonMRC with help from JRDGames [Problem Solvers]							--
--	Some script based of [D4]M1K3J0N3S's Enhanced Woet and Woavaba's BetterBoost.	--
--	This is the Server File.														--
--------------------------------------------------------------------------------------

function Vtol( action, player )
        vehicle = player:GetVehicle()
--		If they're not fully seated in the vehicle, ignore the command		--
	if not IsValid(vehicle) then
		return
	end
--					Individual settings for the power of VTOL for each plane			--
--	It is suggested not to put the value above 1.0 nor below 0.1						--
--	Doing so will cause the plane to be thrown into the air or not get off the ground.	--
--	Listed in order of weight.															--
	if action == "vtol" then
		if vehicle:GetModelId() == (81) then -- Pell Silverbolt 6, Mass: 1,500
			dir1 = vehicle:GetLinearVelocity() + vehicle:GetAngle() * Vector3( 0, 0.375, 0 ) -- Default: 0, 0.375, 0
			vehicle:SetLinearVelocity( dir1 )
		elseif vehicle:GetModelId() == (59) then -- Peek Airhawk 225, Mass: 1,500
			dir1 = vehicle:GetLinearVelocity() + vehicle:GetAngle() * Vector3( 0, 0.25, 0 ) -- Default: 0, 0.25, 0
			vehicle:SetLinearVelocity( dir1 )
		elseif vehicle:GetModelId() == (24) then -- F-33 DragonFly (DLC), Mass: 5,000
			dir1 = vehicle:GetLinearVelocity() + vehicle:GetAngle() * Vector3( 0, 0.375, 0 ) -- Default: 0, 0.375, 0
			vehicle:SetLinearVelocity( dir1 )
		elseif vehicle:GetModelId() == (30) then -- Si-47 Leopard (Realistic), Mass: 5,000
			dir1 = vehicle:GetLinearVelocity() + vehicle:GetAngle() * Vector3( 0, 0.375, 0 ) -- Default: 0, 0.375, 0
			vehicle:SetLinearVelocity( dir1 )
		elseif vehicle:GetModelId() == (51) then -- Cassius 192, Mass: 12,500
			dir1 = vehicle:GetLinearVelocity() + vehicle:GetAngle() * Vector3( 0, 0.5, 0 ) -- Default: 0, 0.5, 0
			vehicle:SetLinearVelocity( dir1 )
		elseif vehicle:GetModelId() == (34) then -- G9 Eclipse, Mass: 20,000
			dir1 = vehicle:GetLinearVelocity() + vehicle:GetAngle() * Vector3( 0, 0.5, 0 ) -- Default: 0, 0.5, 0
			vehicle:SetLinearVelocity( dir1 )
		elseif vehicle:GetModelId() == (39) then -- Aeroliner 474, Mass: 100,000
			dir1 = vehicle:GetLinearVelocity() + vehicle:GetAngle() * Vector3( 0, 0.5, 0 ) -- Default: 0, 0.5, 0
			vehicle:SetLinearVelocity( dir1 )
		elseif vehicle:GetModelId() == (85) then -- Bering I-86DP, Mass: 100,000
			dir1 = vehicle:GetLinearVelocity() + vehicle:GetAngle() * Vector3( 0, 0.5, 0 ) -- Default: 0, 0.5, 0
			vehicle:SetLinearVelocity( dir1 )
		end
	end
	if action == "reverse" then
		dir1 = vehicle:GetLinearVelocity() + vehicle:GetAngle() * Vector3( 0, 0, 1 ) -- Default: 0, 0, 1
		vehicle:SetLinearVelocity( dir1 )
	end
	if action == "nose" then
		dir2 = vehicle:GetAngle() * Vector3( -0.25, 0, 0 ) -- Default: -0.25, 0, 0
		vehicle:SetAngularVelocity( dir2 )
	end
	if action == "tail" then
		dir2 = vehicle:GetAngle() * Vector3( 0.25, 0, 0 ) -- Default: 0.25, 0, 0
		vehicle:SetAngularVelocity( dir2 )
	end
	return false
end 

Network:Subscribe( "Vtol", Vtol )