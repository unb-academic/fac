.data
a: .string ""
b: .string ""
c: .string ""
endl: .string "\n"

.text
main:
  # read integer from input
  li a7, 4
  la a0, a
  ecall
  li a7, 5
  ecall
  mv t0, a0

  # read integer from input
  li a7, 4
  la a0, b
  ecall

  li a7, 5
  ecall
  mv t1, a0

  # sum
  add t2, t0, t1
  li a7, 4
  la a0, c
  ecall

  li a7, 1
  mv a0, t2
  ecall

  # print newline
  li a0, 1
  la a1, endl
  # the length of the string
  li a2, 1
  # 64 = write
  li a7, 64
  ecall

  # exit
  li a0, 0
  li a7, 93
  ecall
