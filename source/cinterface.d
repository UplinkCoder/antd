import ant;
import laby;


extern (C) struct cstring {char* str;size_t len;}
extern (C) cstring* new_cstring(char* str,size_t length) {return new cstring(str,length);}
extern (C) Ant* getAnt(PT* polyType) {return &(polyType.ant);}  
extern (C) Laby* getLaby(PT* polyType) {return &(polyType.laby);}
extern (C) void createLabyAntPolyType(cstring lab,PT* pt) {
	*pt = Laby.createLaby(cast(string)lab.str[0 .. lab.len]);
}

extern (C) Laby.LabyObject look(Ant* ant) {return ant.look;}
extern (C) void say (Ant* ant,cstring msg) {ant.say(cast(string)msg.str[0 .. msg.len]);}
extern (C) bool forward(Ant* ant) {return ant.forward;}
extern (C) void left(Ant* ant) {return ant.left;}
extern (C) void right(Ant* ant) {return ant.right;}
extern (C) bool take(Ant* ant) {return ant.take;}
extern (C) bool drop(Ant* ant) {return ant.drop;}
extern (C) bool escape(Ant* ant) {return ant.escape;}  
extern (C) cstring showLaby(Ant* ant) {string lab=ant.m_laby.show(ant.ori); return cstring(cast(char*)lab.ptr,lab.length);} 
