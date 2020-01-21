.data
.text
main:
			jal lecture_entier
			or $a0, $zero, $v0
			ori $v0, $zero, 1
			syscall
			ori $v0, $zero, 10
			syscall

lecture_entier:
			ori $t0, $zero, 47			# Code ASCII 0 - 1
			ori $t1, $zero, 58			# Code ASCII 9 + 1
while_lect_entier:
			ori $v0, $zero, 12
			syscall
			slt $t2, $t0, $v0
			slt $t3, $v0, $t1
			and $t2, $t2, $t3			# Est-ce que le caractère rentré correspond à un nombre?
			beq $t2, $zero, while_lect_entier

			subi $v0, $v0, 48			# Conversion caractère -> entier

			jr $ra
