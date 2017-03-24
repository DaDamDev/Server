dadam = dadam or {}

dadam.saveSettings = function()
	local data = ""
	
	data = data .. dadam.skin
	
	file.Write("dadamdev.txt", data)
end

if file.Exists("dadamdev.txt", "DATA") then
	local data = string.Explode(";", file.Read("dadamdev.txt"))
	
	dadam.skin = data[1]
else
	dadam.skin = "default"
	
	dadam.saveSettings()
end