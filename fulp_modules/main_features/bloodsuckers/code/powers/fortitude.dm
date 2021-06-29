/datum/action/bloodsucker/fortitude
	name = "Fortitude"
	desc = "Withstand egregious physical wounds and walk away from attacks that would stun, pierce, and dismember lesser beings. You cannot run while active."
	button_icon_state = "power_fortitude"
	bloodcost = 30
	cooldown = 80
	bloodsucker_can_buy = TRUE
	vassal_can_buy = TRUE
	amToggle = TRUE
	warn_constant_cost = TRUE
	can_use_in_torpor = TRUE
	var/was_running
	var/fortitude_resist // So we can raise and lower your brute resist based on what your level_current WAS.

/datum/action/bloodsucker/fortitude/ActivatePower(mob/living/user = owner)
	to_chat(user, "<span class='notice'>Your flesh, skin, and muscles become as steel.</span>")
	// Traits & Effects
	ADD_TRAIT(user, TRAIT_PIERCEIMMUNE, BLOODSUCKER_TRAIT)
	ADD_TRAIT(user, TRAIT_NODISMEMBER, BLOODSUCKER_TRAIT)
	ADD_TRAIT(user, TRAIT_PUSHIMMUNE, BLOODSUCKER_TRAIT)
	if(level_current >= 4)
		ADD_TRAIT(user, TRAIT_STUNIMMUNE, BLOODSUCKER_TRAIT) // They'll get stun resistance + this, who cares.
	var/mob/living/carbon/human/H = owner
	if(IS_BLOODSUCKER(owner) || IS_VASSAL(owner))
		fortitude_resist = max(0.3, 0.7 - level_current * 0.1)
		H.physiology.brute_mod *= fortitude_resist
		H.physiology.stamina_mod *= fortitude_resist
	if(IS_MONSTERHUNTER(owner))
		H.physiology.brute_mod *= 0.4
		H.physiology.burn_mod *= 0.4
		ADD_TRAIT(user, TRAIT_STUNIMMUNE, BLOODSUCKER_TRAIT)

	was_running = (user.m_intent == MOVE_INTENT_RUN)
	if(was_running)
		user.toggle_move_intent()
	. = ..()

/datum/action/bloodsucker/fortitude/UsePower(mob/living/carbon/user)
	// Checks that we can keep using this.
	if(!..())
		return
	/// Prevents running while on Fortitude
	if(user.m_intent != MOVE_INTENT_WALK)
		user.toggle_move_intent()
		to_chat(user, "<span class='warning'>You attempt to run, crushing yourself in the process.</span>")
		user.adjustBruteLoss(rand(5,15))
	/// We don't want people using fortitude being able to use vehicles
	if(user.buckled && istype(user.buckled, /obj/vehicle))
		user.buckled.unbuckle_mob(src, force=TRUE)
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = IS_BLOODSUCKER(user)
	if(IS_BLOODSUCKER(owner))
		/// Pay Blood Toll (if awake)
		if(user.stat == CONSCIOUS)
			bloodsuckerdatum.AddBloodVolume(-0.5)

	addtimer(CALLBACK(src, .proc/UsePower, user), 2 SECONDS)

/datum/action/bloodsucker/fortitude/DeactivatePower(mob/living/user = owner)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(IS_BLOODSUCKER(owner) || IS_VASSAL(owner))
		H.physiology.brute_mod /= fortitude_resist
		if(!HAS_TRAIT_FROM(user, TRAIT_STUNIMMUNE, BLOODSUCKER_TRAIT))
			H.physiology.stamina_mod /= fortitude_resist
	if(IS_MONSTERHUNTER(owner))
		H.physiology.brute_mod /= 0.4
		H.physiology.burn_mod /= 0.4
	// Remove Traits & Effects
	REMOVE_TRAIT(user, TRAIT_PIERCEIMMUNE, BLOODSUCKER_TRAIT)
	REMOVE_TRAIT(user, TRAIT_NODISMEMBER, BLOODSUCKER_TRAIT)
	REMOVE_TRAIT(user, TRAIT_PUSHIMMUNE, BLOODSUCKER_TRAIT)
	REMOVE_TRAIT(user, TRAIT_STUNIMMUNE, BLOODSUCKER_TRAIT)

	if(was_running && user.m_intent == MOVE_INTENT_WALK)
		user.toggle_move_intent()
	return ..()

/// Monster Hunter version
/datum/action/bloodsucker/fortitude/hunter
	name = "Flow"
	desc = "Use the arts to Flow, giving shove and stun immunity, as well as brute, burn, dismember and pierce resistance. You cannot run while this is active."
	bloodsucker_can_buy = FALSE
