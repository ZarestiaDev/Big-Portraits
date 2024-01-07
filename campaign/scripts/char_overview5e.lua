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

function onDrop(x, y, draginfo)
    if draginfo.isType("shortcut") then
        local sClass, sRecord = draginfo.getShortcutData();

        if StringManager.contains({"reference_class", "reference_race", "reference_subrace", "reference_background"}, sClass) then
            CharManager.addInfoDB(getDatabaseNode(), sClass, sRecord);
            return true;
        end
    end
end

function onHealthChanged()
    local sColor = ActorManager5E.getPCSheetWoundColor(getDatabaseNode());
    wounds.setColor(sColor);
end
