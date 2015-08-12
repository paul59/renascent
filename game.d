// D imports
import std.stdio : writeln;
import std.random : uniform;
import std.conv;

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
        
    // init map
    generateMap();
    
    
    flagMouseOverMap = false;
    
    // init player
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
    mob.locX = 50;
    mob.locY = 50;
    mob.att = 0;
    mob.def = 0;
    mob.facing = Direction.south;
    mob.hp = 1;
    mob.entity = creature[EntityType.butterfly];
    
    


   
    addMessage("Renascent...");
    addMessage("Arrows: Move");
    addMessage("NumPad Arrows: Face");
    addMessage("NumPad 0: Action");
    addMessage("");
    addMessage("When you have sufficient soul points you can");
    addMessage("transform yourself into any previous form at will");
    addMessage("");
    addMessage("If you could find a compass, you could work out your");
    addMessage("position... handy for quests");
    addMessage("");
    addMessage("LOOK OUT out for the giant red butterfly!");

    
    // play until quit
    debug writeln("... entering main loop");    
    while(flagPlaying)
    {

        // update the assoc array with key states
        updateKeys();

        if(keyList["esc"]) flagPlaying = false;
        
        if(keyList["action"])
        {
            
            processAction();         
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
        renderMobs();
        renderHUD();
        renderCursor();
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
    imgMob = al_load_bitmap("./resources/mob.png");
    if(imgMob == null) return false;    
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



void processAction()
{
    
    // get cell on which action will be performed
    int targetX, targetY;
    
    switch(player.facing)
    {
        case Direction.north :
            targetX = player.locX;
            targetY = coordNorth(player.locY);
            break;
        case Direction.south :
            targetX = player.locX;
            targetY = coordSouth(player.locY);
            break;        
        case Direction.west :
            targetY = player.locY;
            targetX = coordWest(player.locX);            
            break;         
        case Direction.east :
            targetY = player.locY;
            targetX = coordEast(player.locX);            
            break;           
        default:
        
    }    


    // process the action, depends upon type of tile in target cell
    switch(worldMap[targetY][targetX].tileType)
    {
        
        case TileType.tree :
            addMessage("Chop...");
            --worldMap[targetY][targetX].hp;
            if(worldMap[targetY][targetX].hp == 0)
            {
                worldMap[targetY][targetX] = Tile(TileType.grass, 1, true, -1);
                addMessage("Timber....!");
                player.wood += 2 + uniform(1, 5);
            } else
            {
                addMessage("That tree will take another " ~ to!string(worldMap[targetY][targetX].hp) ~ " blows to fell");
                
            }
            break;
            
        case TileType.water :
            addMessage("Gulp, slurp... you feel refreshed");
            break;
        
        case TileType.rock :
            --worldMap[targetY][targetX].hp;
            if(worldMap[targetY][targetX].hp == 0)
            {
                worldMap[targetY][targetX] = Tile(TileType.grass, 1, true, -1);
                addMessage("The rock crumbles....");
                player.wood += 2 + uniform(1, 5);
            } else
            {
                addMessage("This rock needs another " ~ to!string(worldMap[targetY][targetX].hp) ~ " blows to break");
                
            }
            break;
        
        default: 
            addMessage("?");
            break;          
        
    }
       
}
