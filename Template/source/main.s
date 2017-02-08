.section    .init
.globl     _start

_start:
    b       main
.section .text

main:
    	mov     	sp, #0x8000                                                             	// Initializing the stack pointer
	bl		EnableJTAG                                                              	// Enable JTAG
	bl		InitUART
	mov r8, #0 //Square
	mov r2, #0 //Rectangle
	mov r3, #0 //Triangle
        ldr r0, =string0
        mov r1, #40
        bl WriteStringUART
Userask:
        ldr r0, =strAsk
        mov r1, #96
	bl WriteStringUART
	ldr r0, =strCh
	mov r1, #38
	bl WriteStringUART                                                              		 //This is important to be  able to use UART
getInp:
	ldr r0, =Buffer
	mov r1, #256
	bl ReadLineUART
	ldr r5, [r0, 1]
	ldr r6, [r0]
	cmp r5, #45
	beq c1
	cmp r5, #0
	bne inperr
c1:
	cmp r6, #49
	beq summary
c2:
	cmp r6, #113
	beq exit
	cmp r6, #49
	blt berror
	cmp r6, #49
	beq square
	cmp r6, #50
	beq rectan
	cmp r6, #51
	beq tria
	cmp r6, #51
	bgt berror

getwid:
	ldr r0, =shpAsk
	mov r1, #58
	bl WriteStringUART

	ldr r0, =Buffer
	mov r1, #256
	bl ReadLineUART
	ldr r4,[r0, 1]
	cmp r4, #0
	bne berror
	ldr r4, [r0]
	cmp r4, #3
	blt berror
	cmp r4, #9
	bgt berror
	mov r9, r4
	

square:
	str r12, [sj] //ASK TA ON WEDNESDAY
sj:	mov r10, #0
break:	add r10, r10, #1
	cmp r10, r9
	bgt done
	ldr r0, =newLine
	ldr r1, 1
	bl WriteStringUART
	mov r11, #1
break2:	cmp r11, r9
	beq break
	ldr r0, =drawShp
	mov r1, #1
	bl WriteStringUART
	add r8, r8, #1
	add r11, r11, #1
	b break2

rectan:
	bl getwid
	mov r10, #0
	sub r7, r9, #2
break3:	add r10, r10, 1
	cmp r10, r7
	bgt done
	ldr r0, =newLine
	ldr r1, 1
	bl WriteStringUART
	mov r11, #1
break4:	cmp r11, r9
	beq break3
	ldr r0, =drawShp
	mov r1, #1
	bl WriteStringUART
	add r2, r2, #1
	add r11, r11, #1
	b break4

triang:
	bl getwid
	mov r10, #0
	mov r7, r9
break5:
	mov r11, #0
break6:
	ldr r0, =newSpc
	ldr r1, #1
	bl WriteStringUART
	add, r11, r11, #1
	cmp r11, r7
	ble break7
break7:
	mov r11, #0
breakk7:
	add r11, r11, #1
	ldr r0, =drawShp
	ldr r1, #1
	bl WriteStringUART
	ldr r0, =newSpc
	ldr r1, #1
	bl WriteStringUART
	cmp r11, r10
	ble breakk7
1up:
	ldr r0, =newLine
	ldr r1, #1
	bl WriteStringUART
	sub r7, r7, #1
	add r10, r10, #1
	cmp r10, r9
	ble break5
	b Userask

summary:






	ldr r0, =string0 	                                                                        //Address of the label in data section containing the data you want to print	
	mov r1, #7		                                                                        //Number of characters to print
	bl WriteStringUART

	ldr r0, =string0 	                                                                        //Address of the label in data section containing the data you want to print
	add r0,#7			                                                                //Here I am moving the address to another ascii in this table. Keep in mind each character needs one byte.
	mov r1, #6	                                                                                //Number of characters needed to be print
	bl WriteStringUART

	ldr r0,=Buffer											//The buffer which will store user input. user input will be stored interns of bytes using ascii
	mov r1, #256											// Number of bytes allocated for user input in the memory
	bl ReadLineUART											// it will return in r0 number of characters user entered



.section .data  
string0:
	.ascii "Created By: Josh Dow and Brody Jackson\r\n"
	.align

strAsk:
        .ascii "Please enter the number of the object you wish to draw. Press -1 for summary. Press q to exit\n"
	.align
strCh:
        .ascii "1- Square; 2- Rectangle; 3- Triangle\n"
        .align

inErr:
        .ascii "Wrong number format! q is the only allowed character\n"
        .align
bndErr:
        .ascii "Invalid number! The number should be between 1 and 3 or -1 for summary\n"
        .align

shpAsk:
        .ascii "Please enter the width of object. Must be between 3 and 9\n"
        .align

drawShp:
        .ascii "*"

newLine:
	.ascii "\n"
	.align
newSpc:
	.ascii " "
	.align
dspSum:
        .ascii "Total Number of stars is: %d\n"
        .ascii "Mean of Stars used to draw Square(s): %d\n"
        .ascii "Mean of Stars used to draw Rectangle(s): %d\n"
        .ascii "Mean of Stars used to draw Traingle(s): %d\n"
        .align
trmprg:
        .ascii "Terminating Program\n"
        .align


Buffer:
	.rept 256
	.byte 0
	.endr
