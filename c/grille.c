#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "grille.h"

void initGrille(int grille[N][N]){

	for(int e=0; e<N; e++){ //parcours par ligne
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

			else{
				printf("¤|");

			}
			
		} 

	printf("\n");
	}
	
	printf(" ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞ ͞͞͞͞ ͞͞ ͞͞ ͞͞  \n");
	
}

/*  1 porte-avions (5 cases) ----> rempli avec 1
    1 croiseur (4 cases) -----> rempli avec 2
    1 contre-torpilleurs (3 cases) -----> rempli avec 3
    1 contre-torpilleurs (3 cases) -----> rempli avec 4
    1 torpilleur (2 cases) -----> rempli avec 5 */

void rempliGrille(int grille[N][N]){

	int e = 1;

	while(e<=5){

		if(  ((int)(rand() / (double)RAND_MAX))==1  )

			int i = (int)(rand() / (double)RAND_MAX * (N - 1));
			int j = (int)(rand() / (double)RAND_MAX * (N - 1));


	grille[i][j] = e;
	e++;

	}
}


int main(){
	srand (time (NULL));
	int grille[N][N];

	initGrille(grille);
	rempliGrille(grille);
	afficheGrille(grille);


}
