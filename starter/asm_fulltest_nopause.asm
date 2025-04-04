#############################################################################################
#
# Montek Singh
# COMP 541 Final Projects
# 3/24/2025
#
# This is a MIPS program that tests the MIPS processor, and the full set of I/O devices:
# VGA display, keyboard, acelerometer, sound and LED lights, using a very simple animation.
#
# This program assumes the memory-IO map introduced in class specifically for the final
# projects.  In MARS, please select:  Settings ==> Memory Configuration ==> Default.
#
#############################################################################################
#
# This program is suitable for Vivado simulation, NOT for board deployment (because it has
# no pauses in it, which will result in very quick execution).
#
#############################################################################################

.data 0x10010000            # Start of data memory
a_sqr:  .space 4
a:  .word 3

.text 0x00400000                # Start of instruction memory
.globl main

main:
    lui     $sp, 0x1001         # Initialize stack pointer to the 1024th location above start of data
    ori     $sp, $sp, 0x1000    # top of the stack will be one word below
                                #   because $sp is decremented first.
    addi    $fp, $sp, -4        # Set $fp to the start of main's stack frame
    
                        # ($s1, $s2) hold the current (X, Y) coordinates
    li  $s1, 20         # initialize to middle screen col (X=20)
    li  $s2, 15         # initialize to middle screen row (Y=15)

animate_loop:   
    li  $a0, 2          # put character code 2 in argument $a0
    move $a1, $s1       # put X in argument $a1
    move $a2, $s2       # put Y in argument $a2
    jal putChar_atXY    # $a0 is char, $a1 is X, $a2 is Y
    
    jal get_accelX      # get front to back board tilt angle
    sll $a0, $v0, 12    # multiply by 2^12
    jal put_sound       # create sound with that as period
    
    jal get_accelY      # get left to right tilt angle
    srl $v0, $v0, 5     # keep leftmost 4 bits out of 9
    li  $a0, 1
    sllv $a0, $a0, $v0  # calculate 2^v0 (one hot pattern, 2^0 to 2^15)
    jal put_leds        # one LED will be lit
    
    li  $a0, 15         # pause for 0.15 second
    # next line commented to eliminate long pauses during Vivado simulation
    # jal pause_and_getkey # and read key during the pause
    jal get_key 	# during simulation, simply read key instead of using pause_and_getkey
    move $s0, $v0       # save key read in $s0
    
    jal sound_off       # turn sound off (previous note has played during the pause)
    
    beq $s0, $0, animate_loop   # start over if no valid key is returned
    
key1:
    bne $s0, 1, key2
    addi    $s1, $s1, -1        # move left
    slt $1, $s1, $0     # make sure X >= 0
    beq $1, $0, animate_loop
    li  $s1, 0          # else, set X to 0
    j   animate_loop

key2:
    bne $s0, 2, key3
    addi    $s1, $s1, 1         # move right
    slti    $1, $s1, 40     # make sure X < 40
    bne $1, $0, animate_loop
    li  $s1, 39         # else, set X to 39
    j   animate_loop

key3:
    bne $s0, 3, key4
    addi    $s2, $s2, -1        # move up
    slt $1, $s2, $0     # make sure Y >= 0
    beq $1, $0, animate_loop
    li  $s2, 0          # else, set Y to 0
    j   animate_loop

key4:
    bne $s0, 4, animate_loop    # key doesn't match, start over
    addi    $s2, $s2, 1         # move down
    slti    $1, $s2, 30     # make sure Y < 30
    bne $1, $0, animate_loop
    li  $s2, 29         # else, set Y to 29
    j   animate_loop


            
                    
    ###############################
    # END using infinite loop     #
    ###############################
    
                # program won't reach here, but have it for safety
end:
    j   end             # infinite loop "trap" because we don't have syscalls to exit


######## END OF MAIN #################################################################################



.include "procs_board.asm"
