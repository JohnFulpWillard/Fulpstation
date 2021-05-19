/* 		Getting Flaws:
 *
 *	Killing crew
 *
 *	Gaining ranks
 *
 *
 *
 * 			* COMPULSION *  	Things you must do
 *
 *	SELECTIVE:		-Gender/BloodType/Job sustains you, but others give you less.
 *
 *
 *
 *
 * 			* WEAKNESSES *  	Things that may harm you
 *
 *	LIGHTS:			-Bright light nullifies the Examine benefits of Masquerade.
 *  				-Bright lights disable your healing (including in Torpor)
 *
 *	STAKES:			-Stakes kill you immediately.
 *
 *	PAINFUL:		-Your feed victims scream, despite being unconscious.
 *
 *	FIRE:			-You only need your max health (not x2) in fire damage to die.
 *
 *	CORPSE:			-Your Masquerade turns off when unconscious or crit.
 *
 *	FERAL:			-
 *
 *	CRAVEN
 *
 *
 *			// BANES //
 *
 *	These are basically small weaknesses that affect your character in certain circumstances.
 *  As a rule, they should be specific as to when they happen, or have only some certain
 *  drawback.
 *
 * (core ideas)
 * SENSITIVE: 	You are slightly blinded by bright lights.
 * DARKFRIEND: 	Your automatic healing is at a crawl when in bright light.
 * TRADITIONAL:	Every five minutes spent outside a coffin lowers your rate of automatic healing.
 * CONSUMED:	Every five minutes spent outside a coffin increases the rate at which your blood ticks down.
 * GOURMAND:	Animals and blood bags offer you no nourishment when feeding.
 * DEATHMASK:	You no longer fake having a heartbeat, and always show up as pale when examined.
 * BESTIAL:		When your blood is low, you will twitch involuntarily.
 *
 * (alternate ideas)
 * STERILE:		There is a high chance that turning corpses to Bloodsuckers will fail, and further attempts on them by you are impossible.
 * FERAL:		You're a threat to Vampire-kind: New Bloodsuckers may have an Objective to destroy you.
 * UNHOLY:		The Chapel, the Bible, and Holy Water set you on fire.
 * PARANOID:	Only your own claimed coffin counts for healing and banes.
 *
 *
 * 	ON LEVEL-UP:
 * Burn Damage increases
 * Regen Rate increases
 * Max Punch Damage increase
 * Reset Level Timer
 * Select Bane
 *
 *
 * How to Burn Vamps:
 *		C.adjustFireLoss(20)
 *		C.adjust_fire_stacks(6)
 *		C.IgniteMob()
 */

/datum/antagonist/bloodsucker/proc/AssignRandomBane(my_clan)
	if(!my_clan)
		to_chat(owner, "<span class='warning'>You have not been assigned to a Clan.</span>")
		return
	switch(my_clan)
		if(CLAN_BRUJAH)
			to_chat(owner, "<span class='announce'>You have Ranked up enough to learn: You are part of the Brujah Clan!<br> \
				* As part of the Bujah Clan, you are more prone to falling into Frenzy, don't let your blood drop too low!</span>")
		if(CLAN_NOSFERATU)
			for(var/datum/action/bloodsucker/power in powers)
				if(istype(power, /datum/action/bloodsucker/masquerade))
					powers -= power
					power.Remove(owner.current)
			to_chat(owner, "<span class='announce'>You have Ranked up enough to learn: You are part of the Nosferatu Clan!<br> \
				* As part of the Nosferatu Clan, you are less interested in disguising yourself within the crew, as such you do not know how to use the Masquerade ability.</span>")
		if(CLAN_TREMERE)
			to_chat(owner, "<span class='announce'>You have Ranked up enough to learn: You are part of the Tremere Clan!<br> \
				* As part of the Tremere Clan, you are weak to Anti-magic, and will catch fire if you enter the Chapel!</span>")
		if(CLAN_VENTRUE)
			to_chat(owner, "<span class='announce'>You have Ranked up enough to learn: You are part of the Ventrue Clan!<br> \
				* As part of the Ventrue Clan, you are extremely snobby with your meals, and refuse to drink blood from people without a Mind.</span>")
		if(CLAN_GIOVANNI)
			to_chat(owner, "<span class='announce'>You have Ranked up enough to learn: You are part of the Giovanni Clan!<br> \
				* As part of the Giovanni Clan, your bites are unforgiving and loud, causing screams even in an attempt to be silent and violently spraying blood if interrupted.</span>")
		if(CLAN_MALKAVIAN)
			var/mob/living/carbon/human/bloodsucker = owner.current
			bloodsucker.gain_trauma(/datum/brain_trauma/mild/hallucinations, TRAUMA_RESILIENCE_ABSOLUTE)
			to_chat(owner, "<span class='announce'>You have Ranked up enough to learn: You are part of the Malkavian Clan!<br> \
				* As part of the Malkavian Clan, you see the world in a different way, suffering hallucinations.</span>")
