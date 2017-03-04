local tbl = physenv.GetPerformanceSettings()
tbl.MaxAngularVelocity = 30000
tbl.MaxVelocity = 20000

physenv.SetPerformanceSettings(tbl)
