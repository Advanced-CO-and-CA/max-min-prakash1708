/******************************************************************************
* file: max_min.s
* author: Prakash Tiwari
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

/*
  This is the starter code for assignment 2
  */

  @ BSS section
      .bss

  @ DATA SECTION
      .data
      data_items: .word 10, 4, 28, 100, 8, 0

  @ TEXT section
      .text

.globl _main


_main:

        /*
         * Logic of the program:
         * Take 3 variables on stack to save maximum number, minimum number and array index counter
         * Initalize maximum = minimum = first_element of data_items and count of numbers (array index ounter) to 1
         * start a loop , fetch next number in data_items:
         * if max >= fetched_number, restore max else max = fetched_number
         * if min <= fetched_number, restore min else min = fetched_number
         * back to loop
         * if fetched_number == 0 then exit loop
         * load count of numbers, minimum and maximum number to r3, r2 and r1 respectively : program result.
         */
		
        @ save data_items[0] to stack 
        ldr         r3,=data_items
        ldr         r3,[r3]
        str         r3,[sp,#8]
		
        @ save data_items[0] to stack 
        ldr         r3,=data_items
        ldr         r3,[r3]
        str         r3,[sp,#4]
		
        @ save the array index counter to stack 
        movs        r3,#1
        str         r3,[sp]
        b           _max_min_finder
		
loop_max_min : 
        ldr         r3,[sp]    @ get the array index counter from stack
        adds        r3,r3,#1   @ add +1 for getting next element
        str         r3,[sp]    @ update index counter to stack

_max_min_finder:
        @ Load array index counter to r2 from stack : pushed before jump
        ldr         r2,[sp]
        movs        r3,#4
        @ Update r2 with array index * 4
        mul         r2,r2,r3
        
        ldr         r3,=data_items
		
        add         r3,r3,r2 @ get the location => data_items + r2 (next word position)
        ldr         r3,[r3]  @ load the value
        cmp         r3,#0    @ check if data_items 0 : end of the array
        
        beq         _end_loop_max_min
        
        @ not end of array
        @ Load array index counter to r2 from stack : pushed before jump
        ldr         r2,[sp]
        movs        r3,#4
		
        @Update r2 with array index * 4
        mul         r2,r2,r3
        ldr         r3,=data_items @ get the address of the first-element of the array
        add         r3,r3,r2       @ get the address of the current element of the array with value of r2
        ldr         r2,[sp,#8]     @ Load the last max element saved onto stack before jump
        ldr         r3,[r3]        @ Load the current element of the array with r3 calculated above
        cmp         r2,r3          @ compare last max element with current_element
        bge         _update_min    @ if last max element >= current_element, we already have max and update the min now
        
        @update max value
        ldr         r2,[sp]        @ Load array index counter to r2 from stack : pushed before jump
        movs        r3,#4
        mul         r2,r2,r3       @ Update r2 with array index * 4
        ldr         r3,=data_items
        add         r3,r3,r2
        ldr         r3,[r3]
        str         r3,[sp,#8]     @ update last max value to stack

_update_min:
        ldr         r2,[sp]            @ Load array index counter to r2 from stack : pushed before jump
        movs        r3,#4
        mul         r2,r2,r3           @ Update r2 with array index * 4
        ldr         r3,=data_items
        add         r3,r3,r2
        ldr         r2,[sp,#4]         @ Load the last min element saved onto stack before jump
        ldr         r3,[r3] @ Load the current element
        cmp         r2,r3  @compare last min element with current element
        ble         _get_max_min    @ if last min element <= current element , we already have min
        
        @ else update min value
        ldr         r2,[sp]        @ same as above startin line 88 to 94
        movs        r3,#4
        mul         r2,r2,r3
        ldr         r3,=data_items
        add         r3,r3,r2
        ldr         r3,[r3]
        str         r3,[sp,#4] @ update last min value to stack


_get_max_min:
        b           loop_max_min

_end_loop_max_min:
        ldr         r3,[sp]    @ r3 will have the number of elements
        ldr         r2,[sp,#4] @ r2 will have minimum value
        ldr         r1,[sp,#8] @ r1 will have maximum value
