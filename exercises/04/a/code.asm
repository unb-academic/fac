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
  # i = %from
  li %iterator, %from
loop:
  %macro_name ()
  # i += 2
  addi %iterator, %iterator, 2
  # if i * i <= %to
  mul t4, %iterator, %iterator
  ble t4, %to, loop
.end_macro

# if (t0 % t3) == 0 => not prime
.macro check_divisibility ()
  rem t5, t0, t3
  beqz t5, not_prime
.end_macro

.text
main:
  read_int (t0)

  # if t0 <= 0 => invalid input
  ble t0, zero, invalid_input

  # t1 = 2
  li t1, 2

  # if t0 < 2 => not prime
  blt t0, t1, not_prime

  # if t0 == 2 => prime
  beq t0, t1, prime

  # if (t0 % 2) == 0 => not prime
  rem t2, t0, t1
  beq t2, zero, not_prime

  # if t0 == 3 => prime
  li t1, 3
  beq t0, t1, prime

  # for (t3 = 3; t3 * t3 <= n; t3 += 2) { check_divisibility (t0, t3) }
  for (t3, 3, t0, check_divisibility)
  j prime
invalid_input:
  print_str ("Entrada invalida.")
  j exit
not_prime:
  print_str ("nao")
  j exit
prime:
  print_str ("sim")
  j exit
exit:
  print_endl ()
  done
