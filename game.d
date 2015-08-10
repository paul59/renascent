// D imports
import std.stdio : writeln;
import std.random : uniform;

// allegro imglobals!"ports
import allegro5.allegro;
import allegro5.allegro_ttf;
import allegro5.allegro_font;

// app imports
import globals;
import  main;
import  world;
import  render;
import  input;





void runGame()
{
    debug writeln("... main menu");

    // stay in menu until new game, load, quit
    // for now just play new
    newGame();
}



/**
 * initialise and play a new game
 *
 **/
void newGame()
{
    bool flagPlaying = true;

    // init game
    if(!loadResources())
    {
        writeln("Failed to load resources");
        return;
    }
        
    generateMap();
    int rX, rY;
    do
    {
        rX = uniform(0, MapSize);
        rY = uniform(0, MapSize);
        
    } while( worldMap[rY][rX].tileType != 1);
    player.locX = rX;
    player.locY = rY; 
    player.facing = Direction.south;

    player.att = 5;
    player.def = 5; 
    player.entity = creature[EntityType.ogre];  
    // generateNPCs();


   
    addMessage("Renascent...");
    addMessage("Arrows: Move");
    addMessage("NumPad Arrows: Face");
    addMessage("NumPad 0: Action");
    addMessage("Try actions to your *north* only");
    addMessage("");
    addMessage("When you have sufficient soul points you can");
    addMessage("transform yourself into any previous form at will");
    addMessage("");

    
    // play until quit
    debug writeln("... entering main loop");    
    while(flagPlaying)
    {

        // update the assoc array with key states
        updateKeys();

        if(keyList["esc"]) flagPlaying = false;
        
        if(keyList["action"])
        {
            
            switch(player.facing)
            {
                case Direction.north :
                if(worldMap[coordNorth(player.locY)][player.locX].tileType == TileType.tree)
                {
                    addMessage("Chop!");
                    worldMap[coordNorth(player.locY)][player.locX] = Tile(TileType.grass, 1, true);
                    player.wood += 2 + uniform(1, 5);
                }
                if(worldMap[coordNorth(player.locY)][player.locX].tileType == TileType.water)
                {
                    addMessage("Gulp, slurp... you feel refreshed");
                }
                if(worldMap[coordNorth(player.locY)][player.locX].tileType == TileType.rock)
                {
                    addMessage("Smasho. You got rocks");
                    worldMap[coordNorth(player.locY)][player.locX] = Tile(TileType.grass, 1, true);
                }                
                break;
                
                default:
                addMessage("Undefined action attempted. LOL");
            }
            
            
            keyList["action"] = false;
        }

        if(keyList["up"])
        {        
            if(canGoNorth())
            {
                player.locY = coordNorth(player.locY);            
            }
            keyList["up"] = false;
        }

        if(keyList["down"])
        {
            if(canGoSouth())
            {            
                player.locY = coordSouth(player.locY);  
            }
            keyList["down"] = false;
        }

        if(keyList["left"])
        {
            if(canGoWest())
            {
                player.locX = coordWest(player.locX);              
            }
            keyList["left"] = false;
        }

        if(keyList["right"])
        {
            if(canGoEast())
            {
                player.locX = coordEast(player.locX);
                
            }
            keyList["right"] = false;
        }

        al_clear_to_color(al_map_rgb(0, 0, 0));
        renderMap();
        renderPlayer();
        renderHUD();
        renderMessages();
        al_flip_display();
    }
}



// these functions return the co-ordinate to the NESW, with wrap if necessary

int coordWest(int cX)
{
    if(cX == 0) 
    {
        return(MapSize - 1);
    } else
    {
        return(cX - 1);
    }
}

int coordEast(int cX)
{
    if(cX == MapSize - 1) 
    {
        return(0);
    } else
    {
        return(cX + 1);
    }
}

int coordNorth(int cY)
{
    if(cY == 0) 
    {
        return(MapSize - 1);
    } else
    {
        return(cY - 1);
    }
}

int coordSouth(int cY)
{
    if(cY == MapSize - 1) 
    {
        return(0);
    } else
    {
        return(cY + 1);
    }
}



// these function test if cell in given direction is passable
bool canGoNorth()
{
    int testY = coordNorth(player.locY);       
    if(worldMap[testY][player.locX].canPass) return true;
    return false;
}

bool canGoSouth()
{
    int testY = coordSouth(player.locY);
    if(worldMap[testY][player.locX].canPass) return true;    
    return false;
}

bool canGoWest()
{
    int testX = coordWest(player.locX);
    if(worldMap[player.locY][testX].canPass) return true;
    return false;
}

bool canGoEast()
{
    int testX = coordEast(player.locX);
    if(worldMap[player.locY][testX].canPass) return true;
    return false;
}






bool loadResources()
{
    debug writeln("... loading resources");
    
    imgTileSet = al_load_bitmap("./resources/tileset.png");
    if(imgTileSet == null) return false;
    imgPlayer = al_load_bitmap("./resources/player.png");
    if(imgPlayer == null) return false;
    messageFont = al_load_ttf_font("./resources/msgfont.ttf",12, 0 );
    if(messageFont == null) return false;
    
    return true;

    
}


void addMessage(string mess)
{
    
    // scroll existing messages up
    foreach(i; 1..MessageBuffer)
    {
        messageLines[i-1] = messageLines[i];
    }
    
    // add new message to end of list
    messageLines[MessageBuffer - 1] = mess;
    
}

