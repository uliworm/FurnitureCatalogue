local currentChar	= nil
local apiVersion 	= 10020
local task = LibStub("LibAsync"):Create("FurnitureCatalogue_ScanDataFiles")
local task2 = LibStub("LibAsync"):Create("FurnitureCatalogue_ScanCharacterKnowledge")
local characterAlliance = GetUnitAlliance('player')

local NUMBER_TYPE 	= "number"
local STRING_TYPE 	= "string"
local STRING_EMPTY 	= ""

local FURC_STRING_CRAFTABLE_BY = "Can be crafted by "
local FURC_STRING_CANNOT_CRAFT = "You cannot craft this yet"

local FURC_STRING_TRADINGHOUSE = "Seen in trading house"

local function getCurrentChar()
	if nil == currentChar then currentChar = zo_strformat(GetUnitName("player")) end
	return currentChar
end
local function p(...)
	FurC.DebugOut(...)
end

local function startupMessage(text)
	if FurC.GetStartupSilently() then return end
	d(text)
end

local function getItemId(itemLink)
	if nil == itemLink or STRING_EMPTY == itemLink then return end
	if type(itemLink) == NUMBER_TYPE and itemLink > 9999 then return itemLink end
	local _, _, _, itemId = ZO_LinkHandler_ParseLink(itemLink)
	return tonumber(itemId)
end
FurC.GetItemId = getItemId

local function getItemLink(itemId)	
	itemId = tostring(itemId)
	if #itemId > 55 then return itemId end
	if #itemId < 4 then return end 
	return zo_strformat("|H1:item:<<1>>:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h", itemId)
end 
FurC.GetItemLink = getItemLink

local function trySaveDevDebug(recipeArray)
	if not (FurC.AccountName == "@manavortex" or FurC.AccountName == "@Manorin") then return end
	if recipeArray.origin ~= FURC_DROP then return end
	itemLink = (nil ~= recipeArray.blueprintLink and recipeArray.blueprintLink) or recipeArray.itemId
	FurnitureCatalogue.devSettings[itemLink] = "true, -- " .. GetItemLinkName(itemLink)
end

local function addDatabaseEntry(recipeKey, recipeArray)
	if recipeKey and recipeArray and {} ~= recipeArray then  
		FurC.settings.data[recipeKey] = recipeArray	
	end
end


local function makeMaterial(recipeKey, recipeArray, forcePlaintext)	

	if nil == recipeArray or (nil == recipeArray.blueprint and nil == recipeArray.recipeIndex and nil == recipeArray.recipeListIndex) then 
		return "invalid recipe array" 
	end
	local ret = ""
	for ingredientLink, qty in pairs(FurC.GetIngredients(recipeKey, recipeArray)) do
		ret = zo_strformat("<<1>> <<2>>x <<3>>, ", ret, qty, ingredientLink)
	end

	if #ret == 0 then return "couldn't make materials for " .. tostring(blueprint) end
	return ret:sub(0, -4)
	
end
FurC.GetMats = makeMaterial

function FurC.GetIngredients(itemLink, recipeArray)
	recipeArray = recipeArray or FurC.Find(itemLink)
	local ingredients = {}
	if recipeArray.blueprint then 
		local blueprintLink = FurC.GetItemLink(recipeArray.blueprint)
		numIngredients = GetItemLinkRecipeNumIngredients(blueprintLink)
		for ingredientIndex=1, numIngredients do
			name, _, qty 				= GetItemLinkRecipeIngredientInfo(blueprintLink, ingredientIndex)
			ingredientLink 				= GetItemLinkRecipeIngredientItemLink(blueprintLink, ingredientIndex)
			ingredients[ingredientLink]	= qty
		end
	else 
		_, name, numIngredients = GetRecipeInfo(recipeArray.recipeListIndex, recipeArray.recipeIndex)
		for ingredientIndex=1, numIngredients do
			name, _, qty 					= GetRecipeIngredientItemInfo(recipeArray.recipeListIndex, recipeArray.recipeIndex, ingredientIndex) 
			ingredientLink 					= GetRecipeIngredientItemLink(recipeArray.recipeListIndex, recipeArray.recipeIndex, ingredientIndex)
			ingredients[ingredientLink]		= qty
		end		
	end
	return ingredients
end

local function parseFurnitureItem(itemLink)					-- saves to DB, returns recipeArray

	if not IsItemLinkPlaceableFurniture(itemLink) then return end
	
	local recipeKey 					= getItemId(itemLink)
	local recipeArray 					= FurC.settings.data[recipeKey]
	if nil ~= recipeArray then return recipeArray end
	
	recipeArray = {}
	
	addDatabaseEntry(recipeKey, recipeArray)	
	
	return recipeArray
end


local function parseBlueprint(blueprintLink)				-- saves to DB, returns recipeArray
	
	local itemLink 		= GetItemLinkRecipeResultItemLink(blueprintLink, LINK_STYLE_BRACKETS)
	local blueprintId 	= getItemId(blueprintLink)
	local recipeKey 	= getItemId(itemLink)
	if nil == itemLink or nil == recipeKey or nil == GetItemLinkName(itemLink) then 
		p("error when parsing the blueprint link ".. tostring(blueprintLink))
	return end	
	
	local recipeArray 	= FurC.settings.data[recipeKey] 
	
	if nil 	== recipeArray then 
		recipeArray = {} 
		recipeArray.origin 							= FURC_CRAFTING
		recipeArray.characters						= {}
		recipeArray.craftingSkill					= GetItemLinkCraftingSkillType(itemLink)
		addDatabaseEntry(recipeKey, recipeArray)
	end
	
	recipeArray.blueprint = recipeArray.blueprint or getItemId(blueprintLink)
	
	if (IsItemLinkRecipeKnown(blueprintLink)) then 
		recipeArray.characters[getCurrentChar()] 	= true
	end
	
	
	
	return recipeArray
	
end

local lastLink = nil
local recipeArray = nil 

function FurC.Find(itemOrBlueprintLink)						-- sets recipeArray, returns it - calls scanItemLink
	-- p("scanItemLink(<<1>>)...", itemOrBlueprintLink)		-- do not return empty arrays. If this returns nil, abort!
	if nil == itemOrBlueprintLink then return end
		
	if itemOrBlueprintLink == lastLink and nil ~= recipeArray then 
		return recipeArray
	else	
		recipeArray = nil 
		lastLink = itemOrBlueprintLink
	end
	
	if IsItemLinkFurnitureRecipe(itemOrBlueprintLink) then 
		recipeArray = parseBlueprint(itemOrBlueprintLink)
	elseif IsItemLinkPlaceableFurniture(itemOrBlueprintLink) then 		
		recipeArray = parseFurnitureItem(itemOrBlueprintLink)	
	end	
	return recipeArray
end

function FurC.Delete(itemOrBlueprintLink)						-- sets recipeArray, returns it - calls scanItemLink
	local recipeArray = scanItemLink(itemOrBlueprintLink)	
	if nil == recipeArray then return end
	local itemLink = recipeArray.itemId
	local itemKey = getItemId(itemLink)
	FurC.settings.data[itemKey] = nil
end

function FurC.GetEntry(itemOrBlueprintLink)	
	local itemLink =  (IsItemLinkFurnitureRecipe(itemOrBlueprintLink) and GetRecipeResultItemLink(itemOrBlueprintLink)) or itemOrBlueprintLink
	local recipeArray = FurC.Find(itemLink)
	d(zo_strformat("Trying to get entry for <<1>>: <<2>>", itemLink, recipeArray))
	if not recipeArray then return end
	local itemId = getItemId(itemOrBlueprintLink)
	if recipeArray.blueprint then 
		itemId = getItemId(GetItemLinkRecipeResultItemLink(blueprintLink))
	end
	return itemId, recipeArray
	
end

function FurC.IsFavorite(itemLink, recipeArray)
	recipeArray = recipeArray or FurC.Find(itemLink)
	return recipeArray.favorite
end
function FurC.Fave(itemLink, recipeArray)
	recipeArray = recipeArray or FurC.Find(itemLink)
	recipeArray.favorite = not recipeArray.favorite
	FurC.UpdateGui()
end

local function scanRecipeIndices(recipeListIndex, recipeIndex)		-- returns recipeArray or nil, initialises
	
	local itemLink = GetRecipeResultItemLink(recipeListIndex, recipeIndex, LINK_STYLE_BRACKETS)
	if nil == itemLink or (not IsItemLinkPlaceableFurniture(itemLink)) then return {} end	
	
	local recipeKey = getItemId(itemLink)
	
	local recipeArray = FurC.settings["data"][recipeKey]
	
	local known, _, _, _, _, _, filterType = GetRecipeInfo(recipeListIndex, recipeIndex)
	
	if (nil == recipeArray) then 
		
		recipeArray 				= {}
			
		recipeArray.origin 			= FURC_CRAFTING
		recipeArray.version			= recipeArray.version or 3		
		recipeArray.recipeListIndex = recipeListIndex
		recipeArray.recipeIndex 	= recipeIndex
		addDatabaseEntry(recipeKey, recipeArray)
		
	end
	recipeArray.characters		= recipeArray.characters or {}	
	if known then
		recipeArray.characters[getCurrentChar()] 	= known
		FurC.settings.accountCharacters[getCurrentChar()] = FurC.settings.accountCharacters[getCurrentChar()] or known
	end
	
	return recipeArray 
	
end

function FurC.TryCreateRecipeEntry(recipeListIndex, recipeIndex)	-- returns scanRecipeIndices, called from Events.lua
	return scanRecipeIndices(recipeListIndex, recipeIndex)
end

function FurC.CanCraft(recipeKey, recipeArray)
	if recipeKey == nil then return false end
	recipeArray = recipeArray or FurC.settings.data[recipeKey]
	if nil == recipeArray or nil == recipeArray.characters or {} == recipeArray.characters then return false end
	return recipeArray.characters[getCurrentChar()]
end

function FurC.GetCraftingSkillType(recipeKey, recipeArray)

	local itemLink 			= FurC.GetItemLink(recipeKey)
	local craftingSkillType	= GetItemLinkCraftingSkillType(itemLink)
	
	if 0 == craftingSkillType and recipeArray.blueprint then 
		craftingSkillType = GetItemLinkRecipeCraftingSkillType(FurC.GetItemLink(recipeArray.blueprint))
	elseif 0 == craftingSkillType and recipeArray.recipeListIndex and recipeArray.recipeIndex then
		_, _, _, _, _, _, craftingSkillType = GetRecipeInfo(recipeArray.recipeListIndex, recipeArray.recipeIndex)
	end
	
	return craftingSkillType
end



local function scanCharacter()
	local listName, numRecipes
	for recipeListIndex=1, GetNumRecipeLists() do
		listName, numRecipes = GetRecipeListInfo(recipeListIndex)
		for recipeIndex=1, numRecipes do			
			scanRecipeIndices(recipeListIndex, recipeIndex) --	returns true on success
		end
	end 
	p(("|c2266ffFurniture Catalogue|r|cffffff: Character scan complete...|r"))
end

function FurC.RescanRumourRecipes()
	
	local function rescan()
		for itemId, recipeArray in pairs(FurC.settings.data) do		
			if recipeArray.source == FURC_RUMOUR then
				local itemLink = recipeArray[itemLink]
				if not FurC.RumourRecipes[itemLink] then 
					recipeArray.source = FURC_CRAFTING
					recipeArray.origin = nil
				end
			end
		end
	end
	
	task:Call(rescan)
	:Then(FurC.UpdateGui)
end

local recipeArray 
local function scanFromFiles(shouldScanCharacter)  
	local function parseZoneData(zoneName, zoneData, versionNumber, origin)
		for vendorName, vendorData in pairs(zoneData) do
			for itemId, itemData in pairs(vendorData) do
					 
					recipeArray 				= {}
					recipeArray.origin			= origin
					recipeArray.version			= versionNumber	
					addDatabaseEntry(itemId, recipeArray)
			end
		end	
	end
	local function scanRecipeFile()
		local recipeKey, recipeArray
		local function scanArray(ary, versionNumber, origin)
			if nil == ary then return end
			for key, recipeId in ipairs(ary) do
				local recipeLink = FurC.GetItemLink(recipeId)
				local itemLink = GetItemLinkRecipeResultItemLink(recipeLink)
				recipeArray = parseBlueprint(recipeLink)
				if nil == recipeArray then 
					p("scanRecipeFile: error for <<1>>", recipeLink)
				else
					recipeKey = getItemId(recipeArray.itemId)
					recipeArray.version 	 	= versionNumber
					recipeArray.origin 			= origin
					addDatabaseEntry(getItemId(itemLink), recipeArray)
				end		
			end
		end	
		
		for versionNumber, versionData in pairs(FurC.Recipes) do
			scanArray(versionData, versionNumber, FURC_CRAFTING)
		end
		for versionNumber, versionData in pairs(FurC.RollisRecipes) do
			scanArray(versionData, versionNumber, FURC_ROLLIS)
		end
	end
	
	local function scanRollis()
		for versionNumber, versionData in pairs(FurC.Rollis) do
			for itemId, itemSource in pairs(versionData) do
				recipeArray = parseFurnitureItem(itemId)
				if nil ~= recipeArray then 
					recipeArray.version = versionNumber
					recipeArray.origin = FURC_ROLLIS
					addDatabaseEntry(itemLink, recipeArray)			
				end
			end	
		end	
	end
	
	local function scanFestivalFiles()
		for versionNumber, versionData in pairs(FurC.EventItems) do
			for eventName, eventData in pairs(versionData) do
				for eventItemSource, eventItemData in pairs(eventData) do
					for itemId, itemData in pairs(eventItemData) do
						zo_callLater(function()
							recipeArray = {}
							if nil ~= recipeArray then 
								recipeArray.craftable 	= false					
								recipeArray.version 	= versionNumber
								recipeArray.origin 		= FURC_VENDOR_FESTIVAL
							end				
							addDatabaseEntry(itemId, recipeArray)										
						end, 50)
					end		
				end		
			end 
		end 
	end

	local function scanMiscItemFile()		
		for versionNumber, versionData in pairs(FurC.MiscItemSources) do
			for origin, originData in pairs(versionData) do			
				for itemId, itemSource in pairs(originData) do
					local itemLink = FurC.GetItemLink(itemId)
					
					recipeArray = parseFurnitureItem(FurC.GetItemLink(itemId))
					if nil ~= recipeArray then 
						recipeArray.version = versionNumber
						recipeArray.origin  = origin
						addDatabaseEntry(itemId, recipeArray)
					else 
						d(zo_strformat("<<1>> (<<2>>) -> <<3>>", itemLink, itemId, origin))
					end
				end				
			end
		end
	end
	
	local function scanVendorFiles()
	
		FurC.InitAchievementVendorList()
		local recipeKey, recipeArray, itemSource
		
		for versionNumber, versionData in pairs(FurC.AchievementVendors) do
			for zoneName, zoneData in pairs(versionData) do	
				parseZoneData(zoneName, zoneData, versionNumber, FURC_VENDOR) 
			end 
		end
		
		for versionNumber, vendorData in pairs(FurC.LuxuryFurnisher) do
			for itemId, itemData in pairs(vendorData) do
					 local recipeArray 			= {}
			
					recipeArray.origin			= FURC_LUXURY
					recipeArray.version			= versionNumber	
					addDatabaseEntry(itemId, recipeArray)
			end			 
		end
		
		for versionNumber, versionData in pairs(FurC.PVP) do
			for zoneName, zoneData in pairs(versionData) do		
				parseZoneData(zoneName, zoneData, versionNumber, FURC_PVP) 
			end 
		end	
	end

	local function scanRumourRecipes()
		for index, blueprintId in pairs(FurC.RumourRecipes) do
			local blueprintLink = FurC.GetItemLink(blueprintId)
			local itemLink = GetItemLinkRecipeResultItemLink(blueprintLink, LINK_STYLE_BRACKETS) 
			if #itemLink == 0 then itemLink = blueprintLink end
			local itemId = getItemId(itemLink)
			recipeArray = parseBlueprint(blueprintLink) or parseFurnitureItem(itemLink)
			
			if blueprintId ~= itemId then 
				recipeArray.blueprint = blueprintId
			end
			recipeArray.origin = FURC_RUMOUR
			recipeArray.verion = FURC_HOMESTEAD
			addDatabaseEntry(itemId, recipeArray)

		end 
	end
	FurC.IsLoading(true)
	
	task:Call(scanRollis)
	:Then(scanRecipeFile)
	:Then(scanVendorFiles)
	-- :Then(scanFestivalFiles)
	:Then(scanMiscItemFile)
	:Then(scanRumourRecipes)
	:Then(
	function() 
		if shouldScanCharacter then 
			scanCharacter()
		else
			startupMessage("|c2266ffFurniture Catalogue|r|cffffff: |cffffffIf you miss any recipes, please trigger a scan on your furniture crafter by clicking the refresh button in the UI.|r")
		end
	end)
	:Then(FurC.UpdateGui)
	startupMessage(zo_strformat("|c2266ffFurniture Catalogue|r|cffffff: The database is up-to-date.|r"))
	
end



function FurC.ScanFromFiles(scanCharacterKnowledge)
	return scanFromFiles(scanCharacterKnowledge)
end

local function getScanFromFiles()

	if (FurC.settings.databaseVersion < FurC.version) then
		FurC.settings.databaseVersion = FurC.version
		return true
	end
	
	return FurC.settings.data == {}
end	

local function getScanCharacter()
	if nil == FurC.settings.accountCharacters[FurC.CharacterName] then
		FurC.settings.accountCharacters[FurC.CharacterName] = false
		return true
	end
end	

function FurC.ScanRecipes(shouldScanFiles, shouldScanCharacter)								-- returns database
	
	shouldScanFiles = shouldScanFiles or getScanFromFiles()
	shouldScanCharacter = (shouldScanCharacter or getScanCharacter())
	if (shouldScanFiles) then 
		p(("|c2266ffFurniture Catalogue|r|cffffff: Scanning data files...|r"))
		scanFromFiles(shouldScanCharacter)
	elseif (shouldScanCharacter) then
		p("Not scanning files, scanning character knowledge now...")
		scanCharacter() 		
	end	
end


function FurC.GetCrafterList(recipeArray)
	if nil == recipeArray or {} == recipeArray or not recipeArray.origin == FURC_CRAFTING then 
		return "FurC.GetCrafterList called for a non-craftable"
	end
	if nil == recipeArray.characters or {} == recipeArray.characters then 
		return FURC_STRING_CANNOT_CRAFT
	end
	local ret = FURC_STRING_CRAFTABLE_BY
	for characterName, characterKnowledge in pairs(recipeArray.characters) do
		ret = zo_strformat("<<1>> <<2>>, ", ret, characterName)
	end
	return ret:sub(0, -3)
end

function FurC.GetItemDescription(recipeKey, recipeArray)
	recipeArray = recipeArray or FurC.Find(recipeKey, recipeArray)
	if not recipeArray then return "" end
	local origin = recipeArray.origin
	if origin == FURC_CRAFTING then
		return FurC.GetMats(recipeKey, recipeArray)
	elseif origin == FURC_ROLLIS then
		return FurC.getRollisSource(recipeKey, recipeArray)
	elseif origin == FURC_LUXURY then
		return FurC.getLuxurySource(recipeKey, recipeArray)	
	elseif origin == FURC_GUILDSTORE then
		return FURC_STRING_TRADINGHOUSE
	elseif origin == FURC_VENDOR then
		return FurC.getAchievementVendorSource(recipeKey, recipeArray)
	elseif origin == FURC_VENDOR_FESTIVAL then
		return FurC.getFestivalVendorSource(recipeKey, recipeArray)
	elseif origin == FURC_PVP then
		return FurC.getPvpSource(recipeKey, recipeArray)
	elseif origin == FURC_RUMOUR then
		
		return FurC.getRumourSource(recipeKey, recipeArray)
	else 
		itemSource = FurC.GetMiscItemSource(recipeKey, recipeArray)
	end
	return itemSource or "couldn't find a source: " .. tostring(recipeArray.origin)
end