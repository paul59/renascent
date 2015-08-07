
// allegro imports
import allegro5.allegro;

// app imports
import main :   queue,
                keyList;


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
                case ALLEGRO_KEY_ESCAPE:
                keyList["esc"] = true;
                break;
                case ALLEGRO_KEY_UP:
                keyList["up"] = true;
                break;
                case ALLEGRO_KEY_DOWN:
                keyList["down"] = true;
                break;
                case ALLEGRO_KEY_LEFT:
                keyList["left"] = true;
                break;
                case ALLEGRO_KEY_RIGHT:
                keyList["right"] = true;
                break;
                default:

            }
        }
        // keyup event? set key to false in AA
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
