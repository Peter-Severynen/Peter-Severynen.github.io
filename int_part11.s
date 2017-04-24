/******************************************************************************
* @file factorial.s
* @brief simple recursion example
*
* Simple example of recursion and stack management
*
* @author Christopher D. McMurrough
******************************************************************************/
 
.global main
.func main
   
main:
mainloop:

    BL  _prompt             @ branch to prompt procedure with return
    BL  _scanf              @ branch to scan procedure with return
    MOV R1, R0              @ store n, the return value from scanf, in R1
    PUSH {R1}               @ backup R1
    BL  _prompt             @ branch to prompt procedure with return
    BL  _scanf              @ branch to scan procedure with return
    MOV R2, R0              @ store m, the return value from scanf, in R2
    PUSH {R2}               @ backup register
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    MOV R2, R0              @  pass result to printf procedure
    BL  _printf             @ branch to print procedure with return
    B   mainloop            @ branch to next iteration of the loop
   
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
 
_prompt:
    PUSH {R1}               @ backup register value
    PUSH {R2}               @ backup register value
    PUSH {R7}               @ backup register value
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #26             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    POP {R7}                @ restore register value
    POP {R2}                @ restore register value
    POP {R1}                @ restore register value
    MOV PC, LR              @ return
       
_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    @MOV R1, R1              @ R1 contains printf argument 1 (redundant line)
    @MOV R2, R2              @ R2 contains printf argument 2 (redundant line)
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
   
_scanf:
    PUSH {LR}               @ store the return address
    PUSH {R1}               @ backup regsiter value
    LDR R0, =format_str     @ R0 contains address of format string
    SUB SP, SP, #4          @ make room on stack
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ remove value from stack
    POP {R1}                @ restore register value
    POP {PC}                @ restore the stack pointer and return
 
_int_part:
    BL _case1
    BL _case2
    BL _case3
    BL _case4
    POP {PC}
    
_case1:
    PUSH {LR}               @ store the return address
    CMP R1, #0              @ compare the n to 0
    MOVEQ R0, #1            @ set return value to 1 if equal
    POPEQ {PC}              @ restore stack pointer and return if equal
_case2:    
    MOVMI R0, #0            @ set return value to 0 if negative
    PUSH {LR}               @ store the return address
_case3:    
    CMP R2, #0              @ compare m to 0
    MOVEQ R0, #0            @ set return value to 0 if equal
    POPEQ {PC}              @ restore stack pointer and return if equal
_case4:
    PUSH {R1}               @ backup n
    PUSH {R2}               @ backup m
    SUB R1, R1, R2          @ compute n-m
    BL _int_part            @ pass n and m into _int_part
    MOV R8, R0              @ store the result of the 1st call to int_part in R8
    POP {R2}                @ restore the original value of m
    POP {R1}                @ restore the original value of n
    SUB R2, R2, #1          @ compute m-1
    BL _int_part             @ pass n and m into _int_part
    MOV R9, R0              @ store the result of the 2nd call to _int_part in R9
    ADD R0, R8, R9          @ add the results of the 2 calls together and return result in R0
    POP {PC}

.data
number:         .word       0
format_str:     .asciz      "%d"
prompt_str:     .asciz      "Enter a positive number: "
printf_str:     .asciz      "There are %d partitions of %d using integers up to %d\n"
exit_str:       .ascii      "Terminating program.\n"
