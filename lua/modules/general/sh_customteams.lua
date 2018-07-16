local teams = {
	"Owner",
	"Code Slave",
	"Traitor",
	"Low IQ",
	"nooberino.lua"
}

for k, v in pairs(teams) do
	team.SetUp(-250 + k, v, Color(158, 200, 255))
end