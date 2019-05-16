hook.Add("Initialize", "sbv_physenv_fix", function()
	physenv.SetPerformanceSettings({
		MaxVelocity = 11784960000,
		MaxAngularVelocity = 11784960000
	})
end)