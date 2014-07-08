#ifndef ANT_H
#define ANT_H
#include <stdbool.h>
#include "laby.h"
struct pos_t {
	int x;
	int y;
}; 
typedef struct pos_t pos_t;// has to be in a header ... no import just textual inclusion

enum Orientation {
	North,East,West,South
};
typedef enum Orientation Orientation;

struct Ant {
	pos_t pos; // I wish i had Tuple!
	Laby* m_laby; // Pointer syntax is needed ... No ref;
	Orientation ori;
	bool hasRock; // is no real bool but int ... ah well.

} ;
typedef struct Ant Ant;
Ant* createAnt (char* str);
void say(const char mag[]);
LabyObject look(Ant* ant);
bool forward (Ant* ant);
void left(Ant* ant);
const char* show (Laby*,Orientation);
#endif
