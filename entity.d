
import std.random;
import globals : worldMap, TileType, Direction, MapSize;




enum Creatures {human, butterfly, ogre, fox}

struct Entity
{

    int locX;               // location x, y
    int locY;
    int facing;             // facing direction
    int hp;                 // hit points
    int sp = 0;             // soul points
    int creatureType;       // what type of creature
    
    this(int cType)
    {
        
        creatureType = cType;
        facing = Direction.south;
        
        switch(cType)
        {
            
            case Creatures.human :  
            hp = 50 + uniform(-5, 5);
            sp = 0;
            do{
                locX = uniform(0, MapSize);
                locY = uniform(0, MapSize);                
            } while(worldMap[locY][locX].tileType != TileType.grass);
            
            break;
            
            case Creatures.butterfly :
            hp = 1;
            locX = uniform(0, MapSize);
            locY = uniform(0, MapSize);
            break;
            
            default:
            
        }
        
    }
}




