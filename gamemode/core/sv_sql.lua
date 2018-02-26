local mysql_data = {

	hostname = " ",

	username = " ",

	password = " ",

	database = " ",

	// Supports sqlite, tmysql4, mysqloo
	module = "sqlite"
}


local function connectDatabase()
	mysql:SetModule(mysql_data.module)
	mysql:Connect(mysql_data.hostname, mysql_data.username, mysql_data.password, mysql_data.database, mysql_data.port);
end
hook.Add( "Initialize", "fusion_connectDatabase", connectDatabase)

local function discDatabase()
	mysql:Disconnect()
end
hook.Add("Shutdown", "fusion_discDatabase", discDatabase)

local function populateTables()
	print("[Fusion RP] Setting up database tables...")

	local players = mysql:Create("player_data")
	players:Create("id", "INT NOT NULL AUTO_INCREMENT")
	players:Create("steam_id", "VARCHAR(255) NOT NULL")
	players:Create("rp_first", "VARCHAR(255) NOT NULL")
	players:Create("rp_last", "VARCHAR(255) NOT NULL")
	players:Create("xp", "INT NOT NULL")
	players:Create("account_level", "INT NOT NULL")
	players:Create("inventory", "JSON")
	players:Create("skills", "JSON")
	players:Create("money", "INT NOT NULL")
	players:Create("bank", "INT NOT NULL")
	players:Create("organization", "INT NOT NULL")
	players:Create("model", "VARCHAR(255) NOT NULL")
	players:Create("playtime", "INT NOT NULL")
	players:Create("nick", "VARCHAR(255) NOT NULL")
	players:PrimaryKey("id")
	players:Execute()

	local vehicles = mysql:Create("player_vehicles")
	vehicles:Create("id", "INT NOT NULL AUTO_INCREMENT")
	vehicles:Create("steam_id", "VARCHAR(255) NOT NULL")
	vehicles:Create("car_id", "INT NOT NULL")
	vehicles:Create("bodygroups", "VARCHAR(255) NOT NULL")
	vehicles:Create("col_r", "INT NOT NULL")
	vehicles:Create("col_g", "INT NOT NULL")
	vehicles:Create("col_b", "INT NOT NULL")
	vehicles:PrimaryKey("id")
	vehicles:Execute()

	local orgs = mysql:Create("player_orgs")
	orgs:Create("id", "INT NOT NULL AUTO_INCREMENT")
	orgs:Create("org_id", "INT NOT NULL")
	orgs:Create("owner_id", "VARCHAR(255) NOT NULL")
	orgs:Create("name", "VARCHAR(255) NOT NULL")
	orgs:Create("description", "VARCHAR(255) NOT NULL")
	orgs:PrimaryKey("id")
	orgs:Execute()

	print("[Fusion RP] Completed!")
end
hook.Add("DatabaseConnected", "fusion_populateTables", populateTables)
