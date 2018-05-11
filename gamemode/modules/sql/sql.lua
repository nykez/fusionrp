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


hook.Add("OnReloaded", "fusion_reconnectDatabase", function()
	if !mysql:IsConnected() then
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

	local players = mysql:Create("fusion_players")
    players:Create("id", "INT NOT NULL AUTO_INCREMENT")
    players:Create("steam_id", "VARCHAR(255) NOT NULL") -- steam 64
    players:Create("nick", "VARCHAR(255) NOT NULL")
    players:Create("playtime", "INT NOT NULL")
    players:Create("currentip", "VARCHAR(255) NOT NULL")
    players:Create("lastip", "VARCHAR(255) NOT NULL")
    players:PrimaryKey("id")
    players:Execute()

    //

    local chars = mysql:Create("fusion_characters")
    chars:Create("id", "INT NOT NULL AUTO_INCREMENT")
    chars:Create("inventory", "LONGTEXT")
    chars:Create("whitelist", "LONGTEXT")
    chars:Create("data", "LONGTEXT")
    chars:Create("vehicles", "LONGTEXT")
    chars:Create("name", "VARCHAR(255) NOT NULL")
    chars:Create("steamid", "VARCHAR(255) NOT NULL")
    chars:Create("model", "VARCHAR(255) NOT NULL")
    chars:Create("money", "INT NOT NULL")
    chars:Create("create_time", INT_NOT_NULL)
    chars:Create("description", "varchar(50) NOT NULL")
    chars:Create("skills", "LONGTEXT")
    chars:Create("levels", "LONGTEXT")
    chars:Create("org", INT_NOT_NULL)
    chars:PrimaryKey("id")
    chars:Execute()

	local orgs = mysql:Create("fusion_orgs")
	orgs:Create("id", INT_NOT_NULL_AUTO_INCR)
	orgs:Create("owner", VARCHAR_NOT_NULL)
	orgs:Create("owner_id", INT_NOT_NULL)
	orgs:Create("name", VARCHAR_NOT_NULL)
	orgs:Create("data", "LONGTEXT")
	orgs:Create("members", "LONGTEXT")
	orgs:PrimaryKey("id")
	orgs:Execute()

	print("[Fusion RP] Completed!")
	print("[Fusion RP] Database connected.")
end
hook.Add("DatabaseConnected", "fusion_populateTables", populateTables)

timer.Create("databaseThink", 1, 0, function()
	mysql:Think();
end);
