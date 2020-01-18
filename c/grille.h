#ifndef __GRILLE_H__
#define __GRILLE_H__
#define N 10

/* Pose nbBateau bateau de taille taille aléatoirement sur la grille
 * Renvoie le nombre de bateaux */
int poseBateau(int grille[N][N], int taille, int nbBateau);

/* Initialise la grille avec que des 0 */
void initGrille(int grille[N][N]);

/* Affiche tous les bateaux si mode vaut d
 * Affiche la grille cachée si mode vaut j*/
void afficheGrille(int grille[N][N], char mode);

/* Remplit la grille en appelant poseBateau
 * Renvoit le nombre de bateaux */
int remplitGrille(int grille[N][N]);

/* Vérifie si le bateau numBateau est encore à flots */
int encoreBateau(int grille[N][N], int numBateau);

/* Tire une torpille */
void tire(int grille[N][N], int* nbBateaux);

/*  record */
void tableau_score(char* filename, int score);

#endif
