local function getCrownStorePriceString(price)
    return string.format("%s (%u)", GetString(SI_FURC_CROWNSTORESOURCE), price)
end

FurC.MiscItemSources[FURC_WEREWOLF] = FurC.MiscItemSources[FURC_WEREWOLF] or {}
FurC.MiscItemSources[FURC_WEREWOLF][FURC_RUMOUR] = {  
    [141824] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Vines, Sun-Bronzed Ivy Cluster",
    [141825] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Relic Vault, Impenetrable",
    [141826] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Alinor Bed, Levitating",
    [141827] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Alinor Bookshelf, Grand Full",
    [141828] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Alinor Gaming Table, Punctilious Conflict",
    [141829] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Artist's Palette, Pigment",
    [141830] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Alinor Grape Stomping Tub",
    [141831] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Figurine, The Dragon's Glare",
    [141832] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Tree, Robust Fig",
    [141833] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Tree, Ancient Fig",
    [141834] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Tree, Towering Fig",
    [141835] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Tree, Whorled Fig",
    [141836] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Monolith, Lord Hircine Ritual",
    [141837] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Obelisk, Lord Hircine Ritual",
    [141838] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Ritual Stone, Hircine",
    [141839] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Sacrificial Altar, Hircine",
    [141841] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Tree Ferns, Cluster",
    [141842] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Tree Ferns, Juvenile Cluster",
    [141843] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Plants, Yellow Frond Cluster",
    [141844] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Plants, Amber Spadeleaf Cluster",
    [141845] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Mushrooms, Climbing Ambershine",
    [141846] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Mushrooms, Ambershine Cluster",
    [141847] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Animal Bones, Gnawed",
    [141848] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Animal Bones, Jumbled",
    [141849] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Animal Bones, Fresh",
    [141850] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Bear Skeleton, Picked Clean",
    [141851] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Bear Skull, Fresh",
    [141852] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Ritual Fetish, Hircine",
    [141853] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Statue of Hircine's Bitter Mercy",
    [141854] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Decorative Hollowjack Flame-Skull",
    [141855] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Decorative Hollowjack Wraith-Lantern",
    [141856] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Decorative Hollowjack Daedra-Skull",
    [141857] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Ritual Chalice, Hircine",
    [141869] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Alinor Potted Plant, Cypress",
    [141870] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Raven-Perch Cemetery Wreath",
    [141875] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Witches Festival Scarecrow",
    [142004] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Specimen Jar, Spare Brain",
    [142005] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Specimen Jar, Monstrous Remains",
    [141752] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Plant, Cerulean Spadeleaf",
    [141753] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Plants, Cerulean Spadeleaf Cluster",
    [141754] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Skull Totem, Hircine Worship",
    [141755] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Mushrooms, Aether Cup Ring",
    [141756] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Mushrooms, Aether Cup Cluster",
    [141757] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Mushrooms, Climbing Aether Cup",
    [141758] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Orcish Wagon, Merchant",
    [141759] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Orcish Gazebo, Orsinium",
    [141760] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Witch's Tree, Charred",
    [141761] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Reach Sapling, Contorted Briarheart",
    [141762] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Animal Trap, Welded Open",
    [141763] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Banner, Outfit",
    [141764] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Banner, Outfit Small",
    [141765] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Banner, Transmute",
    [141766] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Banner, Transmute Small",
    [141767] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Ayleid Constellation Stele, The Lady",
    [141778] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Target Wraith-of-Crows",
    [141920] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Murkmire Brazier, Ceremonial",
    [141921] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Murkmire Bowl, Geometric Pattern",
    [141922] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Murkmire Dish, Geometric Pattern",
    [141923] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Murkmire Amphora, Seed Pattern",
    [141924] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Murkmire Vase, Scale Pattern",
    [141925] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Murkmire Hearth Shrine, Sithis Relief",
    [141926] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Murkmire Hearth Shrine, Sithis Figure",
    [142003] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Specimen Jar, Eyes",
    [141939] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Grave, Grasping",
    [141976] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Pumpkin Patch, Display",
    [141967] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Hollowjack Lantern, Ouroboros",
    [141966] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Hollowjack Lantern, Toothy Grin",
    [141965] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Hollowjack Lantern, Soaring Dragon",
    [141816] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Tree, Ginkgo",
    [141817] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Tree, Ancient Ginkgo",
    [141818] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Shrubs, Dormant Sunbird Cluster",
    [141819] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Shrub, Blooming Sunbird",
    [141768] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Ayleid Constellation Stele, The Lover",
    [141822] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Psijic Banner, Long",
    [141769] = GetString(SI_FURC_ITEMSOURCE_UNKNOWN_YET), -- Ayleid Constellation Stele, The Atronach",
   
        
}

FurC.AchievementVendors[FURC_WEREWOLF] = {
	["the Undaunted Enclaves"] = {
		["Undaunted Quartermaster"] = {
			[141858] = {        --Banner of the Silver Dawn
                itemPrice   = 15000,
                achievement = 2152,
            },
            [141857] = {        --Ritual Chalice, Hircine
                itemPrice   = 5000,
                achievement = 2162,
            },

		},
	},
}


FurC.EventItems[FURC_WEREWOLF] = {}


FurC.Books[FURC_WEREWOLF] = {}


