-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	OptionsManager.registerCallback("HRIS", onHRISOptionChanged);
	onHRISOptionChanged();
end
function onClose()
	OptionsManager.unregisterCallback("HRIS", onHRISOptionChanged);
end

function onHRISOptionChanged()
	local sOptHRIS = OptionsManager.getOption("HRIS");
	local nOptHRIS = math.min(math.max(tonumber(sOptHRIS) or 1, 1), 3);
	
	if inspiration.getMaxValue() ~= nOptHRIS then
		inspiration.setMaxValue(nOptHRIS);
		inspiration.updateSlots();
	end
	inspiration.setAnchor("left", "inspirationtitle", "center", "absolute", -5 * nOptHRIS);
end

-- Zarestia adding code from char_main

function onInit()
	self.onXPChanged();
	self.onBackgroundChanged();
	self.onSpeciesChanged();
	CharManager.refreshNextLevelXP(getDatabaseNode());
end
function onDrop(x, y, draginfo)
	if draginfo.isType("shortcut") then
		local sClass, sRecord = draginfo.getShortcutData();
		if StringManager.contains({ "reference_class", "reference_race", "reference_subrace", "reference_background", "reference_feat", }, sClass) then
			return CharBuildDropManager.addInfoDB(getDatabaseNode(), sClass, sRecord);
		end
	end
end
function onHealthChanged()
	wounds.setColor(ActorManager5E.getPCSheetWoundColor(getDatabaseNode()));
end
function onXPChanged()
	local nLevel = level.getValue();
	local nXPNeeded = expneeded.getValue();
	local nXP = exp.getValue();
	local bShowLevelAdd = ((nLevel == 0) or ((nXPNeeded > 0) and (nXP >= nXPNeeded)));
	button_classlevel_add.setVisible(bShowLevelAdd);
end
function onBackgroundChanged()
	button_background_add.setVisible(background.isEmpty());
end
function onSpeciesChanged()
	button_species_add.setVisible(race.isEmpty());
end
