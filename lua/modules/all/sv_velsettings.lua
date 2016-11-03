local tbl = physenv.GetPerformanceSettings()
tbl.MaxAngularVelocity = 30000
physenv.SetPerformanceSettings(tbl)

local tbl2 = physenv.GetPerformanceSettings()
tbl2.MaxVelocity = 20000
physenv.SetPerformanceSettings(tbl2)