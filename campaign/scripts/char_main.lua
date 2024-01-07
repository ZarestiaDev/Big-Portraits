-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	onLevelChanged();
	DB.addHandler(DB.getPath(getDatabaseNode(), "classes"), "onChildUpdate", onLevelChanged);
	
	onPCTypeChanged();
	onHealthChanged();
end

function onClose()
	DB.removeHandler(DB.getPath(getDatabaseNode(), "classes"), "onChildUpdate", onLevelChanged);
end

function onLevelChanged()
	CharManager.calcLevel(getDatabaseNode());
	
	CharManager.recalcProficiencies(getDatabaseNode());
end

function onPCTypeChanged()
	local nodeChar = getDatabaseNode();
	local sPCType = CharManager.getPCType(nodeChar);
	
	GlobalDebug.consoleObjects("char_main.lua - onPCTypeChanged. nodeChar, sPCType = ", nodeChar, sPCType);
	
	local bLinkedPC = false;
	
	if sPCType == "eidolon" then
		bLinkedPC = true;
	end
	
	hp.setVisible(not bLinkedPC);
	hp.setEnabled(not bLinkedPC);
	hp_label.setVisible(not bLinkedPC);
	wounds.setVisible(not bLinkedPC);
	wounds_label.setVisible(not bLinkedPC);
	hptemp.setVisible(not bLinkedPC);
	hptemp_label.setVisible(not bLinkedPC);
	current.setVisible(not bLinkedPC);
	current.setEnabled(not bLinkedPC);
	current_label.setVisible(not bLinkedPC);
	wounded.setVisible(not bLinkedPC);
	wounded_label.setVisible(not bLinkedPC);
	dying.setVisible(not bLinkedPC);
	dying_label.setVisible(not bLinkedPC);
	
	if bLinkedPC then
		hp.destroy();
		hp_label.destroy();
		wounds.destroy();
		wounds_label.destroy();
		hptemp.destroy();
		hptemp_label.destroy();
		current.destroy();
		current_label.destroy();
		wounded.destroy();
		wounded_label.destroy();
		dying.destroy();
		dying_label.destroy();
	end
	
	hp_linked.setVisible(bLinkedPC);
	hp_linked.setEnabled(bLinkedPC);
	hp_linked_label.setVisible(bLinkedPC);
	wounds_linked.setVisible(bLinkedPC);
	wounds_linked_label.setVisible(bLinkedPC);
	hptemp_linked.setVisible(bLinkedPC);
	hptemp_linked_label.setVisible(bLinkedPC);
	current_linked.setVisible(bLinkedPC);
	current_linked.setEnabled(bLinkedPC);
	current_linked_label.setVisible(bLinkedPC);
	wounded_linked.setVisible(bLinkedPC);
	wounded_linked_label.setVisible(bLinkedPC);
	dying_linked.setVisible(bLinkedPC);
	dying_linked_label.setVisible(bLinkedPC);
	button_hpdetails.setVisible(not bLinkedPC);
	
	parentcontrol.window.overview.subwindow.ancestryframe.setVisible(not bLinkedPC);
	parentcontrol.window.overview.subwindow.racelink.setVisible(not bLinkedPC);
	parentcontrol.window.overview.subwindow.race.setVisible(not bLinkedPC);
	parentcontrol.window.overview.subwindow.backgroundframe.setVisible(not bLinkedPC);
	parentcontrol.window.overview.subwindow.backgroundlink.setVisible(not bLinkedPC);
	parentcontrol.window.overview.subwindow.background.setVisible(not bLinkedPC);
	parentcontrol.window.overview.subwindow.button_classlevel.setVisible(not bLinkedPC);
		
	if sPCType == "eidolon" then
		local tLinkedPCs = LinkedPCManager.getBaseLinkedPCs(nodeChar);
		GlobalDebug.consoleObjects("char_main.lua - onPCTypeChanged. tLinkedPCs = ", tLinkedPCs);
		if tLinkedPCs ~= {} then
			-- We could have multiple linked PCs.  This won't work properly if that is the case.  Use the first linked PC as the base PC.
			local sBaseLinkedPCNodeName = tLinkedPCs[1];
			GlobalDebug.consoleObjects("char_main.lua - onPCTypeChanged. sBaseLinkedPCNodeName = ", sBaseLinkedPCNodeName);
			if (sBaseLinkedPCNodeName or "") ~= "" then
				local nodeBaseChar = DB.findNode(sBaseLinkedPCNodeName);
				if nodeBaseChar then
					LinkedPCManager.syncEidolonHP(nodeBaseChar);
				end
			end
		end
	end
end

function onHealthChanged()
	local rActor = ActorManager.resolveActor(getDatabaseNode());
	local sColor = ActorHealthManager.getHealthColor(rActor);
	local nodeChar = getDatabaseNode();
	local sPCType = CharManager.getPCType(nodeChar);
	
	if sPCType == "eidolon" then
		wounds_linked.setColor(sColor);
		current_linked.setColor(sColor);	
	else
		wounds.setColor(sColor);
		current.setColor(sColor);	
	end
end
