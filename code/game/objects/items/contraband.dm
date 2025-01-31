//Let's get some REAL contraband stuff in here. Because come on, getting brigged for LIPSTICK is no fun.
//
// Includes drug powder. 
//
//Illicit drugs~
/obj/item/storage/pill_bottle/happy
	name = "bottle of Happy pills"
	desc = "A recreational drug. When you want to see the rainbow. Probably not work-approved..."
	wrapper_color = COLOR_PINK
	starts_with = list(/obj/item/reagent_containers/pill/happy = 7)

/obj/item/storage/pill_bottle/zoom
	name = "bottle of Zoom pills"
	desc = "Probably illegal. Trade brain for speed."
	wrapper_color = COLOR_BLUE
	starts_with = list(/obj/item/reagent_containers/pill/zoom = 7)

/obj/item/reagent_containers/glass/beaker/vial/random
	flags = 0
	var/list/random_reagent_list = list(list("water" = 15) = 1, list("cleaner" = 15) = 1)

/obj/item/reagent_containers/glass/beaker/vial/random/toxin
	random_reagent_list = list(
		list("mindbreaker" = 10, "bliss" = 20)	= 3,
		list("carpotoxin" = 15)							= 2,
		list("impedrezene" = 15)						= 2,
		list("zombiepowder" = 10)						= 1)

/obj/item/reagent_containers/glass/beaker/vial/random/Initialize()
	. = ..()
	if(is_open_container())
		flags ^= OPENCONTAINER

	var/list/picked_reagents = pickweight(random_reagent_list)
	for(var/reagent in picked_reagents)
		reagents.add_reagent(reagent, picked_reagents[reagent])

	var/list/names = new
	for(var/datum/reagent/R in reagents.reagent_list)
		names += R.name

	desc = "Contains [english_list(names)]."
	update_icon()

/*/////////////////////////////////////
// 			DRUG POWDER				//
////////////////////////////////////// 
*/
/obj/item/reagent_containers/powder
	name = "powder"
	desc = "A powdered form of... something."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "powder"
	item_state = "powder"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = 5
	w_class = ITEMSIZE_TINY
	volume = 50

/obj/item/reagent_containers/powder/examine(mob/user)
	if(reagents)
		var/datum/reagent/R = reagents.get_master_reagent()
		desc = "A powdered form of what appears to be [R.name]. There's about [reagents.total_volume] units here."
	return ..()

/obj/item/reagent_containers/powder/Initialize()
	..()
	get_appearance()

/obj/item/reagent_containers/powder/proc/get_appearance()
	/// Names and colors based on dominant reagent. 
	if (reagents.reagent_list.len > 0)
		color = reagents.get_color()
		var/datum/reagent/R = reagents.get_master_reagent()
		var/new_name = lowertext(R)
		name = "powdered [new_name]"

/// Snorting. 

/obj/item/reagent_containers/powder/attackby(var/obj/item/W, var/mob/living/user)

	if(!ishuman(user)) /// You gotta be fleshy to snort the naughty drugs. 
		return ..()

	if(!istype(W, /obj/item/glass_extra/straw) && !istype(W, /obj/item/reagent_containers/rollingpaper))
		return ..()

	user.visible_message("<span class='warning'>[user] snorts [src] with [W]!</span>")
	playsound(loc, 'sound/effects/snort.ogg', 50, 1)

	if(reagents)
		reagents.trans_to_mob(user, amount_per_transfer_from_this, CHEM_BLOOD)

	if(!reagents.total_volume) /// Did we use all of it? 
		qdel(src)

////// End powder. ///////////
//////////////////////////////
///// Drugs for loadout///////

/obj/item/storage/pill_bottle/bliss
	name = "unlabeled pill bottle"
	desc = "A pill bottle with its label suspiciously scratched out."
	starts_with = list(/obj/item/reagent_containers/pill/unidentified/bliss = 7)

/obj/item/storage/pill_bottle/snowflake
	name = "unlabeled pill bottle"
	desc = "A pill bottle with its label suspiciously scratched out."
	starts_with = list(/obj/item/reagent_containers/pill/unidentified/snowflake = 7)

/obj/item/storage/pill_bottle/royale
	name = "unlabeled pill bottle"
	desc = "A pill bottle with its label suspiciously scratched out."
	starts_with = list(/obj/item/reagent_containers/pill/unidentified/royale = 7)

/obj/item/storage/pill_bottle/sinkhole
	name = "unlabeled pill bottle"
	desc = "A pill bottle with its label suspiciously scratched out."
	starts_with = list(/obj/item/reagent_containers/pill/unidentified/sinkhole = 7)

/obj/item/storage/pill_bottle/colorspace
	name = "unlabeled pill bottle"
	desc = "A pill bottle with its label suspiciously scratched out."
	starts_with = list(/obj/item/reagent_containers/pill/unidentified/colorspace = 7)

/obj/item/storage/pill_bottle/schnappi
	name = "unlabeled pill bottle"
	desc = "A pill bottle with its label suspiciously scratched out."
	starts_with = list(/obj/item/reagent_containers/pill/unidentified/schnappi = 7)