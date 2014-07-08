#ifndef LABY_H
#define LABY_H
#include "ant.h"

enum LabyObject {
	_Ant,
	Void,
	Wall,
	Rock,
	Web,
	Unkown,
	Exit
} ;
typedef enum LabyObject LabyObject;

  struct Laby {
   int xmax,ymax;
   char *lab;
} ;
typedef struct Laby Laby;

#endif
