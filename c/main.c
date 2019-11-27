#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "grille.h"

int main(){
	srand (time (NULL));
	int grille[N][N];
	initGrille(grille);
	int nbBateaux = remplitGrille(grille) - 1;
	int nbCoup = 0;
	while(nbBateaux){
		tire(grille, &nbBateaux);
		printf("Il reste %d bateaux\n", nbBateaux);
		afficheGrille(grille, 'j');
		nbCoup++;
	}
	printf("Bravo ! Vous avez gagné en %d coups !\n", nbCoup);
	afficheGrille(grille, 'd');
}
