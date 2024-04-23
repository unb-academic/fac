.data
str:
  .string "Ola Mundo\n"

.text
main:
  # li = load immediate
  # la = load address

  # 1 = stdout
  li a0, 1
  la a1, str
  # this is the length of our string (10 characters)
  li a2, 10
  # 64 = write
  li a7, 64
  ecall

  # 0 = return code
  # 93 = exit syscall
  li a0, 0
  li a7, 93
  ecall
