import std.typecons:Tuple;
import std.stdio:writeln;
import std.conv;
import laby;

extern (C) static enum Orientation {
	North,East,South,West
}

extern (C) struct Ant {
	enum Action {
		turnLeft,
		turnRight,
		goForward,
		takeRock,
		dropRock,
		escape
	}
	posTuple posi;
	Orientation ori;
	Laby m_laby;
	bool hasRock;

	static Ant createAnt (string laby) {
		import std.algorithm:splitter;
		import std.array:array;
		import laby:LabyObject,Laby;
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
		AP ant_start;
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
						case '^' : ant_start = AP(pos(x,y),Orientation.North);
							break;
						case '→' :
						case '>' : ant_start = AP(pos(x,y),Orientation.East);
							break;
						case '↓' :
						case 'v' : ant_start = AP(pos(x,y),Orientation.South);
							break;
						case '←' :
						case '<' : ant_start = AP(pos(x,y),Orientation.West);
					}
				}
				lab[posTuple(x,y)] = tokenMap[tok];
			}
		}
		auto _laby = Laby(lab,xmax,ymax);
		auto _ant = Ant(ant_start.expand,_laby);
		return _ant;
	}

	private posTuple inFront() {
		final switch(ori) with (Orientation) {
			case North : return posTuple(posi.x,posi.y-1);
				//break;
			case East : return posTuple(posi.x+1,posi.y);
				//break;
			case South : return posTuple(posi.x,posi.y+1);
				//break;
			case West : return posTuple(posi.x-1,posi.y);
				//break;
		}
	}
	const(LabyObject) look() {   
		return m_laby.laby[inFront];
	}
	bool forward() {
		if (look == Void) {
			m_laby.laby[inFront] = _Ant;
			m_laby.laby[posi] = Void;
			posi = inFront();
			return true;
		} else if (look == Web){
			say ("Waah a spider drop a rock on it");
			return false;
		} else {
			say("a "~m_laby.laby[inFront].to!string~" is in my way");
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
		if (look == Rock && !hasRock) {
			hasRock = true;
			m_laby.laby[inFront] = Void;
			return true;
		} else {
			return false;
		}
	}

	bool drop() {
		if (look == Void || look == Web && hasRock) {
			hasRock = false;
			m_laby.laby[inFront] = Rock;
			return true;
		} else {
			return false;
		}
	}
	bool escape() {
		if (look==Exit) {
			if (hasRock) {
				say ("I have to drop this rock first");
				return false;
			}
			say("You WON!");
			return true;
		} else {
			say("There is no Exit");
			return false;
		}
	}
	void say(string msg) {
		writeln(msg);
	}
}
