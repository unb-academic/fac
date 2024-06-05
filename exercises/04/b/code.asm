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

.macro valid_input (%reg)
  ble %reg, a0, invalid_input
.end_macro

.macro gcd (%a, %b)
loop:
  beq %b, zero, found_gcd  
  rem t2, %a, %b
  mv %a, %b
  mv %b, t2
  j loop
found_gcd:
.end_macro

.macro lcm (%a, %b)
  mul a6, %a, %b
  gcd (%a, %b)
  div t6, a6, %a
.end_macro

.text
main:
  read_int (t0)
  read_int (t1)

  li a0, 1
  valid_input (t0) # t0 > 1
  valid_input (t1) # t1 > 1

  # Move our numbers to another place to not lose them
  mv a0, t0
  mv a1, t1 

  gcd (a0, a1)
  print_int (a0)
  print_endl ()

  # Move our numbers back
  mv a4, t0
  mv a5, t1

  lcm (a4, a5)
  print_int (t6)
  print_endl ()

  j exit
invalid_input:
  print_str ("Entrada invalida.")
  print_endl ()
  j exit
exit:
  done
