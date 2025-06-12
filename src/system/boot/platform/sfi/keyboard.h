#ifndef KEYBOARD_H
#define KEYBOARD_H


#include <SupportDefs.h>


union key {
	uint16 ax;
	struct {
		uint8 ascii;
		uint8 bios;
	} code;
};

#ifdef __cplusplus
extern "C" {
#endif

extern void clear_key_buffer(void);
extern union key wait_for_key(void);
extern uint32 check_for_boot_keys(void);

#ifdef __cplusplus
}
#endif

#endif	/* KEYBOARD_H */
