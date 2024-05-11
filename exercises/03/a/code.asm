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
.macro read_str (%size, %addr)
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
  ble %iterator, %to, loop
.end_macro

.macro diff ()
  # Load the address
  add s1, t1, t4
  add s2, t2, t4

  # Load the characters
  lb a0, 0(s1)
  lb a1, 0(s2)

  # Compare the characters
  bne a0, a1, diff_not_found

  # If the characters are the same, increment the equal count
  addi t3, t3, 1
diff_not_found:
.end_macro

.text
main:
  read_int (t0)
  addi t0, t0, 1

  read_str (t0, t1)
  read_str (t0, t2)

  # Equal count
  li t3, 0
  
  # Remove the null terminator
  addi t0, t0, -1

  # Loop through the strings
  for (t4, 1, t0, diff)
  
  print_int (t3)
  print_endl ()

  done
