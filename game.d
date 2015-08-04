
import std.stdio : writeln;

import allegro5.allegro;

import main : queue;




void runGame()
{
	debug writeln("... main menu");

	//stay in menu until new game, load, quit
	
	//for now just play new
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
	
	//init game
	//initGame()
	
	//play until quit
	debug writeln("... entering main loop");
	while(flagPlaying)
	{		
		if(keyDown(ALLEGRO_KEY_ESCAPE)) flagPlaying = false;
	}
	
}



/**
 * check if the specified key is pressed
 * it would be better to read all the events from the queue frequently and stuff
 * keyboard events into an array so we can handle multiple keys
 * 
 **/
bool keyDown(int testKey)
{
	bool retVal = false;
	ALLEGRO_EVENT event;
	
	while(al_get_next_event(queue, &event))
	{
		if(event.type == ALLEGRO_EVENT_KEY_DOWN)
		{
			if(event.keyboard.keycode == testKey) retVal = true;
		}		
	}	
	
	return(retVal);
}
