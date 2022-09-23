function onInit()
    if super and super.onInit then
        super.onInit();
    end
end

function onClose()
    if super and super.onClose then
        super.onClose();
    end
end

function onDrop(x, y, draginfo)
	if draginfo.isType("shortcut") then
		local sClass, sRecord = draginfo.getShortcutData();
		if StringManager.contains({"referenceclass", "referencerace", "reference_background", "referencefeat", "referenceclassability", "referenceracialtrait", "reference_lookupdata"}, sClass) then
			CharManager.addInfoDB(getDatabaseNode(), sClass, sRecord);
			return true;
		end
	end
end