#include "antd.h"
#include <stdio.h>
#include <string.h>

void main () {
rt_init();

const char labstr[] = "oooooooo\no.>....x\noooooooo\n";
cstring lab;
lab.str = labstr;
lab.len = strlen(labstr);
PT pt;
printf("creating laby : \n%s",lab.str);
createLabyAntPolyType(lab,&pt);
Ant ant = getAnt(&pt);
for (int i=0;i<5;i++) {
printf("%s\n",showLaby(ant).str);
forward(ant);
}}
void __ant(Ant ant) {
printf("In fornt of me is %d",look(ant) );
}

