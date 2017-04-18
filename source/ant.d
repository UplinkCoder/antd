import std.typecons:Tuple;
import std.stdio:writeln;
import std.conv;
import laby;

extern (C) 
struct Ant {
extern (C) :
	enum Action {
		turnLeft,
		turnRight,
		goForward,
		takeRock,
		dropRock,
		escape
	}
	pos posi;
	Orientation ori;
	Laby m_laby;
	bool hasRock;
	enum Orientation {
		North,East,South,West
	}
			
	private pos inFront() {
		final switch(ori) with (Orientation) {
			case North : return Laby.posTuple(posi.x,posi.y-1);
				//break;
			case East : return Laby.posTuple(posi.x+1,posi.y);
				//break;
			case South : return Laby.posTuple(posi.x,posi.y+1);
				//break;
			case West : return Laby.posTuple(posi.x-1,posi.y);
				//break;
		}
	}
	const(Laby.LabyObject) look() {   
		return m_laby.laby[inFront];
	}
	bool forward() {
		if (look == Laby.Void) {
			m_laby.laby[inFront] = Laby._Ant;
			m_laby.laby[posi] = Laby.Void;
			posi = inFront();
			return true;
		} else if (look == Laby.Web){
			writeln ("Waah a spider drop a rock on it");
			return false;
		} else {
			writeln("a "~m_laby.laby[inFront].to!string~" is in my way");
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
			m_laby.laby[inFront] = Laby.Void;
			return true;
		} else {
			return false;
		}
	}

	bool drop() {
		if (look == Laby.Void || look == Laby.Web && hasRock) {
			hasRock = false;
			m_laby.laby[inFront] = Laby.Rock;
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
