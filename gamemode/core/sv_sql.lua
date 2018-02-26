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