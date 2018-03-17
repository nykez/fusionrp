if SERVER then
    util.AddNetworkString("Fusion.notify")
else
    net.Receive("Fusion.notify", function(len)
        LocalPlayer():Notify(net.ReadString())
    end)
end

function PLAYER:Notify(str)
	if CLIENT then
		AddNotify(str)
		surface.PlaySound("ui/notify.wav")
	else
		net.Start("Fusion.notify")
			net.WriteString(str)
		net.Send(self)
	end
end
