/*
 * Copyright 2004-2005, Axel Dörfler, axeld@pinc-software.de. All rights reserved.
 * Distributed under the terms of the MIT License.
 */


/**	This file contains Multiboot entry code for SFI.
 */

#include "multiboot.h"

#define GLOBAL(x) .globl x ; x

#define OUR_MB_FLAGS (MULTIBOOT_PAGE_ALIGN \
	| MULTIBOOT_MEMORY_INFO \
	/*| MULTIBOOT_VIDEO_MODE*/ \
	| MULTIBOOT_AOUT_KLUDGE)

// load address
#define LOAD_SEGMENT 0x1000
#define LOAD_ADDRESS 0x10000

// MultiBoot load address
#define MB_LOAD_ADDRESS 0x100000
//#define MB_LOAD_ADDRESS LOAD_ADDRESS
#define MB_LOAD_OFFSET (MB_LOAD_ADDRESS - LOAD_ADDRESS)

.text
.code32

_protected_code_segment:
	mov		$0x10, %ax		// load descriptor 2 in the data and stack segment selectors
	mov		%ax, %ds
	mov		%ax, %es
	mov		%ax, %fs
	mov		%ax, %gs
	mov		%ax, %ss

	movl	$0x10000, %esp	// setup new stack
	pushl	$0				// terminate stack frame chain (next frame and
	pushl	$0				// return address)
	mov		%esp, %ebp

	call	_start

//--------------------------------------------------------------

/** MultiBoot entry point
 */

multiboot_start:
	//subl		$MULTIBOOT_MAGIC2, %eax
	//jnz		load_failed		// rts to grub ?
	movl		%ebx, gMultiBootInfo + MB_LOAD_OFFSET
	// load the GDT
	lgdt		gdt_descriptor + MB_LOAD_OFFSET

#if MB_LOAD_ADDRESS != LOAD_ADDRESS
	// QEMU does not like the real load address...
	// copy ourselves to the expected location
	cld
	mov		$(_end - LOAD_ADDRESS), %ecx
	add		$3, %ecx
	shr		$2, %ecx
	mov		$LOAD_ADDRESS, %edi
	mov		$MB_LOAD_ADDRESS, %esi
	rep movsl

	// reload the GDT just in case
	lgdt		gdt_descriptor
#endif

relocated_mb_start:
	ljmp		$0x8, $_protected_code_segment

.align 4
multiboot_header:
	.long	MULTIBOOT_MAGIC
	.long	OUR_MB_FLAGS
	.long	(0 - MULTIBOOT_MAGIC - OUR_MB_FLAGS)		// checksum (8 bytes)
	.long	multiboot_header + MB_LOAD_OFFSET
	.long	.text + MB_LOAD_OFFSET
	.long	.bss + (MB_LOAD_OFFSET - 24)
	.long	_end + (MB_LOAD_OFFSET - 24)
	.long	multiboot_start + MB_LOAD_OFFSET
#if (OUR_MB_FLAGS & MULTIBOOT_VIDEO_MODE)
	.long	0	// non text mode
	.long	1024
	.long	786
	.long	24
#endif

/* global data table */

gdt:
	// null descriptor
	.long	0
	.long	0

	// kernel code segment
	.long	0x0000ffff		// base: 0, limit: 4 GB
	.long	0x00cf9e00		// type: 32 bit, exec-only conforming, privilege 0
	// kernel data and stack segment
	.long	0x0000ffff		// base: 0, limit: 4 GB
	.long	0x00cf9200		// type: 32 bit, data read/write, privilege 0

	// real mode 16 bit code segment
	.long	0x0000ffff		// base: 0x10000, limit: 64 kB
	.long	0x00009e01
	// real mode 16 bit data and stack segment
	.long	0x0000ffff		// base: 0x10000, limit: 64 kB
	.long	0x00009201
	// real mode 16 bit stack segment
	.long	0x0000ffff		// base: 0, limit: 64 kB
	.long	0x00009200

gdt_descriptor:
	.word	0x2f			// 6 entries in the GDT (8 bytes each)
	.long	gdt

GLOBAL(gBootedFromImage):
	.byte	0

GLOBAL(gBootDriveID):
	.byte	0

GLOBAL(gBootPartitionOffset):
	.long	0

GLOBAL(gMultiBootInfo):
	.long	0

.org 1024

.section .bss
