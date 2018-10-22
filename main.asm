;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

MAIN		mov.b #-128, R4
		mov.b #1, R5
		call #MULT

		mov #-128, R6
		mov #2, R5
		call #DIV

Mainloop jmp Mainloop


MULT		clr R8
		mov.b R4, R9 ; preserve value in R4
		cmp.b #0, R4
		jz store ; check if zero
		jl check ; check if negative and then check the next register
		inv.b R4 ; 1’s complement
		add.b #1, R4  ; 2’s complement to change positive value to negative

check		mov.b R5, R10 ; preserve value in R5
		cmp.b #0, R5
		jz store ; check if zero
		jl compare ; check if negative
		inv.b R5 ; 1’s complement
		add.b #1, R5  ; 2’s complement to change positive value to negative

compare		cmp.b R5, R4
		jl loop
		mov.b R4, R7 ; R7 is used for temporary storage for swapping R5 and R4
		mov.b R5, R4
		mov.b R7, R5
		
loop		add.b R5, R8
		dec.b R4
		jnz loop
		xor.b R9, R10 ; check if both values are positive or negative
		bit.b #80h, R10
		jz store
		inv.b R8 ; 1’s complement of final result
		add.b #1, R8  ; 2’s complement of final result
		
store		mov.b R8, &0x020A
		ret


DIV		clr R7
		mov.b R6, R9 ; preserve value in R4
		cmp.b #0, R5
		jz end
		cmp.b #0, R6
		jz store2 ; check if zero
		jl check2 ; check if negative and then check the next register
		inv.b R6 ; 1’s complement
		add.b #1, R6  ; 2’s complement to change positive value to negative

check2		mov.b R5, R10 ; preserve value in R5
		cmp.b #0, R5
		jl loop2 ; check if negative
		inv.b R5 ; 1’s complement
		add.b #1, R5  ; 2’s complement to change positive value to negative

loop2		inc.b R7 ; R7 is counter
		sub.b R5, R6
		jn loop2
		jz loop2
		dec.b R7

		xor.b R9, R10 ; check if both values are positive or negative
		bit.b #80h, R10
		jz store2
		inv.b R7 ; 1’s complement of final result
		add.b #1, R7  ; 2’s complement of final result

store2		mov.b R7, &0x021F

end		ret
                                            

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
