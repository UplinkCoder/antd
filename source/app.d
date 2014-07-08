import std.stdio;
import std.conv;
import ant:Ant;
import laby:Laby;


immutable string l1 =
`
 -------------|
 |>R   |      E
 ----| | |----|
     | | |
     | W |
     -----`;
immutable string l2 =
`
-------------------------------
|                             |
|                             |
|                             |
|---               |  -----   |
|                  |     >|   |
| |                |-------   |
E |                           |
|--                           |
-------------------------------
`;

void main() {
	//import derelict.fann.fann;
	//import derelict.fann.funcs;

	string delegate(ref Ant ant)[string] commands;
	commands["help"] = (ref ant){
		return ("
		ttype l to turn left
		type f to go forward
		type t to take a rock
		type d to drop a rock
		type e to exit
		type q to quit");
	};
	commands["e"] = (ref ant){
		if (ant.escape())
			return ("Yeahy! type q to quit");
		else return ("");
	};
	commands["l"] = (ref ant){
		ant.left;
		return ("turning left");
	};
	commands["v"] = (ref ant){
		return ant.look.to!string;
	};
	commands["t"] = (ref ant){
		if (ant.take) 
			return ("taking rock");
		else 
			return ("I can't take a rock");
	};
	commands["d"] = (ref ant){
		if (ant.drop) 
			return ("dropping rock");
		else 
			return ("I can't drop a rock");
	};
	commands["f"] = (ref ant){
		if (ant.forward) 
			return ("moving forward");
		else 
			return ("I can't move on");
	};
	commands["r"] = (ref ant){
		ant.right;
		return ("turning right");
	};
	auto ant = Ant.createAnt(l2); 

	string command;

	writeln("\t\t go to the exit 'E' \n \t\t type help for help");
	while (command!="q") {
		ant.m_laby.show(ant.ori).writeln;
		write(":>");
		readf("%s\n",&command);
		if (command in commands)
			commands[command](ant).writeln;
	}
}
