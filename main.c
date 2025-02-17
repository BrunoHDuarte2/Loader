#include <stdio.h>
#include <stdlib.h>
extern void carregador(int sizeFour, int addressFour, int sizeThree, int addressThree, int sizeTwo, int addressTwo, int sizeOne, int addressOne, int programSize);

int main(int argc, char *argv[]) {
	switch (argc-1){
	    case 3:
		carregador(atoi(argv[1]), atoi(argv[2]), atoi(argv[3]), 0,0,0,0,0,0);
		break;
	    case 5:
		carregador(atoi(argv[1]), atoi(argv[2]), atoi(argv[3]), atoi(argv[4]), atoi(argv[5]),0,0,0,0);
		break;
	    case 7:
		carregador(atoi(argv[1]), atoi(argv[2]), atoi(argv[3]), atoi(argv[4]), atoi(argv[5]), atoi(argv[6]), atoi(argv[7]),0,0);
		break;
	    case 9:
		carregador(atoi(argv[1]), atoi(argv[2]), atoi(argv[3]), atoi(argv[4]), atoi(argv[5]), atoi(argv[6]), atoi(argv[7]), atoi(argv[8]), atoi(argv[9]));
		break;
    }
    return 0;
}

