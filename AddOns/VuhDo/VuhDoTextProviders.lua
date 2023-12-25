local floor = floor;
local UnitPower = UnitPower;
local UnitPowerMax = UnitPowerMax;

local VUHDO_getIncHealOnUnit;
local VUHDO_getUnitOverallShieldRemain;

function VUHDO_textProvidersInitLocalOverrides()
	VUHDO_getIncHealOnUnit = _G["VUHDO_getIncHealOnUnit"];
	VUHDO_getUnitOverallShieldRemain = _G["VUHDO_getUnitOverallShieldRemain"];
end



--
local tChiCount;
local tChiMax;
local function VUHDO_chiCalculator(anInfo)
	if anInfo["connected"] and not anInfo["dead"] then
		tChiCount = UnitPower(anInfo["unit"], VUHDO_UNIT_POWER_CHI);
		tChiMax = UnitPowerMax(anInfo["unit"], VUHDO_UNIT_POWER_CHI);

		return (tChiCount > 0) and tChiCount or "", (tChiMax > 0) and tChiMax or "";
	else
		return "", nil;
	end
end



--
local tHolyPowerCount;
local tHolyPowerMax;
local function VUHDO_holyPowerCalculator(anInfo)
	if anInfo["connected"] and not anInfo["dead"] then
		tHolyPowerCount = UnitPower(anInfo["unit"], VUHDO_UNIT_POWER_HOLY_POWER);
		tHolyPowerMax = UnitPowerMax(anInfo["unit"], VUHDO_UNIT_POWER_HOLY_POWER);

		return (tHolyPowerCount > 0) and tHolyPowerCount or "", (tHolyPowerMax > 0) and tHolyPowerMax or "";
	else
		return "", nil;
	end
end



--
local tComboPointsCount;
local tComboPointsMax;
local function VUHDO_comboPointsCalculator(anInfo)
	if anInfo["connected"] and not anInfo["dead"] then
		tComboPointsCount = UnitPower(anInfo["unit"], VUHDO_UNIT_POWER_COMBO_POINTS);
		tComboPointsMax = UnitPowerMax(anInfo["unit"], VUHDO_UNIT_POWER_COMBO_POINTS);

		return (tComboPointsCount > 0) and tComboPointsCount or "", (tComboPointsMax > 0) and tComboPointsMax or "";
		
	else
		return "", nil;
	end
end



--
local tSoulShardsCount;
local tSoulShardsMax;
local function VUHDO_soulShardsCalculator(anInfo)
	if anInfo["connected"] and not anInfo["dead"] then
		tSoulShardsCount = UnitPower(anInfo["unit"], VUHDO_UNIT_POWER_SOUL_SHARDS);
		tSoulShardsMax = UnitPowerMax(anInfo["unit"], VUHDO_UNIT_POWER_SOUL_SHARDS);

		return (tSoulShardsCount > 0) and tSoulShardsCount or "", (tSoulShardsMax > 0) and tSoulShardsMax or "";
	else
		return "", nil;
	end
end



--
local tReadyRuneCount;
local tReadyRuneMax;
local tIsRuneReady;
local function VUHDO_runesCalculator(anInfo)
	if anInfo["connected"] and not anInfo["dead"] and anInfo["unit"] == "player" then
		tReadyRuneCount = 0;

		for i = 1, 6 do
			_, _, tIsRuneReady = GetRuneCooldown(i);

			tReadyRuneCount = tReadyRuneCount + (tIsRuneReady and 1 or 0);
		end

		tReadyRuneMax = UnitPowerMax(anInfo["unit"], VUHDO_UNIT_POWER_RUNES);

		return (tReadyRuneCount > 0) and tReadyRuneCount or "", (tReadyRuneMax > 0) and tReadyRuneMax or "";
	else
		return "", nil;
	end
end



--
local tArcaneChargesCount;
local tArcaneChargesMax;
local function VUHDO_arcaneChargesCalculator(anInfo)
	if anInfo["connected"] and not anInfo["dead"] then
		tArcaneChargesCount = UnitPower(anInfo["unit"], VUHDO_UNIT_POWER_ARCANE_CHARGES);
		tArcaneChargesMax = UnitPowerMax(anInfo["unit"], VUHDO_UNIT_POWER_ARCANE_CHARGES);

		return (tArcaneChargesCount > 0) and tArcaneChargesCount or "", (tArcaneChargesMax > 0) and tArcaneChargesMax or "";
	else
		return "", nil;
	end
end



--
local tAmountInc;
local function VUHDO_overhealCalculator(anInfo)
	tAmountInc = VUHDO_getIncHealOnUnit(anInfo["unit"]);
	if tAmountInc > 0 and anInfo["connected"] and not anInfo["dead"] then
		return tAmountInc - anInfo["healthmax"] + anInfo["health"], nil;
	else
		return 0, nil;
	end
end


--
local tAmountInc;
local function VUHDO_incomingHealCalculator(anInfo)
	tAmountInc = VUHDO_getIncHealOnUnit(anInfo["unit"]);
	if tAmountInc > 0 and anInfo["connected"] and not anInfo["dead"] then
		return tAmountInc, nil;
	else
		return 0, nil;
	end
end


--
local function VUHDO_shieldAbsorbCalculator(anInfo)
	return VUHDO_getUnitOverallShieldRemain(anInfo["unit"]), nil;
end


--
local function VUHDO_manaCalculator(anInfo)
	if anInfo["powertype"] == 0 and anInfo["powermax"] > 0 then
		return anInfo["power"], anInfo["powermax"]
	else
		return 0, 0;
	end
end


--
local function VUHDO_threatCalculator(anInfo)
	return anInfo["threatPerc"], 100;
end



------------------------------------------------------------------



--
local function VUHDO_kiloValidator(anInfo, aValue)
	
	if aValue > 100 then
		return VUHDO_round(aValue * 0.001, 1) or "";
	else
		return "";
	end

end


local function VUHDO_plusKiloValidator(anInfo, aValue)

	if aValue >= 1000000 then
		return format("+%.1fM", aValue * 0.000001) or "";
	elseif aValue > 100 then
		return format("+%.1fk", VUHDO_round(aValue * 0.001, 1)) or "";
	elseif aValue > 0 then
		return format("+%d", aValue) or "";
	else
		return "";
	end

end

--
local function VUHDO_percentValidator(anInfo, aValue, aMaxValue)
	return anInfo["powertype"] == 0 and anInfo["powermax"] > 0
		and format("%d%%", 100 * aValue / aMaxValue) or "";
end

--
local function VUHDO_tenthPercentValidator(anInfo, aValue, aMaxValue)
	return anInfo["powertype"] == 0 and anInfo["powermax"] > 0
		and format("%d", 10 * aValue / aMaxValue) or "";
end


local function VUHDO_unitOfUnitValidator(anInfo, aValue, aMaxValue)
	return anInfo["powertype"] == 0 and format("%d/%d", aValue, aMaxValue) or "";
end

--
local function VUHDO_kiloOfKiloValidator(anInfo, aValue, aMaxValue)
	return anInfo["powertype"] == 0
		and format("%d/%d", floor(aValue * 0.001), floor(aMaxValue * 0.001)) or "";
end

--
local function VUHDO_absoluteValidator(anInfo, aValue)
	return aValue;
end



---------------------------------------------------------------------------------

function VUHDO_initTextProviderConfig()
  -- Falls man mal was l�scht oder umbenennt
	for tIndicatorName, anIndicatorConfig in pairs(VUHDO_INDICATOR_CONFIG["TEXT_INDICATORS"]) do
		for tIndex, tProviderName in pairs(anIndicatorConfig["TEXT_PROVIDER"]) do
			if not VUHDO_TEXT_PROVIDERS[tProviderName] then
				anIndicatorConfig["TEXT_PROVIDER"][tIndex] = "";
			end
		end
	end
end

------------------------------------------------------------------------------------



VUHDO_TEXT_PROVIDERS = {
	["OVERHEAL_KILO_N_K"] = {
		["displayName"] = "過量治療: <#nk>",
		["calculator"] = VUHDO_overhealCalculator,
		["validator"] = VUHDO_kiloValidator,
		["interests"] = { VUHDO_UPDATE_INC, VUHDO_UPDATE_HEALTH, VUHDO_UPDATE_RANGE, VUHDO_UPDATE_HEALTH_MAX, VUHDO_UPDATE_ALIVE, VUHDO_UPDATE_HEALTH_COMBAT_LOG },
	},
	["OVERHEAL_KILO_PLUS_N_K"] = {
		["displayName"] = "過量治療: +<#n>k",
		["calculator"] = VUHDO_overhealCalculator,
		["validator"] = VUHDO_plusKiloValidator,
		["interests"] = { VUHDO_UPDATE_INC, VUHDO_UPDATE_HEALTH, VUHDO_UPDATE_RANGE, VUHDO_UPDATE_HEALTH_MAX, VUHDO_UPDATE_ALIVE, VUHDO_UPDATE_HEALTH_COMBAT_LOG },
	},
	["INCOMING_HEAL_NK"] = {
		["displayName"] = "即將治療: <#nk>",
		["calculator"] = VUHDO_incomingHealCalculator,
		["validator"] = VUHDO_kiloValidator,
		["interests"] = { VUHDO_UPDATE_INC, VUHDO_UPDATE_HEALTH, VUHDO_UPDATE_RANGE, VUHDO_UPDATE_HEALTH_MAX, VUHDO_UPDATE_ALIVE, VUHDO_UPDATE_HEALTH_COMBAT_LOG },
	},
	["SHIELD_ABSORB_OVERALL_N_K"] = {
		["displayName"] = "護盾吸收總量: <#nk>",
		["calculator"] = VUHDO_shieldAbsorbCalculator,
		["validator"] = VUHDO_kiloValidator,
		["interests"] = { VUHDO_UPDATE_SHIELD },
	},
	["THREAT_PERCENT"] = {
		["displayName"] = "仇恨值: <#n>%",
		["calculator"] = VUHDO_threatCalculator,
		["validator"] = VUHDO_percentValidator,
		["interests"] = { VUHDO_UPDATE_THREAT_PERC },
	},
	["CHI_N"] = {
		["displayName"] = "真氣: <#n>",
		["calculator"] = VUHDO_chiCalculator,
		["validator"] = VUHDO_absoluteValidator,
		["interests"] = { VUHDO_UPDATE_CHI, VUHDO_UPDATE_DC, VUHDO_UPDATE_ALIVE },
	},
	["HOLY_POWER_N"] = {
		["displayName"] = "聖能: <#n>",
		["calculator"] = VUHDO_holyPowerCalculator,
		["validator"] = VUHDO_absoluteValidator,
		["interests"] = { VUHDO_UPDATE_OWN_HOLY_POWER, VUHDO_UPDATE_DC, VUHDO_UPDATE_ALIVE },
	},
	["COMBO_POINTS_N"] = {
		["displayName"] = "連擊點數: <#n>",
		["calculator"] = VUHDO_comboPointsCalculator,
		["validator"] = VUHDO_absoluteValidator,
		["interests"] = { VUHDO_UPDATE_COMBO_POINTS, VUHDO_UPDATE_DC, VUHDO_UPDATE_ALIVE },
	},
	["SOUL_SHARDS_N"] = {
		["displayName"] = "靈魂裂片: <#n>",
		["calculator"] = VUHDO_soulShardsCalculator,
		["validator"] = VUHDO_absoluteValidator,
		["interests"] = { VUHDO_UPDATE_SOUL_SHARDS, VUHDO_UPDATE_DC, VUHDO_UPDATE_ALIVE },
	},
	["RUNES_N"] = {
		["displayName"] = "符文: <#n>",
		["calculator"] = VUHDO_runesCalculator,
		["validator"] = VUHDO_absoluteValidator,
		["interests"] = { VUHDO_UPDATE_RUNES, VUHDO_UPDATE_DC, VUHDO_UPDATE_ALIVE },
	},
	["ARCANE_CHARGES_N"] = {
		["displayName"] = "祕法充能: <#n>",
		["calculator"] = VUHDO_arcaneChargesCalculator,
		["validator"] = VUHDO_absoluteValidator,
		["interests"] = { VUHDO_UPDATE_ARCANE_CHARGES, VUHDO_UPDATE_DC, VUHDO_UPDATE_ALIVE },
	},
	["MANA_PERCENT"] = {
		["displayName"] = "法力: <#n>%",
		["calculator"] = VUHDO_manaCalculator,
		["validator"] = VUHDO_percentValidator,
		["interests"] = { VUHDO_UPDATE_MANA, VUHDO_UPDATE_DC },
	},
	["MANA_PERCENT_TENTH"] = {
		["displayName"] = "法力: <#n/10%>",
		["calculator"] = VUHDO_manaCalculator,
		["validator"] = VUHDO_tenthPercentValidator,
		["interests"] = { VUHDO_UPDATE_MANA, VUHDO_UPDATE_DC },
	},
	["MANA_UNIT_OF_UNIT"] = {
		["displayName"] = "法力: <#n>/<#n>",
		["calculator"] = VUHDO_manaCalculator,
		["validator"] = VUHDO_unitOfUnitValidator,
		["interests"] = { VUHDO_UPDATE_MANA, VUHDO_UPDATE_DC },
	},
	["MANA_KILO_OF_KILO"] = {
		["displayName"] = "法力: <#nk>/<#nk>",
		["calculator"] = VUHDO_manaCalculator,
		["validator"] = VUHDO_kiloOfKiloValidator,
		["interests"] = { VUHDO_UPDATE_MANA, VUHDO_UPDATE_DC },
	},
	["MANA_N"] = {
		["displayName"] = "法力: <#n>",
		["calculator"] = VUHDO_manaCalculator,
		["validator"] = VUHDO_absoluteValidator,
		["interests"] = { VUHDO_UPDATE_MANA, VUHDO_UPDATE_DC },
	},
	["MANA_NK"] = {
		["displayName"] = "法力: <#nk>",
		["calculator"] = VUHDO_manaCalculator,
		["validator"] = VUHDO_kiloValidator,
		["interests"] = { VUHDO_UPDATE_MANA, VUHDO_UPDATE_DC },
	},
}