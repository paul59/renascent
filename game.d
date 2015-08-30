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
import main;
import world;
import render;
import input;
import dungeon;
import entity : Entity, Creatures;





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
    //TileRegion region = TileRegion([null,null],null,SplitType.vertical, Rect(0,100,0,100));
    //worldMap = generateCADungeonLevel(region, copy2DArray(worldMap));
    //worldMap = generateBSPDungeonLevel(region, copy2DArray(worldMap));

    //writeln(tileArrayToString(worldMap));
    
    flagMouseOverMap = false;
 
 
    Entity player;
    Entity mob;
 

    // init player
    player = Entity(Creatures.human);
    
    // generateNPCs();
    mob = Entity(Creatures.butterfly);


   
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

    
    // MAIN LOOP
  
    while(flagPlaying)
    {

        // update the assoc array with key states
        player = updateKeys(player);

        if(keyList["esc"]) flagPlaying = false;
        
        if(keyList["action"])
        {
            
            processAction(player);         
            keyList["action"] = false;
        }

        if(keyList["up"])
        {        
            if(canGoNorth(player))
            {
                player.locY = coordNorth(player.locY);            
            }
            keyList["up"] = false;
        }

        if(keyList["down"])
        {
            if(canGoSouth(player))
            {            
                player.locY = coordSouth(player.locY);  
            }
            keyList["down"] = false;
        }

        if(keyList["left"])
        {
            if(canGoWest(player))
            {
                player.locX = coordWest(player.locX);              
            }
            keyList["left"] = false;
        }

        if(keyList["right"])
        {
            if(canGoEast(player))
            {
                player.locX = coordEast(player.locX);
                
            }
            keyList["right"] = false;
        }

        al_clear_to_color(al_map_rgb(0, 0, 0));
        renderMap(player);
        renderPlayer(player);
        renderMobs(mob, player);
        renderHUD(player);
        renderCursor();
        renderMessages();
        al_flip_display();
    }
}



// these functions return the co-ordinate to the NESW, with wrap if necessary

int coordWest(int cX)
{
    return (cX == 0) ? MapSize - 1 : cX - 1;
}

int coordEast(int cX)
{
    return (cX == MapSize - 1) ? 0 : cX + 1;
}

int coordNorth(int cY)
{
    return (cY == 0) ? MapSize - 1 : cY - 1;
}

int coordSouth(int cY)
{
    return (cY == MapSize - 1) ? 0 : cY + 1;
}



// these function test if cell in given direction is passable
bool canGoNorth(Entity e)
{
    int testY = coordNorth(e.locY);       
    return (worldMap[testY][e.locX].canPass) ? true : false;
}

bool canGoSouth(Entity e)
{
    int testY = coordSouth(e.locY);
    return (worldMap[testY][e.locX].canPass) ? true : false;    
}

bool canGoWest(Entity e)
{
    int testX = coordWest(e.locX);
    return (worldMap[e.locY][testX].canPass) ? true : false;
}

bool canGoEast(Entity e)
{
    int testX = coordEast(e.locX);
    return (worldMap[e.locY][testX].canPass) ? true : false;
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



void processAction(Entity e)
{
    
    // get cell on which action will be performed
    int targetX, targetY;
    
    switch(e.facing)
    {
        case Direction.north :
            targetX = e.locX;
            targetY = coordNorth(e.locY);
            break;
        case Direction.south :
            targetX = e.locX;
            targetY = coordSouth(e.locY);
            break;        
        case Direction.west :
            targetY = e.locY;
            targetX = coordWest(e.locX);            
            break;         
        case Direction.east :
            targetY = e.locY;
            targetX = coordEast(e.locX);            
            break;           
        default:
        
    }    


    // process the action, depends upon type of tile in target cell
    switch(worldMap[targetY][targetX].tileType)
    {
        
            
        case TileType.water :
            addMessage("Gulp, slurp... you feel refreshed");
            break;
        
        default: 
            addMessage("?");
            break;          
        
    }
       
}
