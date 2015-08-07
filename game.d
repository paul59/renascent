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
        playerX,
        playerY,
        worldMap;

import  world :
        generateMap;

import  render;

import    input;






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
    playerX = rX;
    playerY = rY;    
    // generateNPCs();
    // generatePlayer();


    // play until quit
    debug writeln("... entering main loop");
    while(flagPlaying)
    {

        // update the assoc array with key states
        updateKeys();

        if(keyList["esc"]) flagPlaying = false;

        if(keyList["up"])
        {        
            if(canGoNorth())
            {
                if(playerY > 0)
                {
                    --playerY;
                } else
                {
                    playerY = MapSize - 1;
                }
            }
            keyList["up"] = false;
        }

        if(keyList["down"])
        {
            if(canGoSouth())
            {            
                if(playerY < MapSize-1)
                {
                    ++playerY;
                } else
                {
                    playerY = 0;
                }
            }
            keyList["down"] = false;
        }

        if(keyList["left"])
        {
            if(canGoWest())
            {
                if(playerX > 0)
                {
                    --playerX;
                } else
                {
                    playerX = MapSize - 1;
                }
            }
            keyList["left"] = false;
        }

        if(keyList["right"])
        {
            if(canGoEast())
            {
                if(playerX < MapSize-1)
                {
                    ++playerX;
                } else
                {
                    playerX = 0;
                }
            }
            keyList["right"] = false;
        }


        renderMap();
        renderPlayer();
        renderHUD();
        
        al_flip_display();
    }
}



bool canGoNorth()
{
    int testY = playerY - 1;
    if(testY == -1) testY = MapSize - 1;
    if(worldMap[testY][playerX].canPass) return true;
    
    return false;
}


bool canGoSouth()
{
    int testY = playerY + 1;
    if(testY == MapSize) testY = 0;
    if(worldMap[testY][playerX].canPass) return true;
    
    return false;
}

bool canGoWest()
{
    int testX = playerX - 1;
    if(testX == -1) testX = MapSize - 1;
    if(worldMap[playerY][testX].canPass) return true;
    
    return false;
}


bool canGoEast()
{
    int testX = playerX + 1;
    if(testX == MapSize) testX = 0;
    if(worldMap[playerY][testX].canPass) return true;
    
    return false;
}



bool loadResources()
{

    debug writeln("... loading resources");
    
    imgTileSet = al_load_bitmap("./resources/tileset.png");
    if(imgTileSet == null) return false;
    imgPlayer = al_load_bitmap("./resources/player.png");
    if(imgPlayer == null) return false;
    messageFont = al_load_ttf_font("./resources/msgfont.ttf",16, 0 );
    if(messageFont == null) return false;
    
    return true;

    
}
