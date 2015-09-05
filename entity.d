
import std.random;
import globals : worldMap, TileType, Direction, MapSize, gameTimer;




enum Creatures {human, butterfly, ogre, fox}

struct Entity
{

    int locX;                       // location x, y
    int locY;
    int facing;                     // facing direction
    int hp;                         // hit points
    int sp = 0;                     // soul points
    int creatureType;               // what type of creature
    long updateInterval = 2000;     // interval between updates
    long datum;                     // time next update due
    
    this(int cType)
    {
        
        creatureType = cType;
        facing = Direction.south;
        
        //same update time for all for now
        datum = gameTimer.peek().msecs + updateInterval; 
        
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
            do{
                locX = uniform(0, MapSize);
                locY = uniform(0, MapSize);
            } while(worldMap[locY][locX].tileType != TileType.grass);    
            break;
            
            default:
            
        }
        
    }
}





/*
 * this code pasted -needs fixing :P
 * 

void updateMobs()
{


    foreach(ind, i; mobList)
    {
        // time to update this fella?
        if(to!long(sw.peek().msecs) > i.datum)
        {  
            
            int r = uniform(0, 8);
            if(worldMap[i.y][i.x].connection[r])
            {
               
               switch(r)
               {    
                    case Directions.north:
                    --mobList[ind].y;
                     break;
                    
                    case Directions.northeast:
                    --mobList[ind].y;
                    ++mobList[ind].x;
                    break;
                    
                    case Directions.east:
                    ++mobList[ind].x;
                    break; 
                    
                    case Directions.southeast:
                    ++mobList[ind].y;
                    ++mobList[ind].x;
                    break;
                    
                    case Directions.south:
                    ++mobList[ind].y;
                    break;  
                                      
                    case Directions.southwest:
                    ++mobList[ind].y;
                    --mobList[ind].x;
                    break;                     
                    
                    case Directions.west:
                    --mobList[ind].x;
                    break; 
                    
                    case Directions.northwest:
                    --mobList[ind].x;
                    --mobList[ind].y;
                    break;   
                    
                    default :                                                         
                    
               } 
                
            }
        
            //set new time
            mobList[ind].datum = sw.peek().msecs + mobList[ind].updateTicks;
            
        }
 
    }
}
*/
