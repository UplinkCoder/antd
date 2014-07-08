import ant;
import laby;


extern (C) struct cstring {size_t len;char* str;}
extern (C) cstring* new_cstring(char* str,size_t length) {return new cstring(length,str);}
extern (C) void createAnt(cstring lab,Ant* ant) {
	*ant = Ant.createAnt(cast(string)lab.str[0 .. lab.len]);
}

extern (C) LabyObject look(Ant* ant) {return ant.look;}
extern (C) void say (Ant* ant,cstring msg) {ant.say(cast(string)msg.str[0 .. msg.len]);}
extern (C) bool forward(Ant* ant) {return ant.forward;}
extern (C) void left(Ant* ant) {return ant.left;}
extern (C) void right(Ant* ant) {return ant.right;}
extern (C) bool take(Ant* ant) {return ant.take;}
extern (C) bool drop(Ant* ant) {return ant.drop;}
extern (C) bool escape(Ant* ant) {return ant.escape;}  
extern (C) cstring showLaby(Ant* ant) {string lab=ant.m_laby.show(ant.ori); return cstring(lab.length,cast(char*)lab.ptr);} 
