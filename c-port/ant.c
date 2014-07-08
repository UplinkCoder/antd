/** This is a rewrite of a programm written in D
    It is made to show how D-coding does affect C code :D
    I found it is generally much cleaner compared to C form scratch */
typedef unsigned int uint; // short typenames are much less typing
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "ant.h"
#include "laby.h"

#if __MAIN__
int main(int argc,char *argv[]) {
      Ant* ant = createAnt("ooo\n<..\nooo");
      printf("in fornt of me is a %d\n",look(ant));
      for(int i=0;i<16;i++) {
         forward(ant);
         printf("now in fornt of me is a %d\n",look(ant));
         printf("%s",show(ant->m_laby,ant->ori));
     }
}
#endif
Ant* createAnt(char* str) {
Laby* laby = malloc(sizeof(Laby));
uint xmax=1,ymax=1;
Ant* ant = malloc(sizeof(Ant));
// No AA so I have to get the dimensions of the lab before I can build it.
for (uint i=0,x=0;i<strlen(str);i++,x++) {
   if (str[i] == '\n') {
      ymax++;
      x=0;
   } else {
      if (x>xmax) xmax++;
  }
}
printf("Labyrinth has %d by %d tiles\n",xmax,ymax);
laby->lab = malloc(xmax*ymax);
laby->xmax = xmax;
laby->ymax = ymax;
for (uint i=0,x=0,y=0;i<strlen(str);i++,x++) {
   // No Unicode support so I can't take the original format.
   switch (str[i]) {
      case '\n': y++,x=0;
      break;
      case '.' : laby->lab[(y*xmax)+x] = Void;
      break;
      case 'o' : laby->lab[(y*xmax)+x] = Wall;
      break;
      case 'r' : laby->lab[(y*xmax)+x] = Rock;
      break;
      case 'w' : laby->lab[(y*xmax)+x] = Web;
      break;
      case '^' : laby->lab[(y*xmax)+x] = _Ant;
                 ant->pos.x=x;ant->pos.y=y;
                 ant->ori = North;
      break;
      case '>' : laby->lab[(y*xmax)+x] = _Ant;
                  ant->pos.x=x;ant->pos.y=y;
                  ant->ori = East;
      break;
      case 'v' : laby->lab[(y*xmax)+x] = _Ant;
                  ant->pos.x=x;ant->pos.y=y;
                  ant->ori = South;
      break;
      case '<' : laby->lab[(y*xmax)+x] = _Ant;
                 ant->pos.x=x;ant->pos.y=y;
                 ant->ori = West;
      break;
      }
   }
   ant->m_laby = laby;
   return ant;
}
void destroyAnt(Ant* ant) {
free(ant->m_laby->lab);
free(ant->m_laby);
free(ant);
}
pos_t inFront(Ant* ant) {
   static pos_t pos;
   switch (ant->ori) {
     case North : pos.x = ant->pos.x;
                  pos.y = ant->pos.y-1;
     break;
     case East :  pos.x = ant->pos.x+1;
                  pos.y = ant->pos.y;
     break;
     case South : pos.x = ant->pos.x;
                  pos.y = ant->pos.y+1;
     break;
     case West :  pos.x = ant->pos.x-1;
                  pos.y = ant->pos.y;
     break;
    }
   return pos;
}
uint p2p (Laby* l,pos_t p) {
    return (p.y*l->xmax+p.x);
}
LabyObject look(Ant* ant) {
   Laby* laby = ant->m_laby;
   return laby->lab[p2p(laby,inFront(ant))];
}
bool forward(Ant* ant) {
   if (look(ant) == Void) {
      ant->m_laby->lab[p2p(ant->m_laby,inFront(ant))] = _Ant;
      ant->m_laby->lab[p2p(ant->m_laby,ant->pos)] = Void;
      ant->pos = inFront(ant);
      return true;
   } else  {
     if (look(ant) == Web) say("Ahhh a spider drop a rock on it");
     return false;
   }
}
void right(Ant* ant) {
   if(ant->ori<West)
     ant->ori++;
   else
     ant->ori = North;
}
void left(Ant* ant) {
   say("Turning left");
   if(ant->ori>North)
     ant->ori--;
   else
     ant->ori = West;
}
bool take(Ant* ant) {
   if (look(ant) == Rock && !ant->hasRock) {
		ant->hasRock = true;
		ant->m_laby->lab[p2p(ant->m_laby,inFront(ant))] = Void;
		return true;
	} else {
        say("I can't take no rock here");
		return false;
	}
}
bool drop(Ant* ant) {
   if ((look(ant) == Void || look(ant) == Web) && ant->hasRock) {
		ant->hasRock = false;
		ant->m_laby->lab[p2p(ant->m_laby,inFront(ant))] = Rock;
		return true;
	} else {
        say("I can't drop no rock here");
		return false;
	}
}
bool escape(Ant* ant) {
	if (look(ant)==Exit) {
		if (ant->hasRock) {
			say("I have to drop this rock first");
			return false;
		}
		say("You WON!");
		return true;
	} else {
		say("There is no Exit");
		return false;
	}
}
void say(const char msg[]) {
	printf("%s\n",msg);
}
