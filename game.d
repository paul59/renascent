// D imports
import std.stdio : writeln;

// allegro imports
import allegro5.allegro;

// app imports
import  main :
        queue,
        imgTileSet,
        imgPlayer,
        TileSize,
        MapSize,
        playerX,
        playerY;

import  world :
		generateMap;

import  render :
		renderMap,
		renderPlayer;

import	input;




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
    loadResources();
    generateMap();
    playerX = 50;
    playerY = 50;
    // generateNPCs();
    // generatePlayer();


    // play until quit
    debug writeln("... entering main loop");
    while(flagPlaying)
    {

        //update the assoc array with key states
        updateKeys();

        if(keyList["esc"]) flagPlaying = false;

        if(keyList["up"])
        {
			if(playerY > 0)
			{
				--playerY;
			} else
			{
				playerY = MapSize - 1;
			}

			keyList["up"] = false;
		}

        if(keyList["down"])
        {
			if(playerY < MapSize-1)
			{
				++playerY;
			} else
			{
				playerY = 0;
			}
			keyList["down"] = false;
		}

        if(keyList["left"])
        {
			if(playerX > 0)
			{
				--playerX;
			} else
			{
				playerX = MapSize - 1;
			}

			keyList["left"] = false;
		}

        if(keyList["right"])
        {
			if(playerX < MapSize-1)
			{
				++playerX;
			} else
			{
				playerX = 0;
			}
			keyList["right"] = false;
		}


		renderMap();
		renderPlayer();
        al_flip_display();
    }
}








void loadResources()
{

    debug writeln("... loading resources");
    imgTileSet = al_load_bitmap("./resources/tileset.png");
    imgPlayer = al_load_bitmap("./resources/player.png");


}
