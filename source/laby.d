module laby;
import ant;
import std.typecons;

extern (C) struct PT {
	extern (C):
	Ant ant;
	Laby laby;
}

extern (C) struct Laby {
	extern (C):
	alias posTuple = Tuple!(int,"x",int,"y");
	alias pos = posTuple;
	alias AP  = Tuple!(posTuple,"pos",Ant.Orientation,"ori");
	
	LabyObject opIndex(int x,int y) {
		return laby.get(pos(x,y),Laby.Void);
	}
	
	LabyObject[posTuple] laby;
	alias laby this;
	uint x,y;
	enum LabyObject {
		_Ant,
		Void,
		Wall,
		Rock,
		Web,
		Unkown,
		Exit
	}
	alias Wall = LabyObject.Wall;
	alias Web = LabyObject.Web;
	alias Void = LabyObject.Void;
	alias Rock = LabyObject.Rock;
	alias Unkown = LabyObject.Unkown;
	alias Exit = LabyObject.Exit;
	alias _Ant = LabyObject._Ant;
	
	static PT /*polyType!(Laby,Ant)*/ createLaby (string laby) {
		import std.algorithm:splitter;
		import std.array:array;
		
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
		
		LabyObject[posTuple] lab;
		AP ant;
		auto lines = laby.splitter('\n').array;
		uint xmax=0;
		uint ymax=0;
		foreach (y,line;lines) {
			if (y>ymax) ymax++;
			foreach (x,char tok;line) {
				if (x>xmax) xmax++;
				if (tokenMap[tok] == _Ant) {

					final switch (tok) {
						case '↑' :
						case '^' : ant = AP(pos(x,y),Ant.Orientation.North);
							break;
						case '→' :
						case '>' : ant = AP(pos(x,y),Ant.Orientation.East);
							break;
						case '↓' :
						case 'v' : ant = AP(pos(x,y),Ant.Orientation.South);
							break;
						case '←' :
						case '<' : ant = AP(pos(x,y),Ant.Orientation.West);
					}
				}
				lab[posTuple(x,y)] = tokenMap[tok];
			}
		}
		auto _laby = Laby(lab,xmax,ymax);
		auto _ant = Ant(ant.expand,_laby);
			return PT(_ant,_laby);
	}
	
	this(LabyObject[posTuple] lab,uint xmax,uint ymax) pure {
		this.laby = lab;
		this.x = xmax;
		this.y = ymax;
	}

	string show(Ant.Orientation ori) {
		string r;
		foreach (immutable _y; 1 .. y+1) {
			foreach (immutable _x; 0 .. x+1) {
				final switch (this[_x,_y]) with (Laby.LabyObject) {
					case _Ant : final switch(ori) with (Ant.Orientation) {
							case North : r~= "^";
								break;
							case East : r~= ">";
								break;
							case South : r~= "v";
								break;
							case West : r~= "<";
						}
						break;
					case Wall : r~= '+';
						break;
					case Void : r~= " ";
						break;
					case Rock : r~= 'R';
						break;
					case Web : r~= 'W';
						break;
					case Unkown :  r~='U';
						break;
					case Exit : r~= 'E';
				}
			}
			r~='\n';
		}
		return r;
	}
}
