local addons = {
	wiremod					= 160250458,
	sprops					= 173482196,
	mediaplayer				= 546392647,
	fortificationprops		= 422672588,
	acfextras				= 356521204,
	fas						= 180507408,
	fas_misc				= 201027186,
	fas_shotguns			= 183140076,
	fas_urifles				= 201027715,
	fas_smgs				= 183139624,
	fas_pistols				= 181283903,
	fas_rifles				= 181656972,
	mbilliards				= 299551243,
	simfphys_base			= 771487490,
	white_texture_pack		= 256056339,
	more_materials			= 105841291,
	race_seats				= 471435979,
}

local files = {
	dark_ui_material		= "materials/skins/dark.png"
}

for name, id in pairs(addons) do
	resource.AddWorkshop(tostring(id))
end

for name, path in pairs(files) do
	resource.AddFile(path)
end
