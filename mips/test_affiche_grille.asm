	.data
grille:			.space 400				# Grille de 10x10
bord_grille: 	.asciiz "___________________________________________\n"
numColonne:		.asciiz "|.| 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |\n"
separateur:		.asciiz " |"
	.text

main:
		subu $sp, $sp, 64				## Allocation d'un espace de 64o pour le main
		sw $fp, 60($sp)					## Copie de $fp
		addu $fp, $sp, 64				## Mise à jour de $fp

		la $a0, grille					# Appel de init grille
		sw $a0, 0($sp)					# Sauvegarde de l'argument(pointeur sur la grille) sur la pile
		jal init_grille
		lw $a0, 0($sp)					# Restauration de l'argument
		
		ori $t0, $zero, -1
		sw $t0, 8($a0)

		ori $t0, $zero, -2
		sw $t0, 100($a0)

		la $a0, grille					# Appel de affiche_grille
		sw $a0, 0($sp)					# Sauvegarde de l'argument
		jal affiche_grille
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


affiche_grille:							# Fonction affichant la grille
										# Argument $a0 : adresse de la grille
		lw $t0, 0($a0)					# $t0 <- T[0]
		or $t6, $zero, $a0				# $t6 <- T

		la $a0, bord_grille				# Affichage du bord supérieur de la grille
		ori $v0, $zero, 4
		syscall							
		la $a0, numColonne
		ori $v0, $zero, 4
		syscall							

		ori $t1, $zero, 0				# $t1 <- ligne = 0

for_aff_grille_ligne:
		ori $a0, $zero, 124				# Affichage de |k| où k est le numéro de la ligne Code ASCII | = 124
		ori $v0, $zero, 11				# Code service affiche caractère
		syscall
		or $a0, $zero, $t1
		ori $v0, $zero, 1
		syscall
		ori $a0, $zero, 124	
		ori $v0, $zero, 11
		syscall
		ori $t2, $zero, 0				# $t2 <- colonne = 0

for_aff_grille_colonne:
										# $t3 <- caractère à afficher
			ori $t3, $zero, 126			# Code ASCII ~ = 126
			beq $t0, $zero, suite_bat	# Si T[i][j] == 0 (on a pas touché cette case)
			slti $t4, $t0, -1			# Si T[i][j] == -2 (il y avait rien)
			bne $t4, $zero si_pas_bat
										# Si T[i][j] == -1 (il y avait un bateau)
si_bat:		ori $t3, $zero, 79			# Code ASCII O = 79
			j suite_bat
si_pas_bat:	ori $t3, $zero, 88			# Code ASCII X = 88
			j suite_bat
suite_bat:
			ori $a0, $zero, 32			# Code ASCII ESPACE = 32
			ori $v0, $zero, 11
			syscall
			or $a0, $zero, $t3			# Caractère à afficher (~, X, O)
			ori $v0, $zero, 11
			syscall
			la $a0, separateur			## " |"
			ori $v0, $zero, 4
			syscall

			addi $t2, $t2, 1			# colonne++
			addi $t6, $t6, 4
			lw $t0, 0($t6)				# $t0 <- T[i++]

			slti $t5, $t2, 10			# $t5 <- colonne < 10
			bne $t5, $zero, for_aff_grille_colonne

		ori $a0, $zero, 10 				# Code ASCII \n = 10
		ori $v0, $zero, 11
		syscall

		addi $t1, $t1, 1
		slti $t5, $t1, 10				# $t5 <- ligne < 10
		bne $t5, $zero, for_aff_grille_ligne
										# Fin des boucles
		la $a0, bord_grille
		ori $v0, $zero, 4
		syscall

		jr $ra
