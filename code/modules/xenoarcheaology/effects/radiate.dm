/datum/artifact_effect/rare/radiate
	name = "radiation"
	var/radiation_amount

	effect_color = "#007006"

/datum/artifact_effect/rare/radiate/New()
	..()
	radiation_amount = rand(1, 10)
	effect_type = pick(EFFECT_PARTICLE, EFFECT_ORGANIC)

/datum/artifact_effect/rare/radiate/DoEffectTouch(var/mob/living/user)
	if(user)
		user.apply_effect(radiation_amount * 5,IRRADIATE,0)
		user.updatehealth()
		return 1

/datum/artifact_effect/rare/radiate/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		SSradiation.flat_radiate(holder, radiation_amount, src.effectrange)
		return 1

/datum/artifact_effect/rare/radiate/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
		SSradiation.radiate(holder, ((radiation_amount * 25) * (sqrt(src.effectrange)))) //Need to get feedback on this
		return 1
