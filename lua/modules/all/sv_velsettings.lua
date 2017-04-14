hook.Add("Initialize", "dadam_velsettings", function()
	local tbl = physenv.GetPerformanceSettings()
	tbl.MaxAngularVelocity = 30000
	tbl.MaxVelocity = 20000

	physenv.SetPerformanceSettings(tbl)
end)