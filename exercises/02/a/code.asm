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

.data
a: .string ""
b: .string ""
c: .string ""
out: .string ""
endl: .string "\n"

.text
main:
  # Read the integers a, b and c.
  read_int (t0)
  read_int (t1)
  read_int (t2)

  # Add a and b.
  add t3, t0, t1
  print_str ("ADD: ")
  print_int (t3)
  print_endl ()

  # Subtract a and b.
  sub t3, t0, t1
  print_str ("SUB: ")
  print_int (t3)
  print_endl ()

  # Do a AND b operation.
  and t3, t0, t1
  print_str ("AND: ")
  print_int (t3)
  print_endl ()

  # Do a OR b operation.
  or t3, t0, t1
  print_str ("OR: ")
  print_int (t3)
  print_endl ()

  # Do a XOR b operation.
  xor t3, t0, t1
  print_str ("XOR: ")
  print_int (t3)
  print_endl ()

  # Do c AND 31 operation. Save the result in t3.
  andi t3, t2, 31
  print_str ("MASK: ")
  print_int (t3)
  print_endl ()

  # Do a << t3 and b >> t3 operations.
  sll t4, t0, t3
  srl t5, t1, t3
  print_str ("SLL(")
  print_int (t3)
  print_str ("): ")
  print_int (t4)
  print_endl ()

  print_str ("SRL(")
  print_int (t3)
  print_str ("): ")
  print_int (t5)
  print_endl ()

  done
