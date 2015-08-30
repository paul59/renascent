

// D imports
import std.stdio : writeln;
import std.random : uniform;


// app imports
import main;
import globals; 














               

struct Rect
{
    size_t left, right, top, bottom;

    string toString()
    {
        import std.string;
        return format("l:%s, r:%s, t:%s, b:%s", left, right, top, bottom);
    }

}

struct Point
{
    size_t x, y;

    string toString()
    {
        import std.string;
        return format("x:%s, y:%s", x, y);
    }

    bool opEquals()(auto ref const Point rhs) const
    {
        return (x == rhs.x) && (y == rhs.y);
    }
}

struct Portal
{
}

T[][] copy2DArray(T)(T[][] array)
{
    T[][] newArray;

    foreach (row; array) {
        newArray ~= row.dup;
    }
    return newArray;
}

string tileArrayToString(Tile[][] tiles)
{
    import std.string;
    string returnString;
    foreach (Tile[] row; tiles)
    {
        foreach (Tile tile; row)
        {
            returnString ~= format("%s", tile.tileType);
        }
        returnString ~= ("\n");
    }
    return returnString;
}

Tile[][] floodFillInRect(
        Tile[][] tiles,
        Rect rect,
        Point point,
        Tile function(Tile) converter,
        bool function(Tile[][], size_t, size_t) predicate)
{
    import std.algorithm : canFind;

    Tile[][] newTiles = copy2DArray(tiles);
    Point[] queue = [point];
    Point[] visitedPoints = [];

    while (queue.length != 0)
    {
        point = queue[0];
        queue = queue[1..$];

        if (!(canFind(visitedPoints, point))
                && predicate(newTiles, point.x, point.y))
        {
            newTiles[point.x][point.y] = converter(newTiles[point.x][point.y]);
            if (point.x > rect.left)
            {
                queue ~= Point(point.x - 1, point.y);
            }
            if (point.x < rect.right - 1)
            {
                queue ~= Point(point.x + 1, point.y);
            }
            if (point.y > rect.top)
            {
                queue ~= Point(point.x, point.y - 1);
            }
            if (point.y < rect.bottom - 1)
            {
                queue ~= Point(point.x, point.y + 1);
            }
        }
        visitedPoints ~= point;
    }
    return newTiles;
}


void generateMap()
{

    debug writeln("... generating map");
 
    //default to land
    foreach(y; 0..MapSize)
    {
        foreach(x; 0..MapSize)
        {
            worldMap[y][x] = Tile(TileType.grass, 1, true, -1);
        }
    }
 
    import dungeon;
    // add water
    addSeeds(TileType.water, 0, 10, -1);
    createClumps(TileType.water, 0, 10, -1);
 
    // rocks
    // give random hit points to rocks and trees
    int hpBase = 10;
    addSeeds(TileType.rock, 2, 15, hpBase);
    createClumps(TileType.rock, 2, 4, hpBase);

    // trees
    hpBase = 5;
    addSeeds(TileType.tree, 3, 100, hpBase);
    createClumps(TileType.tree, 3, 3, hpBase);
}



// params: tiletype, bitmap index, iterations, tile's hp
void createClumps(TileType t, int bI, int i, int hpBaseVal)
{
 
    Tile[][] buffer = copy2DArray(worldMap);
    int left, top, right, bottom;
    float randVal = 0.6;
 
    foreach(its; 0..i)
    {
        foreach(y; 0..MapSize)
        {
            foreach(x; 0..MapSize)
            {

               if(worldMap[y][x].tileType == t)
               {
                   // surrounding tile may become same type
                   left = (x == 0) ? MapSize - 1 : x - 1;
                   right = (x == MapSize - 1) ? 0 : x + 1;
                   top = (y == 0) ? MapSize - 1 : y - 1;
                   bottom = (y == MapSize - 1) ? 0 : y + 1;
                   
                   // water is -1 hp, trees and rocks have random hp 
                   int hpVal;
                   if( t == TileType.water )
                   {
                        hpVal = -1;
                   } else
                   {
                        hpVal = uniform(hpBaseVal, hpBaseVal * 2);
                   }
                   if(uniform(0, 1.0) > randVal) buffer[top][left] = Tile(t, bI, false, hpVal);
                   if(uniform(0, 1.0) > randVal) buffer[top][x] = Tile(t, bI, false, hpVal);
                   if(uniform(0, 1.0) > randVal) buffer[top][right] = Tile(t, bI, false, hpVal);
                   if(uniform(0, 1.0) > randVal) buffer[y][left] = Tile(t, bI, false, hpVal); 
                   if(uniform(0, 1.0) > randVal) buffer[y][right] = Tile(t, bI, false, hpVal); 
                   if(uniform(0, 1.0) > randVal) buffer[bottom][left] = Tile(t, bI, false, hpVal); 
                   if(uniform(0, 1.0) > randVal) buffer[bottom][x] = Tile(t, bI, false, hpVal); 
                   if(uniform(0, 1.0) > randVal) buffer[bottom][right] = Tile(t, bI, false, hpVal); 
                   
               }
            }            
        }
        // move buffer to worldmap for next iteration
        worldMap = copy2DArray(buffer);
    }    
}







// params tiletype, bitmap index, number of seeds, hp of tile
void addSeeds(TileType t, int bI, int num,  int hpBaseVal)
{
    
    // add up to num seeds - can be placed in same cell
    while(--num)
    {
        int rX = uniform(0, MapSize);
        int rY = uniform(0, MapSize);
        // not passable by default (eg tree, rock)
        // just use base value for hp
        worldMap[rY][rX] = Tile(t, bI, false, hpBaseVal);
        
    }
}
