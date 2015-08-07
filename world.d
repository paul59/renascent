

// D imports
import std.stdio : writeln;
import std.random : uniform;


// app imports
import main :   MapSize,
                worldMap;


void generateMap()
{

    debug writeln("... generating map");
    foreach(y; 0..MapSize)
    {
        foreach(x; 0..MapSize)
        {
			// exciting random tiles
            worldMap[y][x] = uniform(0, 3);
        }

    }

}


