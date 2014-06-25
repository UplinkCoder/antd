import std.typecons:Tuple;
import std.stdio:writeln;
import std.conv;

struct Laby {
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

	static Ant createAnt (string laby) {
		import std.algorithm:splitter;
		import std.array:array;

		const(LabyObject) [const(char)] tokenMap =
		    ['-':Wall,'|':Wall,
			'E':Exit,' ':Void,
			'R':Rock,'W':Web,
			'U':Unkown,
			'<':_Ant,'>':_Ant,'^':_Ant,'v':_Ant
		]; 	

		LabyObject[posTuple] lab;
		auto lines = laby.splitter('\n').array;
		uint xmax=0;
		uint ymax=0;
		pos pstart;
		Ant.Orientation ostart;
		foreach (y,line;lines) {
			if (y>ymax) ymax++;
			foreach (x,char tok;line) {
				if (x>xmax) xmax++;
				if (tokenMap[tok] == _Ant) {
					pstart = pos(x,y); 
					final switch (tok) {
						case '^' : ostart = Ant.Orientation.North;
							break;
						case '>' : ostart = Ant.Orientation.East;
							break;
						case 'v' : ostart = Ant.Orientation.South;
							break;
						case '<' : ostart = Ant.Orientation.West;
					}
				}
				lab[posTuple(x,y)] = tokenMap[tok];
			}
		}
		return Ant(Laby(lab,xmax,ymax),pstart,ostart);
	}
	alias posTuple = Tuple!(int,int);
	struct pos {
		int x;
		int y;
		posTuple toTuple() {
			return posTuple (x,y);
		}
	}
	private LabyObject opIndex(uint x,uint y) {
		return laby.get(posTuple(x,y),Laby.Void);
	}

	LabyObject[posTuple] laby;
	
	alias laby this;
	uint x,y;

	this(LabyObject[posTuple] lab,uint xmax,uint ymax) pure {
		this.laby = lab;
		this.x = xmax;
		this.y = ymax;
	}
}


struct Ant { 	
	enum Action {
		turnLeft,
		turnRight,
		goForward,
		takeRock,
		dropRock,
		escape
	}
	Laby laby;
	Laby.pos posi;
	Orientation ori;
	bool hasRock;
	enum Orientation {
		North,East,South,West
	}

		string toString() {
			string r;
			foreach (immutable _y; 1 .. laby.y+1) {
				foreach (immutable _x; 0 .. laby.x+1) {
					final switch (laby[_x,_y]) with (Laby.LabyObject) {
						case _Ant : final switch(ori) with (Orientation) {
							case North : r~= "^";
								break;
							case East : r~= ">";
								break;
							case South : r~= "v";
								break;
							case West : r~= "<";
						}
							break;
						case Wall : {
							if (laby[_x-1,_y]==Wall||laby[_x+1,_y]==Wall) {
								r~="-";
							} else { 
								r~= '|';
							}
						}
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
		
	private Laby.pos inFront() {
		final switch(ori) with (Orientation) {
			case North : return Laby.pos(posi.x,posi.y-1);
				//break;
			case East : return Laby.pos(posi.x+1,posi.y);
				//break;
			case South : return Laby.pos(posi.x,posi.y+1);
				//break;
			case West : return Laby.pos(posi.x-1,posi.y);
				//break;
		}
	}
	Laby.LabyObject look() {   
		return laby[inFront.x,inFront.y];
	}
	bool forward() {
		if (look == Laby.Void) {
			laby.laby[inFront.toTuple] = Laby._Ant;
			laby.laby[posi.toTuple] = Laby.Void;
			posi = inFront();
			return true;
		} else if (look == Laby.Web){
			writeln ("Waah a spider drop a rock on it");
			return false;
		} else {
			writeln("a "~laby[inFront.x,inFront.y].to!string~" is in my way");
			return false;
		}
	}
	void right() {
		if (ori<Orientation.West)
			ori++;
		else
			ori = Orientation.North;
	}
	void left() {
		if (ori>Orientation.North)
			ori--;
		else
			ori = Orientation.West;
	}
	bool take() {
		if (look == Laby.Rock && !hasRock) {
			hasRock = true;
			laby.laby[inFront.toTuple] = Laby.Void;
			return true;
		} else {
			return false;
		}
	}

	bool drop() {
		if (look == Laby.Void || look == Laby.Web && hasRock) {
			hasRock = false;
			laby.laby[inFront.toTuple] = Laby.Rock;
			return true;
		} else {
			return false;
		}
	}
	bool escape() {
		if (look==Laby.Exit) {
			if (hasRock) {
				writeln ("I have to drop this rock first");
				return false;
			}
			writeln("You WON!");
			return true;
		} else {
			writeln("There is no Exit");
			return false;
		}
	}
}
