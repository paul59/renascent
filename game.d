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
    ALLEGRO_KEYBOARD_STATE *state;

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
			playerY > 0 ?  --playerY : playerY = MapSize - 1;
			keyList["up"] = false;
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
