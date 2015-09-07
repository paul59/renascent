
// allegro imports
import allegro5.allegro;

import std.conv;

// app imports
import globals;
import main;
import entity : Entity;


Entity updateKeys(ref bool[string] keyList, Entity e)
{
    bool retVal = false;
    ALLEGRO_EVENT event;

    // get next event from queue
    while(al_get_next_event(queue, &event))
    {
      
        // keydown event?
        if(event.type == ALLEGRO_EVENT_KEY_DOWN)
        {
            switch(event.keyboard.keycode)
            {
                
                // escape
                case ALLEGRO_KEY_ESCAPE:
                keyList["esc"] = true;
                break;

                case ALLEGRO_KEY_Q:
                keyList["esc"] = true;
                break;

                // action button
                case ALLEGRO_KEY_PAD_0:
                keyList["action"] = true;
                break;
                
                // movement keys
                case ALLEGRO_KEY_UP:
                keyList["up"] = true;
                e.facing = Direction.north;
                break;
                case ALLEGRO_KEY_DOWN:
                e.facing = Direction.south;
                keyList["down"] = true;
                break;
                case ALLEGRO_KEY_LEFT:
                keyList["left"] = true;
                e.facing = Direction.west;
                break;
                case ALLEGRO_KEY_RIGHT:
                keyList["right"] = true;
                e.facing = Direction.east;
                break;
                
                // facing keys
                case ALLEGRO_KEY_PAD_8:
                e.facing = Direction.north;
                break;
                case ALLEGRO_KEY_PAD_6:
                e.facing = Direction.east;
                break; 
                case ALLEGRO_KEY_PAD_2:
                e.facing = Direction.south;
                break;
                case ALLEGRO_KEY_PAD_4:
                e.facing = Direction.west;
                break;                
                
                default:

            }
        }
        
        /* no need for these as we will set to false them when acted upon
        // keyup event for movement keys - set key to false in AA
        if(event.type == ALLEGRO_EVENT_KEY_UP)
        {
            switch(event.keyboard.keycode)
            {
                
                // direction keys released
                case ALLEGRO_KEY_UP:
                keyList["up"] = false;
                break;
                case ALLEGRO_KEY_DOWN:
                keyList["down"] = false;
                break;
                case ALLEGRO_KEY_LEFT:
                keyList["left"] = false;
                break;
                case ALLEGRO_KEY_RIGHT:
                keyList["right"] = false;
                break;
                default:

            }
        }
        */
        
        if(event.type == ALLEGRO_EVENT_MOUSE_AXES || event.type == ALLEGRO_EVENT_MOUSE_ENTER_DISPLAY)
        {       
       
            mouseX = event.mouse.x;
            mouseY = event.mouse.y;

        }

    }
    
    return e;
}
