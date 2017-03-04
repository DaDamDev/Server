module("time", package.seeall)

--time_welcome = CreateConVar("time_welcome", "1", FCVAR_ARCHIVE)

if not sql.TableExists("time") then
	sql.Query("CREATE TABLE IF NOT EXISTS time ( id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, player INTEGER NOT NULL, totaltime INTEGER NOT NULL, lastvisit INTEGER NOT NULL );")
	sql.Query("CREATE INDEX IDX_TIME_PLAYER ON time ( player DESC );")
end

function onJoin(ply)
	local uid = ply:UniqueID()
	local row = sql.QueryRow("SELECT totaltime, lastvisit FROM time WHERE player = "..uid..";")
	local time = 0 

	if row then
		sql.Query("UPDATE time SET lastvisit = "..os.time().." WHERE player = "..uid..";")
		time = row.totaltime
	else
		sql.Query("INSERT into time ( player, totaltime, lastvisit ) VALUES ( "..uid..", 0, "..os.time().." );")
	end
	ply:SetTime(time)
	ply:SetTimeStart(CurTime())
end
hook.Add("PlayerInitialSpawn", "dadam_time", onJoin)

function updatePlayer(ply)
	sql.Query("UPDATE time SET totaltime = "..math.floor(ply:GetTimeTotalTime()).." WHERE player = "..ply:UniqueID()..";")
end

hook.Add("PlayerDisconnected", "dadam_time", updatePlayer)

function updateAll()
	local players = player.GetAll()

	for _, ply in ipairs(players) do
		if ply and ply:IsConnected() then
			updatePlayer(ply)
		end
	end
end
timer.Create("dadam_time", 67, 0, updateAll)
