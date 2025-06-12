/*
 * Copyright 2003-2006, Axel Dörfler, axeld@pinc-software.de.
 * Distributed under the terms of the MIT License.
 */

#include <KernelExport.h>
#include <boot/platform.h>
#include <boot/partitions.h>
#include <boot/stdio.h>
#include <boot/stage2.h>

#include <string.h>

//#define TRACE_DEVICES
#ifdef TRACE_DEVICES
#	define TRACE(x) dprintf x
#else
#	define TRACE(x) ;
#endif


// exported from shell.S
extern uint8 gBootedFromImage;
extern uint8 gBootDriveID;
extern uint32 gBootPartitionOffset;


//	#pragma mark -


status_t
platform_add_boot_device(struct stage2_args *args, NodeList *devicesList)
{
	return B_ERROR;
}


status_t
platform_get_boot_partitions(struct stage2_args *args, Node *bootDevice,
	NodeList *list, NodeList *bootList)
{
	return B_ERROR;
}


status_t
platform_add_block_devices(stage2_args *args, NodeList *devicesList)
{
	return B_ERROR;
}


status_t
platform_register_boot_device(Node *device)
{
	return B_ERROR;
}


void
platform_cleanup_devices()
{
}
