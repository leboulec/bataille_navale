#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "grille.h"

void initGrille(int grille[N][N]){

	for(int e=0; e<N; e++){ 
		for(int f=0; f<N; f++){

			grille[e][f] = 0;
		}
	}

}


void afficheGrille(int grille[N][N]){

	printf("_____________________\n");

	for(int ligne=0; ligne<N; ligne++){ 

		printf("|");

		for(int colonne=0; colonne<N; colonne++){

			if(grille[ligne][colonne] == 0){

				printf("~|");
				
			}

			else if(grille[ligne][colonne] == 4){
				printf("¤|");

			}

			else if(grille[ligne][colonne] == 1){
				printf("#|");

			}
			
			else if(grille[ligne][colonne] == 2){
				printf("O|");

			}

			else if(grille[ligne][colonne] == 3){
				printf("$|");

			}

			else if(grille[ligne][colonne] == 5){
				printf("@|");

			}

		} 

	printf("\n");
	}
	
	printf(" ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞͞͞ ͞͞ ͞͞ ͞͞  \n");
	
}

/*  1 porte-avions (5 cases) ----> rempli avec 5
    1 croiseur (4 cases) -----> rempli avec 4
    1 contre-torpilleurs (3 cases) -----> rempli avec 3
    1 contre-torpilleurs (3 cases) -----> rempli avec 3
    1 torpilleur (2 cases) -----> rempli avec 2 */


void poseBateau(int grille[N][N], int taille, int nombre_bateau){

	static int numBateau = 1;

	/* Installation des porte avions */

	for(int i = 0; i<nombre_bateau;i++){

		int x, y, orientation;
		int flag = 0;

		while(!flag){

			x = (int)(rand() / (double)RAND_MAX * (N - 1));
			y = (int)(rand() / (double)RAND_MAX * (N - 1));
			orientation = (int)(rand() / (double)RAND_MAX * 2);

			if(orientation==1){ // horizontal
				if(x <= N - taille){
					flag = 1;
					for(int e = x; e<(x+taille); e++){ //check si les cases sont vides
						if(grille[e][y]!=0){
							flag=0;
						}
					}
				}
			} else {
				if(y <= N - taille){
					flag = 1;
					for(int e = y; e<(y+taille); e++){ //check si les cases sont vides
						if(grille[x][e]!=0){
							flag=0;
						}
					}
				}

			}
		}

		if(orientation == 0){ //vertical
			for(int p=0; p<taille;p++){
				grille[x][y+p] = numBateau;
			}
		} else {
			for(int p=0; p<taille;p++){
				grille[x+p][y] = numBateau;
			}

		}
	numBateau++;
	}
}

void remplitGrille(int grille[N][N]){

	poseBateau(grille,5,1);
	poseBateau(grille,4,1);
	poseBateau(grille,3,2);
	poseBateau(grille,2,1);
}
		




int main(){
	srand (time (NULL));
	int grille[N][N];

	initGrille(grille);
	remplitGrille(grille);
	afficheGrille(grille);
}
