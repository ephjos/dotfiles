#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

void progress(){
	double i = 0;
	double size = 100000;
	double percent = 0.0;
	char bar[100];
	strcpy(bar,"                                                                                            ");
	int next = 0;
	fputs("\e[?25l", stdout);
  for (i = 0; i < size; i++){
		percent = (i/size)*100;
		if(fmod(percent,1.0)==0){
			bar[next]='#';
			next++;
		}
		printf("\r[%s] %.1f%\r", bar,(i/size)*100);
		fflush(stdout);
  }
	fputs("\e[?25h", stdout);
  printf("\n");
}

