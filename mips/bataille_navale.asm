	.data
grille:	.space 400						# Grille de 10x10
	.text

main:
		subu $sp, $sp, 64
		sw $fp, 60($sp)
		addu $fp, $sp, 64

		la $a0, grille					# Appel de init grille
		sw $a0, 0($sp)					# Sauvegarde de l'argument(pointeur sur la grille) sur la pile
		jal init_grille
		lw $a0, 0($sp)					# Restauration de l'argument
		
		ori $v0, $zero, 10
		syscall


init_grille: 							# Fonction initialisant un tableau de int de taille 10x10 à 0
										# Argument $a0 : adresse du tableau à initialiser

		ori $t0, $zero, 0				# i=0
for_init_grille:
		sw $zero, 0($a0)				# T[i] <- 0
		addi $t0, $t0, 1
		addi $a0, $a0, 4
		slti $t1, $t0, 100				# $t1 <- i<100
		bne $t1, $zero, for_init_grille

		jr $ra
