;-------------------------------------------------------------------------------
include '../include/library.inc'
;-------------------------------------------------------------------------------

library 'KEYPADC', 2

;-------------------------------------------------------------------------------
; no dependencies
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; v1 functions
;-------------------------------------------------------------------------------
	export kb_Scan
	export kb_ScanGroup
	export kb_AnyKey
	export kb_Reset
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
kb_Scan:
; Scans the keypad and updates data registers
; Note: Disables interrupts during execution, and restores on exit
; Arguments:
;  None
; Returns:
;  None
	di
	ld	hl,$f50200		; DI_Mode = $f5xx00
	ld	(hl),h
	xor	a,a
.loop:
	cp	a,(hl)
	jr	nz,.loop
	ret

;-------------------------------------------------------------------------------
kb_Reset:
; Resets the keypad (Only use if modified)
; Arguments:
;  None
; Returns:
;  None
	ld	hl,$000f00		; 0/Wait 15*256 APB cycles before scanning each row/Mode 0/
	ld	(DI_Mode),hl
	ld	hl,$08080f		; (nb of columns,nb of row) to scan/Wait 15 APB cycles before each scan
	ld	(DI_Mode+3),hl
	ret

;-------------------------------------------------------------------------------
kb_ScanGroup:
; Scans a keypad group
; Note: Disables interrupts during execution
; Arguments:
;  arg0 : Keypad group number
; Returns:
;  Value of entire group (Keys ORd)
	pop	hl
	pop	bc
	push	bc
	push	hl
	di
	ld	hl,$f50200		; DI_Mode = $f5xx00
	ld	(hl),h
	xor	a,a
.loop:
	cp	a,(hl)
	jr	nz,.loop
	ld	a,c
	cp	a,8
	jr	nc,.found
	ld	l,a
	mlt	hl
	ld	de,kbdG1-2
	add	hl,de
	ld	a,(hl)
	ret
.found:
	xor	a,a
	ret

;-------------------------------------------------------------------------------
kb_AnyKey:
; Scans the keypad and updates data registers; checking if a key was pressed
; Note: Disables interrupts during execution
; Arguments:
;  None
; Returns:
;  0 if no key is pressed
	di
	ld	hl,$f50200		; DI_Mode = $f5xx00
	ld	(hl),h
	xor	a,a
.loop:
	cp	a,(hl)
	jr	nz,.loop
	ld	l,$12			; kbdG1 = $f5xx12
	or	a,(hl)
	inc	hl
	inc	hl
	or	a,(hl)
	inc	hl
	inc	hl
	or	a,(hl)
	inc	hl
	inc	hl
	or	a,(hl)
	inc	hl
	inc	hl
	or	a,(hl)
	inc	hl
	inc	hl
	or	a,(hl)
	inc	hl
	inc	hl
	or	a,(hl)
	ret