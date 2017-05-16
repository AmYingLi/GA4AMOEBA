#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#define max_type 4

int main()
{
   int i, j, k;
   int NATOMS;
   int *aindex;
   int *aclass;
   char *atype;
   double *x, *y, *z;
   int **bond;
   FILE *fp, *fp0, *fp1;
   const char s[] = " ";
   char *string, *token, *stop;
   size_t nbytes;
   char *C = "C";
   char *H = "H";
   
   fp = fopen("old.xyz", "r");
   fp1 = fopen("new.xyz", "w");
   fscanf(fp, "%d\n", &NATOMS);
   fprintf(fp1,"%d\n",NATOMS);  
 
   aindex = (int *)malloc((NATOMS+1) * sizeof(int));
   aclass = (int *)malloc(sizeof(int) * (NATOMS+1));
   atype = (char *)malloc(sizeof(char) * (NATOMS+1)); 
   x = (double *)malloc(sizeof(double) * (NATOMS+1));
   y = (double *)malloc(sizeof(double) * (NATOMS+1));
   z = (double *)malloc(sizeof(double) * (NATOMS+1));
   bond = (int **)malloc((NATOMS+1) * sizeof(int *));
   for(i = 1; i < NATOMS+1; i++)
   {
      bond[i] = (int *)malloc(sizeof(int) * max_type);
   } 
 
   /* get the first token */
   for (i=1; i<NATOMS+1; i++)
   {
      getline(&string, &nbytes, fp);
      token = strtok(string, s);
   /* walk through other tokens */
      aindex[i] = strtol(token, &stop, 0);
      token = strtok(NULL, s);
      atype[i] = *token;
      token = strtok(NULL, s);
      x[i] = strtod(token, &stop);
      token = strtok(NULL, s);
      y[i] = strtod(token, &stop);
      token = strtok(NULL, s);
      z[i] = strtod(token, &stop);
      token = strtok(NULL, s);
      aclass[i] = strtol(token, &stop, 0);
      token = strtok(NULL, s);
      j = 0;
      while( token != NULL ) 
      {
         bond[i][j] = strtol(token, &stop, 0);
         j++;
         token = strtok(NULL, s);
      }   
   }
   fp0 = fopen("old.xyz", "r");
   fscanf(fp0, "%d\n", &NATOMS);
   for (i=1; i<NATOMS+1; i++)
   {
      getline(&string, &nbytes, fp0);
      token = strtok(string, s);
      k = 0;
      while(k<6) {
         token = strtok(NULL, s);
         k++;
      }
      j = 0;
      while( token != NULL ) 
      {
         token = strtok(NULL, s);
         j++;
      }   
      if (j==1) aclass[i]=218;
      else if(j==3) {
           if (atype[bond[i][0]]==C[0] && atype[bond[i][1]]==C[0] && atype[bond[i][2]]==C[0]) aclass[i]=999;
           else if ( ((atype[bond[i][0]]==H[0] && atype[bond[i][1]]==C[0] && atype[bond[i][2]]==C[0]))|| \
                     ((atype[bond[i][0]]==C[0] && atype[bond[i][1]]==H[0] && atype[bond[i][2]]==C[0]))|| \
                     ((atype[bond[i][0]]==C[0] && atype[bond[i][1]]==C[0] && atype[bond[i][2]]==H[0])) ) {
              aclass[i]=217;
              //printf("%d %d %d %c %d %c %d %c\n",aindex[i],i+1,bond[i][0],atype[bond[i][0]],bond[i][1],atype[bond[i][1]],bond[i][2],atype[bond[i][2]]);
              //printf("%d %d %c %d %c %d %c\n",i,bond[i][0],atype[bond[i][0]],bond[i][1],atype[bond[i][1]],bond[i][2],atype[bond[i][2]]);
           }
      }
      fprintf(fp1,"%d\t%c\t%lf\t%lf\t%lf\t%d\t",aindex[i],atype[i],x[i],y[i],z[i],aclass[i]);
      for (k = 0; k < j; k ++) fprintf(fp1,"%d\t", bond[i][k]);
      fprintf(fp1,"\n");     
   }
   free(aindex); 
   free(aclass); 
   free(atype); 
   free(x); 
   free(y); 
   free(z); 
   free(bond);
   fclose(fp);
   fclose(fp0); 
   return(0);
}

