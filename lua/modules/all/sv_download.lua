local addons = {
	wiremod = 160250458,
	sprops = 173482196,
	mediaplayer = 546392647,
	fortificationprops = 422672588,
	acfextras = 356521204,
	fas = 180507408,
	fas_misc = 201027186,
	fas_shotguns = 183140076,
	fas_urifles = 201027715,
	fas_smgs = 183139624,
	fas_pistols = 181283903,
	fas_rifles = 181656972,
	bobster_train = 489114511,
	magnum_train = 260954002,
	mbilliards = 299551243
}

for name, id in pairs(addons) do
	resource.AddWorkshop(tostring(id))
end
