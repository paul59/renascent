

// D imports
import std.stdio : writeln;
import std.random : uniform;


// app imports
import main;
import globals;                



void generateMap()
{

    debug writeln("... generating map (whilst reticulating splines)");
    
    //default to land
    foreach(y; 0..MapSize)
    {
        foreach(x; 0..MapSize)
        {
            worldMap[y][x] = Tile(TileType.grass, 1, true);
            
        }
    }
    
    // add water
    addSeeds(TileType.water, 0, 10);
    createClumps(TileType.water, 0, 10);
    
    addSeeds(TileType.rock, 2, 15);
    createClumps(TileType.rock, 2, 4);    

    addSeeds(TileType.tree, 3, 100);
    createClumps(TileType.tree, 3, 3);  
}



// params: tiletype, bitmap index, iterations
void createClumps(TileType t, int bI, int i)
{
    
    Tile[MapSize][MapSize] buffer = worldMap;
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
                   
                   
                   if(uniform(0, 1.0) > randVal) buffer[top][left] = Tile(t, bI, false);
                   if(uniform(0, 1.0) > randVal) buffer[top][x] = Tile(t, bI, false);
                   if(uniform(0, 1.0) > randVal) buffer[top][right] = Tile(t, bI, false);
                   if(uniform(0, 1.0) > randVal) buffer[y][left] = Tile(t, bI, false); 
                   if(uniform(0, 1.0) > randVal) buffer[y][right] = Tile(t, bI, false); 
                   if(uniform(0, 1.0) > randVal) buffer[bottom][left] = Tile(t, bI, false); 
                   if(uniform(0, 1.0) > randVal) buffer[bottom][x] = Tile(t, bI, false); 
                   if(uniform(0, 1.0) > randVal) buffer[bottom][right] = Tile(t, bI, false); 
                   
               }
            }            
        }
        // move buffer to worldmap for next iteration
        worldMap = buffer;
    }    
}







// params tiletype, bitmap index, number of seeds
void addSeeds(TileType t, int bI, int num)
{
    
    // add up to num seeds - can be placed in same cell
    while(--num)
    {
        int rX = uniform(0, MapSize);
        int rY = uniform(0, MapSize);
        worldMap[rY][rX] = Tile(t, bI, false);
        
    }
}
