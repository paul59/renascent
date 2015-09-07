// D imports
import std.stdio : writeln;
import std.random : uniform;
import std.conv;

// allegro imports
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
import message : addMessage, MessageColor;



/*
 * present the main menu
 * 
 */
 

void mainMenu()
{
   
   
    //init the keyboard AA
    //will need to use in menu so declare here
    bool[string] keyList;
    keyList["esc"] = false;
    keyList["up"] = false;
    keyList["down"] = false;
    keyList["left"] = false;
    keyList["right"] = false;
    keyList["action"] = false;   
        
    debug writeln("... main menu");

    // stay in menu until new game, load, quit
    // for now just play new
    newGame(keyList);
}





/**
 * initialise and play a new game
 *
 **/
void newGame(ref bool[string] keyList)
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
     
    // init player
    Entity player;
    player = Entity(Creatures.human);
    
    // init mobs
    foreach(i; 0..numMobs)
    {  
         mobs[i] = Entity(Creatures.butterfly);    
    }


   
    addMessage(MessageColor.green,  "Renascent...");
    addMessage(MessageColor.white,  "Arrows: Move");
    addMessage(MessageColor.white,  "NumPad Arrows: Face");
    addMessage(MessageColor.white,  "NumPad 0: Action");
    addMessage(MessageColor.white,  "When you have sufficient soul points you can transform yourself into any previous form at will");
    addMessage(MessageColor.green,  "If you could find a compass, you could work out your position... handy for quests");
    addMessage(MessageColor.red,    "LOOK OUT out for the giant red butterfly!");
    addMessage(MessageColor.white,  "This is a very long message, designed solely for testing purposes so lets
                                    hope it works properly, otherwise I'll have to re-write the function. Dang!");

    
    // MAIN LOOP
  
    while(flagPlaying)
    {

        // update the assoc array with key states
        player = updateKeys(keyList, player);

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

        // clear screen and render all the bits
        al_clear_to_color(al_map_rgb(0, 0, 0));
        renderMap(player);
        renderPlayer(player);
        foreach(m; mobs)
        {           
            renderMobs(m, player);      
        }
        renderHUD(player);
        renderMessages();
        
        // show
        al_flip_display();
    }
}



// these functions return the co-ordinate to the NES or W, with wrap if necessary

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
    messageFont = al_load_bitmap_font("./resources/a4_font.tga");
    if(messageFont == null) return false;
    
    return true;

    
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
            addMessage(MessageColor.green, "Gulp, slurp... you feel refreshed");
            break;
        
        default: 
            addMessage(MessageColor.red, "wtf?");
            break;          
        
    }
       
}
