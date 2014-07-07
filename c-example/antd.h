#include <stdbool.h>
typedef void* Ant;
typedef void* Laby;
struct PT {
	Ant ant;
	Laby laby;
};
typedef struct PT PT;
struct cstring {char* str;unsigned int len;};
typedef struct cstring cstring; 
cstring* new_cstring(char* str,unsigned int length);
Ant getAnt(PT* polyType);  
Laby getLaby(PT* polyType);

void createLabyAntPolyType(cstring lab,PT* pt);

char look(Ant ant);
void say (Ant ant,cstring msg);
bool forward(Ant ant);
void left(Ant ant);
void right(Ant ant);
bool take(Ant ant);
bool drop(Ant ant);
bool escape(Ant ant);
cstring showLaby(Ant ant);
