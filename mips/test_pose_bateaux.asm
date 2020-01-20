	.data
grille:			.space 400				# Grille de 10x10
bord_grille: 	.asciiz "___________________________________________\n"
numColonne:		.asciiz "|.| 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |\n"
separateur:		.asciiz " |"
	.text

main:
		subu $sp, $sp, 64				## Allocation d'un espace de 64o pour le main
		addu $fp, $sp, 64				## Mise à jour de $fp

		la $a0, grille					# Appel de init grille
		jal init_grille
		
		ori $s0, $zero, 1				# $s0 <- nombre total de bateaux posés + 1 ##IMPERATIF : variable utilisée par les fonctions (globale)##
		la $a0, grille
		ori $a1, $zero, 1
		ori $a2, $zero, 1				# Pose d'un bateau de taille 1
		jal pose_bateaux
		or $s0, $zero, $v0

		la $a0, grille
		ori $a1, $zero, 1
		ori $a2, $zero, 3				# Pose d'un bateau de taille 3
		jal pose_bateaux
		or $s0, $zero, $v0

		la $a0, grille
		ori $a1, $zero, 3
		ori $a2, $zero, 5				# Pose de 3 bateaux de taille 5
		jal pose_bateaux
		or $s0, $zero, $v0

		la $a0, grille
		ori $a1, $zero, 4
		ori $a2, $zero, 2				# Pose de 4 bateaux de taille 2
		jal pose_bateaux
		or $s0, $zero, $v0

		la $a0, grille					# Appel de debug_affiche_grille
		jal debug_affiche_grille

		ori $v0, $zero, 10
		syscall


init_grille: 							# Fonction initialisant un tableau de int de taille 10x10 à 0
										# Argument $a0 : adresse du tableau à initialiser
		ori $t0, $zero, 0				# $t0 <- i=0
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
		ori $a0, $zero, 124				# Affichage de |k| où k est le numéro de la ligne. Code ASCII | = 124
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
			bgez $t0, suite_bat			# Si T[i][j] >= 0 (on a pas touché cette case)
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
			lw $t0, 0($t6)				# $t0 <- T[colonne]

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


debug_affiche_grille:					# Fonction affichant tous les bateaux sur la grille
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
										# $t6 <- addresse de l'élément à afficher

debug_for_aff_grille_ligne:
		ori $a0, $zero, 124				# Affichage de |k| où k est le numéro de la ligne. Code ASCII | = 124
		ori $v0, $zero, 11				# Code service affiche caractère
		syscall
		or $a0, $zero, $t1
		ori $v0, $zero, 1
		syscall
		ori $a0, $zero, 124	
		ori $v0, $zero, 11
		syscall

		ori $t2, $zero, 0				# $t2 <- colonne = 0

debug_for_aff_grille_colonne:

			ori $a0, $zero, 32			# Code ASCII ESPACE = 32
			ori $v0, $zero, 11
			syscall
			lw $a0, 0($t6)				# élément de la grille à afficher
			ori $v0, $zero, 1
			syscall
			la $a0, separateur			## " |"
			ori $v0, $zero, 4
			syscall

			addi $t2, $t2, 1			# colonne++
			addi $t6, $t6, 4
			lw $t0, 0($t6)				# $t0 <- T[colonne]

			slti $t5, $t2, 10			# $t5 <- colonne < 10
			bne $t5, $zero, debug_for_aff_grille_colonne

		ori $a0, $zero, 10 				# Code ASCII \n = 10
		ori $v0, $zero, 11
		syscall

		addi $t1, $t1, 1
		slti $t5, $t1, 10				# $t5 <- ligne < 10
		bne $t5, $zero, debug_for_aff_grille_ligne
										# Fin des boucles
		la $a0, bord_grille
		ori $v0, $zero, 4
		syscall

		jr $ra


pose_bateaux:							# Fonction posant un nombre de bateux de même taille aléatoirement sur la grille
										# Arguments : $a0 <- adresse de la grille, $a1 <- nombre de bateaux à poser, $a2 <- taille des bateaux à poser
										# Retourne dans $v0 le numéro du dernier bateau posé + 1 : numéro du prochain bateau
		subu $sp, $sp, 64				## Prologue
		sw $fp, 60($sp)					##
		addu $fp, $sp, 64				##
		sw $a0, 0($sp)					# Sauvegarde de l'adresse de la grille
		sw $s0, 4($sp)					# Sauvegarde du nombre de bateaux total sur la grille	###A RESTAURER IMPERATIVEMENT###
		sw $s1, 8($sp)					# Sauvegarde de $s1										###A RESTAURER IMPERATIVEMENT###
		or $t1, $zero, $a1				# $t1 <- nombre de bateaux à poser

		ori $t0, $zero, 0				# $t0 <- i=0
for_pose_bateaux:
while_pose_bateaux:
		ori $a0, $zero, 7364			# $a0 <- seed
		ori $a1, $zero, 10				# $a1 <- randmax + 1
		ori $v0, $zero, 42				# Code service random
		syscall
		or $t3, $zero, $a0				# $t3 <- x = rand()

		ori $a0, $zero, 7364			# $t4 <- y = rand()
		ori $a1, $zero, 10
		ori $v0, $zero, 42
		syscall
		or $t4, $zero, $a0

		ori $a0, $zero, 7364			# $t5 <- orientation = rand()
		ori $a1, $zero, 2
		ori $v0, $zero, 42
		syscall
		or $t5, $zero, $a0

		ori $t2, $zero, 10
		mult $t4, $t2
		mflo $t7
		add $t7, $t7, $t3
		ori $t2, $zero, 4
		mult $t7, $t2
		mflo $s1						# $s1 <- Addresse relative de T[x][y]

		beq	$t5, $zero, if_pose_bateaux_vert # Si l'orientation est verticale jump

										# Sinon l'orientation est horizontale
		sub $t6, $zero, $a2				# $t6 <- -tailleBateauxAPoser
		addi $t6, $t6, 10				# $t6 <- tailleGrille - tailleBateauxAPoser
		slt $t6, $t6, $t3				# $t6 <- x > tailleGrille - tailleBateauxAPoser
		bne $t6, $zero, while_pose_bateaux	# La pose est impossible, on revient au début du while	###$t2 DISPO###

		###JE ME SUIS PERDU DANS LES FOR: A REFAIRE###

		lw $t6, 0($sp)
		add $t6, $t6, $s1				# $t6 <- addresse de l'élément du tableau à tester
		or $t2, $zero, $t3				# $t2 <- i=x
for_pose_bat_hor:
		lw $t7, 0($t6)					# $t7 <- élément du tableau à tester
		bne $t7, $zero, while_pose_bateaux # La pose est impossible, on revient au début du while
		addi $t2, $t2, 1				# i++
		addi $t6, $t6, 4				# T[x+1][y]
		add $t8, $t3, $a2				# $t8 <- x + tailleBateauxAPoser
		slt $t8, $t2, $t8				# $t8 <- i < x + tailleBateauxAPoser
		bne $t8, $zero, for_pose_bat_hor

		j suite_if_pose_bateaux_vert
if_pose_bateaux_vert:
		sub $t6, $zero, $a2				# $t6 <- -tailleBateauxAPoser
		addi $t6, $t6, 10				# $t6 <- tailleGrille - tailleBateauxAPoser
		slt $t6, $t6, $t4				# $t6 <- y > tailleGrille - tailleBateauxAPoser
		bne $t6, $zero, while_pose_bateaux	# La pose est impossible, on revient au début du while	###$t2 DISPO###

		lw $t6, 0($sp)
		add $t6, $t6, $s1				# $t6 <- addresse de l'élément à tester dans la grille
		or $t2, $zero, $t4				# $t2 <- i=y
for_pose_bat_vert:
		lw $t7, 0($t6)					# $t7 <- élément à tester dans la grille
		bne $t7, $zero, while_pose_bateaux # La pose est impossible, on revient au début du while
		addi $t2, $zero, 1				# i++
		addi $t6, $t6, 40				# T[x][y+1]
		add $t8, $t4, $a2				# $t8 <- y + tailleBateauxAPoser
		slt $t8, $t2, $t6				# $t8 <- i < y + tailleBateauxAPoser
		bne $t8, $zero, for_pose_bat_hor

suite_if_pose_bateaux_vert:
		bne $t5, $zero, orientation_pose_bateaux # Si l'orientation est horizontale, on jump
										# Sinon l'orientation est verticale
		lw $t6, 0($sp)
		add $t6, $t6, $s1				# $t6 <- addresse de l'élément à remplacer dans la grille
		ori $t2, $zero, 0				# $t2 <- i=0
for_pose_bateaux_pose_ver:
		sw $s0, 0($t6)					# On remplace dans la grille avec le numéro du bateau
		addi $t2, $t2, 1
		addi $t6, $t6, 40
		slt $t8, $t2, $a2				# i < tailleBateau
		bne $t8, $zero, for_pose_bateaux_pose_ver

		j suite_if_orientation_pose_bateaux

orientation_pose_bateaux:

		lw $t6, 0($sp)
		add $t6, $t6, $s1				# $t6 <- addresse de l'élément à tester dans la grille
		ori $t2, $zero, 0				# $t2 <- i=0
for_pose_bateaux_pose_hor:
		sw $s0, 0($t6)					# On remplace dans la grille avec le numéro du bateau
		addi $t2, $t2, 1
		addi $t6, $t6, 4
		slt $t8, $t2, $a2				# i < tailleBateau
		bne $t8, $zero, for_pose_bateaux_pose_hor

suite_if_orientation_pose_bateaux:

		addi $t0, $t0, 1
		addi $s0, $s0, 1				# Un bateau posé : on passe à l'indice suivant
		slt $t8, $t0, $t1				# i < nbBateauxAPoser
		bne $t8, $zero, for_pose_bateaux

										# EPILOGUE
		or $v0, $zero, $s0				# Retourne le numéro du dernier bateau posé
		lw $s0, 4($sp)					# Restauration de $s0
		lw $s1, 8($sp)					# Restauration de $s1
		lw $fp, 60($sp)					# Restauration de $fp
		addu $sp, $sp, 64				# Ajustement de $sp
		jr $ra
