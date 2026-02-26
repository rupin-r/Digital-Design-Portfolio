#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

extern void lab_7(int x);
char* beatmap;

int main()
{
   FILE *fptr;
   beatmap = malloc(1024);
   char* copy = beatmap;
   fptr = fopen("C:/Users/2Cool/SavePlace/SampleDDR.txt", "r");
   if(fptr != NULL){
       fread(copy, sizeof(char), 1000, fptr);
       fclose(fptr);
       lab_7((int)(beatmap));
   }
}
