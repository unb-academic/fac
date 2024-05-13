#
# Macros
#

#
# Terminates the program with exit code 0.
#
.macro done
  li a7, 10
  ecall
.end_macro

#
# Terminates the program with the given exit code.
#
# Parameters:
#   - %exit_code: The exit code to return.
#
.macro terminate (%exit_code)
  li a0, %exit_code
  li a7, 93
  ecall
.end_macro

#
# Prints an integer to stdout. The integer is passed as a parameter.
#
# Parameters:
#   - %x: The integer to print. This can be a register or an immediate value.
#
.macro print_int (%x)
  li a7, 1
  add a0, zero, %x
  ecall
.end_macro

#
# Prints a string to stdout. The string is passed as a parameter. This macro
# will first assign a label to its parameter in data segment, then print it.
#
# Parameters:
#   - %str: The string to print.
#
.macro print_str (%str)
.data
label:
  .string %str

.text
  li a7, 4
  la a0, label
  ecall
.end_macro

#
# Prints `\n` to stdout.
#
.macro print_endl ()
  print_str "\n"
.end_macro

#
# Reads an integer from stdin and stores it in the given register.
#
# Parameters:
#   - %x: The register to store the integer in.
#
.macro read_int (%x)
  li a7, 5
  ecall

  # Move the result to the destination register.
  mv %x, a0
.end_macro

#
# Reads a string from stdin and stores it on heap.
#
# Parameters:
#   - %addr: The address to store the pointer to the string.
#   - %size: The size of the buffer to read the string into.
#
.macro read_str (%addr, %size)
  # Allocate memory for the string.
  li a7, 9
  mv a0, %size
  ecall

  # Save the address of the allocated memory into the given register.
  mv %addr, a0

  # Read the string into the allocated memory.
  li a7, 8
  mv a0, %addr
  mv a1, %size
  ecall
.end_macro

#
# Do a simple for-loop, calling a given macro at each iteration.
#
# Parameters:
#   - %iterator: The register to use as the loop iterator.
#   - %from: The starting value of the iterator.
#   - %to: The ending value of the iterator.
#   - %macro_name: The name of the macro to call at each iteration.
#
.macro for (%iterator, %from, %to, %macro_name)
  addi %iterator, zero, %from
loop:
  %macro_name ()
  addi %iterator, %iterator, 1
  addi %to, %to, -1
  ble %iterator, %to, loop
.end_macro


.macro check ()
  # Load the characters to compare.
  lb t4, 0(t0)
  lb t5, 0(t1)
  
  beq t4, t5, continue
  
  li t2, 0
  jal break
 
continue:
  addi t0, t0, 1
  addi t1, t1, -1
.end_macro

.text
main:
  read_int (s0)
  
  addi s1, s0, 1
  read_str (t0, s1)
  
  add t1, t0, s0
  addi t1, t1, -1
  
  li t2, 1
  for (t3, 1, s0, check)
break:
  print_int (t2)
  print_endl ()

  done
