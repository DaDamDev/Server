local list = {
	wiremod = "160250458",
	sprops = "173482196",
	mediaplayer = "546392647"
}

for name, id in pairs(list) do
	--print(id)
	resource.AddWorkshop(id)
end