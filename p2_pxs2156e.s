/******************************************************************************
* Peter Severynen
  Program 2
  Search and find min and max in an array loaded with random values.
* 
******************************************************************************/
 
.global main
.func main
   
main:
    BL _seedrand            @ seed random number generator with current time
    MOV R0, #0              @ initialze index variable
writeloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    PUSH {R0}               @ backup iterator before procedure call
    PUSH {R2}               @ backup element address before procedure call
    BL _getrand             @ get a random number
    MOV R1, R0          @ move R0 into R1 for mod evaluation
    MOV R2, #1000       @ set a constant value for mod evaluation
    PUSH {R1}           @ store value to stack
    PUSH {R2}           @ store value to stack
    BL  _mod_unsigned   @ compute the remainder of R1 / R2
    POP {R2}            @ restore values from stack
    POP {R1}            @ restore values from stack
    MOV R3, R0          @ copy mod result to R3    
    POP {R2}                @ restore element address
    STR R0, [R2]            @ write the address of a[i] to a[i]
    POP {R0}                @ restore iterator
    ADD R0, R0, #1          @ increment index
    B   writeloop           @ branch to next loop iteration
writedone:
    MOV R0, #0              @ initialze index variable
readloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
readdone:
    LDR R1, =a              @ get address of a and begin search for minimum element
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    MOV R8, R1              @ put 1st element in R8
 minloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ minloopdone         @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    MOVLE R8, R1            @ If the current array element is less than than R8, move it into R8
    ADD R0, R0, #1          @ increment index
    B   maxloop            @ branch to next loop iteration
minloopdone:
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R8              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printfmin          @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    LDR R1, =a              @ get address of a and begin search for maximum element
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    MOV R9, R1              @ put 1st element in R9
 maxloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ maxloopdone            @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    MOVGE R9, R1            @ If the current array element is greater than R8, move it into R8
    ADD R0, R0, #1          @ increment index
    B   maxloop            @ branch to next loop iteration
maxloopdone:
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R9              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printfmax          @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    B _exit
    
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

_mod_unsigned:
    cmp R2, R1          @ check to see if R1 >= R2
    MOVHS R0, R1        @ swap R1 and R2 if R2 > R1
    MOVHS R1, R2        @ swap R1 and R2 if R2 > R1
    MOVHS R2, R0        @ swap R1 and R2 if R2 > R1
    MOV R0, #0          @ initialize return value
    B _modloopcheck     @ check to see if
    _modloop:
        ADD R0, R0, #1  @ increment R0
        SUB R1, R1, R2  @ subtract R2 from R1
    _modloopcheck:
        CMP R1, R2      @ check for loop termination
        BHS _modloop    @ continue loop if R1 >= R2
    MOV R0, R1          @ move remainder to R0
    MOV PC, LR          @ return
        
_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_printfmin:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str_min     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_printfmax:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str_max     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
    
_seedrand:
    PUSH {LR}               @ backup return address
    MOV R0, #0              @ pass 0 as argument to time call
    BL time                 @ get system time
    MOV R1, R0              @ pass sytem time as argument to srand
    BL srand                @ seed the random number generator
    POP {PC}                @ return 
    
_getrand:
    PUSH {LR}               @ backup return address
    BL rand                 @ get a random number
    POP {PC}                @ return 
   
.data

.balign 4
a:              .skip       400
printf_str:        .asciz     "a[%d] = %d\n"
printf_str_min:    .asciz     "MINIMUM VALUE =  %d\n"
printf_str_max:    .asciz     "MAXIMUM VALUE =  %d\n"
debug_str:
.asciz "R%-2d   0x%08X  %011d \n"
exit_str:       .ascii      "Terminating program.\n"
