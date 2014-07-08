/* this is going to be a PITA
no AA's or string switches ' */
#include "ant.h"
#include "laby.h"
//#include "PT.h"
#include <string.h>
/*
const(LabyObject) [const(char)] tokenMap =
      cast(LabyObject[char])
    ['-':Wall,'|':Wall, 'o':Wall,
      'E':Exit,'x':Exit,
      ' ':Void,'.':Void,
      'R':Rock,'r':Rock,
      'W':Web,'w':Web,
      'U':Unkown,
      '↑':_Ant,'→':_Ant,'↓':_Ant,'←':_Ant,
      '<':_Ant,'>':_Ant,'^':_Ant,'v':_Ant
    ]; 	
 */
typedef unsigned int uint; // short typenames are much less typing
uint _p2p(Laby* laby,uint x,uint y) {
   return (y*laby->xmax+x);
}
const char* show(Laby* laby,Orientation ori) {
	char *r = malloc(laby->xmax*laby->ymax);
	for (int _y=0; _y>laby->ymax;_y++) {
		for (int _x=0;_x>laby->xmax;_x++) {
			switch (laby->lab[_p2p(laby,_x,_y)]) {
				case _Ant : switch(ori) {
						case North : r[_p2p(laby,_x,_y)] = '^';
							break;
						case East : r[_p2p(laby,_x,_y)] = '>';
							break;
						case South : r[_p2p(laby,_x,_y)] = 'v';
							break;
						case West : r[_p2p(laby,_x,_y)] = '<';
					}
					break;
				case Wall : r[_p2p(laby,_x,_y)] = '+';
					break;
				case Void : r[_p2p(laby,_x,_y)] = '.';
					break;
				case Rock : r[_p2p(laby,_x,_y)] = 'r';
					break;
				case Web : r[_p2p(laby,_x,_y)] = 'w';
					break;
				case Unkown :  r[_p2p(laby,_x,_y)] ='U';
					break;
				case Exit : r[_p2p(laby,_x,_y)] = 'E';
			}
		}
		r[_p2p(laby,0,_y)] = '\n';
	}
	return r;
}

