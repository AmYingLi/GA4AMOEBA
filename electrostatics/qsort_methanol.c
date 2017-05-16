#include <stdio.h>
#include <stdlib.h>
#include <math.h>
//#define num_procs  32 // size of your array
#define pcross 0.5
#define number 17

struct myData {
    double data[number];
    int my_id; // will hold the original position of data on your array
};

int myData_compare (const void* a, const void* b) {
    return ((struct myData*)a)->data[0] < ((struct myData*)b)->data[0] ? -1 : ((struct myData*)a)->data[0] > ((struct myData*)b)->data[0];
}

int main () {

    int i, j, num_procs;
    float rank, c;
    FILE * fin;
    fin = fopen("c_in.txt", "r");
    fscanf(fin, "%d\n", &num_procs);
    struct myData* array = (struct myData*) malloc(num_procs * sizeof(struct myData));
    for (i = 0; i < num_procs; i++) {
        for (j = 0; j < number; j++ ) {
            fscanf(fin, "%lf\t",&array[i].data[j]);
            /*printf("%lf\t",array[i].data[j]);*/
        }
        fscanf(fin, "%d\n", &array[i].my_id);
        /*printf("%d\n", array[i].my_id);*/
    }
    fclose(fin);
    qsort(array, num_procs, sizeof(struct myData), myData_compare);
    int ncross = (int) num_procs * pcross;
    printf("%d\n",ncross);
    for (i = 0; i < ncross; i++) {
        for (j = 0 ; j < number; j++) {
            printf("%lf\t", array[i].data[j]);
        }
        /*printf("%d\n", array[i].my_id);*/
        rank = (float) (ncross-i-1)/((ncross-1)*ncross/2.0);
        /*c = (float) (ncross*2*(ncross-1))/(6*(ncross-1)+ncross);
        rank = (float) exp(-1.0*(i+1)/c);*/
        printf("%lf\n", rank);
    }
    return 0;
}
