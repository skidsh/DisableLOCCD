function ActionButton_UpdateCooldown_Hooked(self)
	local locStart, locDuration;
	local start, duration, enable, charges, maxCharges, chargeStart, chargeDuration;
	local modRate = 1.0;
	local chargeModRate = 1.0;
	if ( self.spellID ) then
		locStart, locDuration = 0, 0;
		start, duration, enable, modRate = GetSpellCooldown(self.spellID);
		charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(self.spellID);
	else
		locStart, locDuration = 0, 0;
		start, duration, enable, modRate = GetActionCooldown(self.action);
		charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(self.action);
	end

	if ( (locStart + locDuration) > (start + duration) ) then
		if ( self.cooldown.currentCooldownType ~= COOLDOWN_TYPE_LOSS_OF_CONTROL ) then
			self.cooldown:SetEdgeTexture("Interface\\Cooldown\\edge-LoC");
			self.cooldown:SetSwipeColor(0.17, 0, 0);
			self.cooldown:SetHideCountdownNumbers(true);
			self.cooldown.currentCooldownType = COOLDOWN_TYPE_LOSS_OF_CONTROL;
		end

		CooldownFrame_Set(self.cooldown, locStart, locDuration, true, true, modRate);
		ClearChargeCooldown(self);
	else
		if ( self.cooldown.currentCooldownType ~= COOLDOWN_TYPE_NORMAL ) then
			self.cooldown:SetEdgeTexture("Interface\\Cooldown\\edge");
			self.cooldown:SetSwipeColor(0, 0, 0);
			self.cooldown:SetHideCountdownNumbers(false);
			self.cooldown.currentCooldownType = COOLDOWN_TYPE_NORMAL;
		end

		if( locStart > 0 ) then
			self.cooldown:SetScript("OnCooldownDone", ActionButtonCooldown_OnCooldownDone);
		end

		if ( charges and maxCharges and maxCharges > 1 and charges < maxCharges ) then
			StartChargeCooldown(self, chargeStart, chargeDuration, chargeModRate);
		else
			ClearChargeCooldown(self);
		end

		CooldownFrame_Set(self.cooldown, start, duration, enable, false, modRate);
	end
end

hooksecurefunc("ActionButton_UpdateCooldown", ActionButton_UpdateCooldown_Hooked);