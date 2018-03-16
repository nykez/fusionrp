local mysql_data = {

	hostname = "nykez.site.nfoservers.com",

	username = "pgrpdev",

	password = "Makayla123!!",

	database = "pgrpdev_fusionrp",

	// Supports sqlite, tmysql4, mysqloo
	module = "mysqloo"
}


local function connectDatabase()
	mysql:SetModule(mysql_data.module)
	mysql:Connect(mysql_data.hostname, mysql_data.username, mysql_data.password, mysql_data.database, mysql_data.port);
end
hook.Add( "Initialize", "fusion_connectDatabase", connectDatabase)

mysql:IsConnected()

hook.Add("OnReloaded", "mysql.reconnectDatabase", function()
	if !mysql:IsConnected() then
		print("reconnecting database")
		connectDatabase()
	end
end)

local function discDatabase()
	mysql:Disconnect()
end
hook.Add("Shutdown", "fusion_discDatabase", discDatabase)

local function populateTables()
	print("[Fusion RP] Setting up database tables...")

	local INT_NOT_NULL_AUTO_INCR = "INT NOT NULL AUTO_INCREMENT"
	local INT_NOT_NULL = "INT NOT NULL"
	local VARCHAR_NOT_NULL = "VARCHAR(255) NOT NULL"
	local LONGTEXT_NOT_NULL = "LONGTEXT NOT NULL"

	local players = mysql:Create("player_data")
	players:Create("id", INT_NOT_NULL_AUTO_INCR)
	players:Create("steam_id", VARCHAR_NOT_NULL)
	players:Create("rp_first", VARCHAR_NOT_NULL)
	players:Create("rp_last", VARCHAR_NOT_NULL)
	players:Create("xp", INT_NOT_NULL)
	players:Create("level", INT_NOT_NULL)
	players:Create("account_level", INT_NOT_NULL)
	players:Create("inventory", "LONGTEXT")
	players:Create("skills", LONGTEXT_NOT_NULL)
	players:Create("money", INT_NOT_NULL)
	players:Create("bank", INT_NOT_NULL)
	players:Create("organization", INT_NOT_NULL)
	players:Create("model", VARCHAR_NOT_NULL)
	players:Create("modeldata", "LONGTEXT")
	players:Create("playtime", INT_NOT_NULL)
	players:Create("nick", VARCHAR_NOT_NULL)
	players:Create("vehicles", "LONGTEXT")
	players:PrimaryKey("id")
	players:Execute()

	-- local vehicles = mysql:Create("player_vehicles")
	-- vehicles:Create("id", INT_NOT_NULL_AUTO_INCR)
	-- vehicles:Create("steam_id", VARCHAR_NOT_NULL)
	-- vehicles:Create("car_id", INT_NOT_NULL)
	-- vehicles:Create("bodygroups", VARCHAR_NOT_NULL)
	-- vehicles:Create("col_r", INT_NOT_NULL)
	-- vehicles:Create("col_g", INT_NOT_NULL)
	-- vehicles:Create("col_b", INT_NOT_NULL)
	-- vehicles:PrimaryKey("id")
	-- vehicles:Execute()

	-- local orgs = mysql:Create("player_orgs")
	-- orgs:Create("id", INT_NOT_NULL_AUTO_INCR)
	-- orgs:Create("org_id", INT_NOT_NULL)
	-- orgs:Create("owner_id", VARCHAR_NOT_NULL)
	-- orgs:Create("name", VARCHAR_NOT_NULL)
	-- orgs:Create("description", VARCHAR_NOT_NULL)
	-- orgs:PrimaryKey("id")
	-- orgs:Execute()

	print("[Fusion RP] Completed!")
	print("[Fusion RP] Database connected.")
end
hook.Add("DatabaseConnected", "fusion_populateTables", populateTables)

timer.Create("databaseThink", 1, 0, function()
	mysql:Think();
end);
