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
	local players = mysql:Create("fusion_players")
	players:Create("id", "VARCHAR(255) NOT NULL")
	players:Create("rp_first", "VARCHAR(255) NOT NULL")
	players:Create("rp_last", "VARCHAR(255) NOT NULL")
	players:PrimaryKey("id")
	players:Execute()
end
hook.Add("DatabaseConnected", "fusion_populateTables", populateTables)
