
if SERVER then

	hook.Add("PostPlayerLoadout", "fusion_stamina", function(client)
		client:setLocalVar("stm", 100)

		print('doing stam system')

		local uniqueID = "fusionStam"..client:SteamID()
		local offset = 0
		local velocity
		local length2D = 0
		local runSpeed = client:GetRunSpeed() - 5

		timer.Create(uniqueID, 0.25, 0, function()
			if (IsValid(client)) then
				local character = client:getChar()

				if (client:GetMoveType() != MOVETYPE_NOCLIP and character) then
					velocity = client:GetVelocity()
					length2D = velocity:Length2D()

					runSpeed = 255

					if (client:WaterLevel() > 1) then
						runSpeed = runSpeed * 0.775
					end

					if (client:KeyDown(IN_SPEED) and length2D >= (runSpeed - 10)) then
						offset = -2
					elseif (offset > 0.5) then
						offset = 1
					else
						offset = 1.75
					end

					if (client:Crouching()) then
						offset = offset + 1
					end

					local current = client:getLocalVar("stm", 0)
					local value = math.Clamp(current + offset, 0, 100)

					if (current != value) then
						client:setLocalVar("stm", value)

						if (value == 0 and !client:getNetVar("brth", false)) then
							client:SetRunSpeed(130)
							client:setNetVar("brth", true)
						elseif (value >= 50 and client:getNetVar("brth", false)) then
							client:SetRunSpeed(runSpeed)
							client:setNetVar("brth", nil)
						end
					end

				end

			else
				timer.Remove(uniqueID)
			end

		end)

	end)
	
	local playerMeta = FindMetaTable("Player")

	function playerMeta:restoreStamina(amount)
		local current = self:getLocalVar("stm", 0)
		local value = math.Clamp(current + amount, 0, 100)

		self:setLocalVar("stm", value)
	end

end
