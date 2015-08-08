// D imports
import std.stdio : writeln;
import std.random : uniform;

// allegro imports
import allegro5.allegro;
import allegro5.allegro_ttf;
import allegro5.allegro_font;

// app imports
import  main :
        queue,
        messageFont,
        imgTileSet,
        imgPlayer,
        TileSize,
        MapSize,
        MessageBuffer,
        player,
        worldMap;

import  world :
        generateMap;

import  render;

import  input;

import  entity;




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
    player.hp = 25;
    player.att = 5;
    player.def = 5;   
    // generateNPCs();
    // generatePlayer();


    // play until quit
    debug writeln("... entering main loop");
    
    addMessage("Renascent...");
    addMessage("Arrows: Move");
    addMessage("NumPad Arrows: Face");
    addMessage("NumPad 0: Action");
    while(flagPlaying)
    {

        // update the assoc array with key states
        updateKeys();

        if(keyList["esc"]) flagPlaying = false;
        
        if(keyList["action"])
        {
            addMessage("some action attempted");
            keyList["action"] = false;
        }

        if(keyList["up"])
        {        
            if(canGoNorth())
            {
                if(player.locY > 0)
                {
                    --player.locY;
                } else
                {
                    player.locY = MapSize - 1;
                }
                //player.facing = Direction.north;
            }
            keyList["up"] = false;
        }

        if(keyList["down"])
        {
            if(canGoSouth())
            {            
                if(player.locY < MapSize-1)
                {
                    ++player.locY;
                } else
                {
                    player.locY = 0;
                }
                //player.facing = Direction.south;
            }
            keyList["down"] = false;
        }

        if(keyList["left"])
        {
            if(canGoWest())
            {
                if(player.locX > 0)
                {
                    --player.locX;
                } else
                {
                    player.locX = MapSize - 1;
                }
                //player.facing = Direction.west;
            }
            keyList["left"] = false;
        }

        if(keyList["right"])
        {
            if(canGoEast())
            {
                if(player.locX < MapSize-1)
                {
                    ++player.locX;
                } else
                {
                    player.locX = 0;
                }
                //player.facing = Direction.east;
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



bool canGoNorth()
{
    int testY = player.locY - 1;
    if(testY == -1) testY = MapSize - 1;
    if(worldMap[testY][player.locX].canPass) return true;
    
    return false;
}


bool canGoSouth()
{
    int testY = player.locY + 1;
    if(testY == MapSize) testY = 0;
    if(worldMap[testY][player.locX].canPass) return true;
    
    return false;
}

bool canGoWest()
{
    int testX = player.locX - 1;
    if(testX == -1) testX = MapSize - 1;
    if(worldMap[player.locY][testX].canPass) return true;
    
    return false;
}


bool canGoEast()
{
    int testX = player.locX + 1;
    if(testX == MapSize) testX = 0;
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

