﻿-------------------------------------------------------------------------------
--  Module Declaration

local mod = BigWigs:NewBoss("Zuramat the Obliterator", "The Violet Hold")
if not mod then return end
mod.partyContent = true
mod.otherMenu = "Dalaran"
mod:RegisterEnableMob(29314, 32230)
mod.defaultToggles = {"MESSAGE"}
mod.toggleOptions = {
	54361, -- Void Shift
	"bosskill",
}

-------------------------------------------------------------------------------
--  Locals

local pName = UnitName("player")

-------------------------------------------------------------------------------
--  Localization

L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")

-------------------------------------------------------------------------------
--  Initialization

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "VoidShift", 54361, 59743)
	self:Death("Win", 29314, 3223)
end

-------------------------------------------------------------------------------
--  Event Handlers

function mod:VoidShift(player, spellId, _, _, spellName)
	if player ~= pName then return end
	self:LocalMessage(54361, BLC["you"]:format(spellName), "Personal", true, "Alert", nil, spellId)
end
