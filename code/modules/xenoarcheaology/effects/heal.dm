/datum/artifact_effect/uncommon/heal
	name = "heal"
	effect_type = EFFECT_ORGANIC
	effect_color = "#4649ff"

/datum/artifact_effect/uncommon/heal/DoEffectTouch(var/mob/toucher)
	//todo: check over this properly
	if(toucher && iscarbon(toucher))
		var/weakness = GetAnomalySusceptibility(toucher)
		if(prob(weakness * 100))
			var/mob/living/carbon/C = toucher
			to_chat(C, "<font color='blue'>You feel a soothing energy invigorate you.</font>")

			if(ishuman(toucher))
				var/mob/living/carbon/human/H = toucher
				for(var/obj/item/organ/external/affecting in H.organs)
					if(affecting && istype(affecting))
						affecting.heal_damage(25 * weakness, 25 * weakness)
				//H:heal_organ_damage(25, 25)
				H.vessel.add_reagent("blood",5)
				H.adjust_nutrition(50 * weakness)
				H.adjustBrainLoss(-25 * weakness)
				H.radiation -= min(H.radiation, 25 * weakness)
				H.bodytemperature = initial(H.bodytemperature)
				spawn(1)
					H.fixblood()
			//
			C.adjustOxyLoss(-25 * weakness)
			C.adjustToxLoss(-25 * weakness)
			C.adjustBruteLoss(-25 * weakness)
			C.adjustFireLoss(-25 * weakness)
			//
			C.regenerate_icons()
			return 1

/datum/artifact_effect/uncommon/heal/DoEffectAura()
	var/atom/holder = get_master_holder()
	//todo: check over this properly
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				if(prob(10))
					to_chat(C, "<font color='blue'>You feel a soothing energy radiating from something nearby.</font>")
				C.adjustBruteLoss(-1 * weakness)
				C.adjustFireLoss(-1 * weakness)
				C.adjustToxLoss(-1 * weakness)
				C.adjustOxyLoss(-1 * weakness)
				C.adjustBrainLoss(-1 * weakness)
				C.updatehealth()

/datum/artifact_effect/uncommon/heal/DoEffectPulse()
	var/atom/holder = get_master_holder()
	//todo: check over this properly
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/carbon/C in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				to_chat(C, "<font color='blue'>A wave of energy invigorates you.</font>")
				C.adjustBruteLoss(-5 * weakness)
				C.adjustFireLoss(-5 * weakness)
				C.adjustToxLoss(-5 * weakness)
				C.adjustOxyLoss(-5 * weakness)
				C.adjustBrainLoss(-5 * weakness)
				C.updatehealth()
