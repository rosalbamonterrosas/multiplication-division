# multiplication-division
Program developed in assembly language for the MSP430G2553 that can multiply and divide.

The main program stores a value in register R4 and register R5, and then calls the subroutine #MULT. The subroutine #MULT takes  the  value  stored  in register R4 and multiplies it by the value ofregister R5. The subroutine stores the result in memory location 0x020A.

The main program also stores a value in register R6 and register R5, and then calls the subroutine #DIV. The subroutine #DIV takes the value stored in register R6 and divides it by the value ofregister R5. The subroutine stores the result in memory location 0x021F.

The subroutines #MULT and #DIV can handle negative, zero, and positive numbers.
