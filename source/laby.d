module laby;
import ant;
import std.typecons;
extern (C) 	enum LabyObject {
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

alias posTuple = Tuple!(int,"x",int,"y");
alias pos = posTuple;
alias AP  = Tuple!(posTuple,"pos",Orientation,"ori");


extern (C) struct Laby {
	LabyObject opIndex(int x,int y) {
		return laby.get(pos(x,y),Void);
	}
	
	LabyObject[posTuple] laby;
	alias laby this;
	uint x,y;
	
	this(LabyObject[posTuple] lab,uint xmax,uint ymax) pure {
		this.laby = lab;
		this.x = xmax;
		this.y = ymax;
	}

	string show(Orientation ori) {
		string r;
		foreach (immutable _y; 1 .. y+1) {
			foreach (immutable _x; 0 .. x+1) {
				final switch (this[_x,_y]) with (LabyObject) {
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
