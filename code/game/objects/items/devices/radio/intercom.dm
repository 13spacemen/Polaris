/obj/item/radio/intercom
	name = "station intercom (General)"
	desc = "Talk through this."
	icon_state = "intercom"
	layer = ABOVE_WINDOW_LAYER
	anchored = 1
	w_class = ITEMSIZE_LARGE
	canhear_range = 2
	flags = NOBLOODY
	var/circuit = /obj/item/circuitboard/intercom
	var/number = 0
	var/wiresexposed = 0

/obj/item/radio/intercom/Initialize()
	. = ..()
	var/area/A = get_area(src)
	if(A)
		GLOB.apc_event.register(A, src, /atom/proc/update_icon)

/obj/item/radio/intercom/Destroy()
	var/area/A = get_area(src)
	if(A)
		GLOB.apc_event.unregister(A, src, /atom/proc/update_icon)
	return ..()

/obj/item/radio/intercom/custom
	name = "station intercom (Custom)"
	broadcasting = 0
	listening = 0

/obj/item/radio/intercom/interrogation
	name = "station intercom (Interrogation)"
	frequency  = 1449

/obj/item/radio/intercom/private
	name = "station intercom (Private)"
	frequency = AI_FREQ

/obj/item/radio/intercom/specops
	name = "\improper Spec Ops intercom"
	frequency = ERT_FREQ
	subspace_transmission = 1
	centComm = 1

/obj/item/radio/intercom/department
	canhear_range = 5
	broadcasting = 0
	listening = 1

/obj/item/radio/intercom/department/medbay
	name = "station intercom (Medbay)"
	icon_state = "medintercom"
	frequency = MED_I_FREQ

/obj/item/radio/intercom/department/security
	name = "station intercom (Security)"
	icon_state = "secintercom"
	frequency = SEC_I_FREQ

/obj/item/radio/intercom/entertainment
	name = "entertainment intercom"
	frequency = ENT_FREQ

/obj/item/radio/intercom/omni
	name = "global announcer"
/obj/item/radio/intercom/omni/Initialize()
	channels = radiochannels.Copy()
	return ..()

/obj/item/radio/intercom/Initialize()
	. = ..()
	circuit = new circuit(src)

/obj/item/radio/intercom/department/medbay/Initialize()
	. = ..()
	internal_channels = default_medbay_channels.Copy()

/obj/item/radio/intercom/department/security/Initialize()
	. = ..()
	internal_channels = list(
		num2text(PUB_FREQ) = list(),
		num2text(SEC_I_FREQ) = list(access_security)
	)

/obj/item/radio/intercom/entertainment/Initialize()
	. = ..()
	internal_channels = list(
		num2text(PUB_FREQ) = list(),
		num2text(ENT_FREQ) = list()
	)

/obj/item/radio/intercom/syndicate
	name = "illicit intercom"
	desc = "Talk through this. Evilly"
	frequency = SYND_FREQ
	subspace_transmission = 1
	syndie = 1

/obj/item/radio/intercom/syndicate/Initialize()
	. = ..()
	internal_channels[num2text(SYND_FREQ)] = list(access_syndicate)

/obj/item/radio/intercom/raider
	name = "illicit intercom"
	desc = "Pirate radio, but not in the usual sense of the word."
	frequency = RAID_FREQ
	subspace_transmission = 1
	syndie = 1

/obj/item/radio/intercom/raider/Initialize()
	. = ..()
	internal_channels[num2text(RAID_FREQ)] = list(access_syndicate)

/obj/item/radio/intercom/attack_ai(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/radio/intercom/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/radio/intercom/attackby(obj/item/W as obj, mob/user as mob)
	add_fingerprint(user)
	if(W.is_screwdriver())  // Opening the intercom up.
		wiresexposed = !wiresexposed
		to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"]")
		playsound(src, W.usesound, 50, 1)
		update_icon()
	else if(wiresexposed && W.is_wirecutter())
		user.visible_message("<span class='warning'>[user] has cut the wires inside \the [src]!</span>", "You have cut the wires inside \the [src].")
		playsound(src, W.usesound, 50, 1)
		new/obj/item/stack/cable_coil(get_turf(src), 5)
		var/obj/structure/frame/A = new /obj/structure/frame(src.loc)
		var/obj/item/circuitboard/M = circuit
		A.frame_type = M.board_type
		A.pixel_x = pixel_x
		A.pixel_y = pixel_y
		A.circuit = M
		A.set_dir(dir)
		A.anchored = 1
		A.state = 2
		A.update_icon()
		M.deconstruct(src)
		qdel(src)
	else
		src.attack_hand(user)

/obj/item/radio/intercom/receive_range(freq, level)
	if (!on)
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(isnull(position) || !(position.z in level))
			return -1
	if (!src.listening)
		return -1
	if(freq in ANTAG_FREQS)
		if(!(src.syndie))
			return -1//Prevents broadcast of messages over devices lacking the encryption

	return canhear_range

/obj/item/radio/intercom/update_icon()
	var/area/A = get_area(src)
	on = A?.powered(EQUIP)

	if(!on)
		if(wiresexposed)
			icon_state = "intercom-p_open"
		else
			icon_state = "intercom-p"
	else
		if(wiresexposed)
			icon_state = "intercom_open"
		else
			icon_state = initial(icon_state)

/obj/item/radio/intercom/locked
    var/locked_frequency

/obj/item/radio/intercom/locked/set_frequency(var/frequency)
	if(frequency == locked_frequency)
		..(locked_frequency)

/obj/item/radio/intercom/locked/list_channels()
	return ""

/obj/item/radio/intercom/locked/ai_private
	name = "\improper AI intercom"
	frequency = AI_FREQ
	broadcasting = 1
	listening = 1

/obj/item/radio/intercom/locked/confessional
	name = "confessional intercom"
	frequency = 1480