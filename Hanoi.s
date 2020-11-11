.global _start
_start:
	mov r0, #7	// Number of Disks
	bl hanoi
	1: b 1b		// End of the Code

hanoi:
	push {r1, r2, r3, r7, r9, r10, r11, r12, lr}
	
	mov r1, #0			// Tower 1
	mov r2, #0			// Tower 2
	mov r3, #0			// Tower 3
	mov r9, #1			// Origin Tower
	mov r10, #2			// Aid Tower
	mov r11, #3			// Destination Tower
	mov r7, #0			// Custom Flag used to change between "sort" and "insertDisk"
	ldr r12, =0x03000	// Memory Address where Tower Statuses are Stored
	
	bl originTower
	pop {r1, r2, r3, r7, r9, r10, r11, r12, lr}
	mov pc, lr
	
	//This function fills tower one with the number of disks entered in r0
	originTower:
		push {r0,r7,lr}
		ldr r1, =0x12345678
		mov r7, #4
		mvn r0, r0
		add r0, r0, #9
		mul r0, r0, r7
		lsr r1, r1, r0
		pop {r0, r7}
		
		bl save
		pop {lr}
		

	//In this section, the "if" and "else" functions are used to execute the logic of the Towers of Hanoi puzzle as efficiently as possible
	if:
		cmp r0, #1
		bne else
	
		push {lr}
		cmp r9, #2	// The flags are initialized before entering the "sort" function to recognize which is the Origin Tower
		bl sort
		pop {lr}
		mov pc, lr
		
	else:
		push {r0, r9, r10, r11, lr}
		sub r0, r0, #1
		add r11, r11, r10
		sub r10, r11, r10
		sub r11, r11, r10
		bl if
		pop {r0, r9, r10, r11, lr}
		
		push {lr}
		cmp r9, #2	// The flags are initialized before entering the "sort" function to recognize which is the Origin Tower
		bl sort
		pop {lr}
		
		push {r0, r9, r10, r11, lr}
		sub r0, r0, #1
		add r9, r9, r10
		sub r10, r9, r10
		sub r9, r9, r10
		bl if
		pop {r0, r9, r10, r11, lr}
		mov pc, lr

	// se cuenta la cantidad de discos en la torre (cuenta va en r10)
	sort:
		push {r4, r5, r10}
		movgt r4, r3
		moveq r4, r2
		movlt r4, r1
		ldr r5, =0xffffffff
		mov r10, #0
		push {r4}

		// r10 is used to count how many disks are in the Origin Tower
		for:
			ands r4, r5
			lslne r5, #4
			addne r10, #1
			bne for

		pop {r4}
		cmp r7, #1	// Use of the Custom Flag r7 to know when to go to "insertDisk"
		beq insertDisk
		
		// The first disk from right to left is erased
		sub r10, #1
		lsl r10, #2
		mov r5, #0xf
		lsl r5, r10
		mvn r5, r5
		and r4, r5
		cmp r9,#2
		movgt r3, r4
		moveq r2, r4
		movlt r1, r4
		pop {r4, r5, r10}
		mov r7, #1			// Custom Flag changed to go to "insertDisk"
		cmp r11, #2			// The flags are initialized before entering the "insertDisk" function to recognize which is the Destination Tower
		b sort

		// The previously removed disk is inserted into the destination tower
		insertDisk:
			lsl r10, #2 
			lsl r5, r0, r10
			orr r4, r5
			cmp r11, #2 
			movgt r3, r4
			moveq r2, r4
			movlt r1, r4
			pop {r4, r5, r10}
			mov r7, #0			// Custom Flag changed to NOT go to "insertDisk"

		// The state of r1, r2 and r3 is stored in memory
		save:
			str r1, [r12], #4
			str r2, [r12], #4
			str r3, [r12], #8
			mov pc, lr