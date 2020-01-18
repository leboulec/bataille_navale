	.data
grille:	.space 400						# Grille de 10x10
	.text

main:
		subu $sp, $sp, 64
		sw $fp, 60($sp)
		addu $fp, $sp, 64

		la $a0, grille ###TEST
		sw $a0, 0($fp)
		jal init_grille

		lw $a0, 0($fp)
		
		ori $v0, $zero, 10
		syscall


init_grille: 							# Fonction initialisant un tableau de int de taille 10x10 à 0
										# Argument $a0 : adresse du tableau à initialiser

		ori $t0, $zero, 0				# i=0
		ori $t2, $zero, 1
for_init_grille:
		sw $t2, 0($a0)				# T[i] <- 0
		addi $t0, $t0, 1
		addi $a0, $a0, 4
		slti $t1, $t0, 100				# $t1 <- i<100
		bne $t1, $zero, for_init_grille

		jr $ra

