#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "grille.h"
#define MAX(a,b) a>b ? a:b

void initGrille(int grille[N][N]){

	for(int e = 0; e < N; e++){ 
		for(int f = 0; f < N; f++){
			grille[e][f] = 0;
		}
	}
}

void afficheGrille(int grille[N][N], char mode){

	int k = 0;
	printf("___________________________________________\n");
	printf("|.| 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |\n");

	for(int ligne = 0; ligne < N; ligne++){ 

		printf("|%d|",k);
		k++;

		for(int colonne = 0; colonne < N; colonne++){

			if(mode == 'd'){
				switch(grille[ligne][colonne]){
					case -2:
						printf(" x |");
						break;
					case -1:
						printf(" X |");
						break;
					case 0:
						printf(" ~ |");
						break;
					case 1:
						printf(" # |");
						break;
					case 2:
						printf(" O |");
						break;
					case 3:
						printf(" $ |");
						break;
					case 4:
						printf(" $ |");
						break;
					case 5:
						printf(" @ |");
						break;
					default:
						printf(" B |");
				}
			} else{
				if(grille[ligne][colonne] == -1){
					printf(" O |");}

				else if(grille[ligne][colonne] == -2){
					printf(" X |");

				}
				else{
					printf(" ~ |");
				}
			}
		}

	printf("\n");
	}
	printf(" ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞͞͞ ͞͞ ͞͞ ͞͞  ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞͞͞ ͞͞ ͞͞ ͞͞    \n");
}

/*  1 porte-avions (5 cases) ----> rempli avec 5
    1 croiseur (4 cases) -----> rempli avec 4
    1 contre-torpilleurs (3 cases) -----> rempli avec 3
    1 contre-torpilleurs (3 cases) -----> rempli avec 3
    1 torpilleur (2 cases) -----> rempli avec 2 */


int poseBateau(int grille[N][N], int taille, int nombre_bateau){
	
	static int numBateau = 1;

	for(int i = 0; i < nombre_bateau; i++){

		int x, y, orientation;
		int flag = 0;

		while(!flag){

			x = (int)(rand() / (double)RAND_MAX * (N - 1));
			y = (int)(rand() / (double)RAND_MAX * (N - 1));
			orientation = (int)(rand() / (double)RAND_MAX * 2);

			if(orientation == 1){ // horizontal
				if(x <= N - taille){
					flag = 1;
					for(int e = x; e < (x+taille); e++){ //check si les cases sont vides
						if(grille[e][y] != 0){
							flag = 0;
						}
					}
				}
			} else {
				if(y <= N - taille){
					flag = 1;
					for(int e = y; e < (y+taille); e++){ //check si les cases sont vides
						if(grille[x][e] != 0){
							flag = 0;
						}
					}
				}

			}
		}

		if(orientation == 0){ //vertical
			for(int p = 0; p < taille; p++){
				grille[x][y+p] = numBateau;
			}
		} else {
			for(int p = 0; p < taille; p++){
				grille[x+p][y] = numBateau;
			}

		}
	numBateau++;
	}
	return numBateau;
}

int remplitGrille(int grille[N][N]){

	int nbBateaux;
	poseBateau(grille,5,1);
	poseBateau(grille,4,1);
	poseBateau(grille,3,2);
	nbBateaux = poseBateau(grille,2,1);

	return nbBateaux-1;
}

int encoreBateau(int grille[N][N], int numBateau){

	for(int i = 0; i < N; i++){
		for(int j = 0; j < N; j++){
			if(grille[i][j] == numBateau){
				return 1;
			}
		}
	}

	return 0;
}

void tire(int grille[N][N], int* nbBateaux){

	int x,y;
	int contenuCase;
	char saisie1[2], saisie2[2];

	printf("Ligne: ");

	while(1){

		fgets(saisie1, 2, stdin);

		if (sscanf(saisie1, "%d", &x) == 0){
			printf("Mauvaise valeur, veuillez réessayer ...\nLigne: ");
		}

		if (sscanf(saisie1, "%d", &x) == 1)break;      
	}

	printf("Colonne: ");

	while(1){

		fgets(saisie2, 2, stdin);

		if (sscanf(saisie2, "%d", &y) == 0){
			printf("Mauvaise valeur, veuillez réessayer ...\nColonne: ");
		}

		if (sscanf(saisie2, "%d", &y) == 1)break; 
		
	}
		
	contenuCase = grille[x][y];
	if(contenuCase > 0){
		grille[x][y] = -1;
		if(encoreBateau(grille, contenuCase)){
			printf("Touché !\n");
		} else {
			printf("Coulé !\n");
			*nbBateaux -= 1;
		}
	} else {
		grille[x][y] = -2;
		printf("Plouf !\n");
	}
}

void tableau_score(char* filename, int score){

	int scoreFichier;
	FILE* fichier;
	char username[50];

	if( (fichier = fopen(filename, "w+")) != NULL){
		fscanf(fichier, "%d", &scoreFichier);

		if(MAX(score, scoreFichier) == scoreFichier){

			printf("Nouveau record !\n");
			printf("Veuillez entrer votre pseudo : ");
			scanf("%s \n", username);
			fprintf(fichier, "MEILLEUR SCORE \n \n%s : %d\n", username, score);
		}
		
		fclose(fichier);

	} else{
		printf("Erreur: impossible d'ouvrir le fichier\n");
	}
}
