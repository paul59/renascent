
// allegro imports
import allegro5.allegro;

// app imports
import main :   queue,
                keyList,
                player,
                Direction;


void updateKeys()
{
    bool retVal = false;
    ALLEGRO_EVENT event;

    // get next event from queue
    while(al_get_next_event(queue, &event))
    {

        // could combine these switch atemants into one piece of code e.g., if keydownevent set flag true
        // if keyupevent set flag false then use keyList["..."] = flag;
        
        // keydown event?
        if(event.type == ALLEGRO_EVENT_KEY_DOWN)
        {
            switch(event.keyboard.keycode)
            {
                
                // escape
                case ALLEGRO_KEY_ESCAPE:
                keyList["esc"] = true;
                break;

                // action button
                case ALLEGRO_KEY_PAD_0:
                keyList["action"] = true;
                break;
                
                // movement keys
                case ALLEGRO_KEY_UP:
                keyList["up"] = true;
                player.facing = Direction.north;
                break;
                case ALLEGRO_KEY_DOWN:
                player.facing = Direction.south;
                keyList["down"] = true;
                break;
                case ALLEGRO_KEY_LEFT:
                keyList["left"] = true;
                player.facing = Direction.west;
                break;
                case ALLEGRO_KEY_RIGHT:
                keyList["right"] = true;
                player.facing = Direction.east;
                break;
                
                // facing keys
                case ALLEGRO_KEY_PAD_8:
                player.facing = Direction.north;
                break;
                case ALLEGRO_KEY_PAD_6:
                player.facing = Direction.east;
                break; 
                case ALLEGRO_KEY_PAD_2:
                player.facing = Direction.south;
                break;
                case ALLEGRO_KEY_PAD_4:
                player.facing = Direction.west;
                break;                
                
                default:

            }
        }
        
        // keyup event for movement keys - set key to false in AA
        if(event.type == ALLEGRO_EVENT_KEY_UP)
        {
            switch(event.keyboard.keycode)
            {
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

    }


}
