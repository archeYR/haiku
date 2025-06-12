/*
 * Copyright 2004-2011, Axel Dörfler, axeld@pinc-software.de.
 * Distributed under the terms of the MIT License.
 */


#include "keyboard.h"

#include <boot/platform.h>

static uint16
check_for_key(void)
{
	return 0;
}


extern "C" void
clear_key_buffer(void)
{
	while (check_for_key() != 0)
		;
}


extern "C" union key
wait_for_key(void)
{
	union key key;
	do {
		key.ax = check_for_key();
	} while (key.ax == 0);

	return key;
}


extern "C" uint32
check_for_boot_keys(void)
{
	uint32 options = 0;

	return options;
}

