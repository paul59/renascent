


pragma(lib, "dallegro5");
pragma(lib, "allegro");
pragma(lib, "allegro_primitives");
pragma(lib, "allegro_image");
pragma(lib, "allegro_font");
pragma(lib, "allegro_ttf");
pragma(lib, "allegro_color");

// D imports
import std.stdio : writeln;

// allegro imports
import allegro5.allegro;
import allegro5.allegro_primitives;
import allegro5.allegro_image;
import allegro5.allegro_font;
import allegro5.allegro_ttf;
import allegro5.allegro_color;

// app imports
import globals;
import game;


// app allegro global variables
ALLEGRO_DISPLAY* display;
ALLEGRO_EVENT_QUEUE* queue;
ALLEGRO_FONT* messageFont;

ALLEGRO_BITMAP* imgTileSet, imgPlayer, imgMob;


int main()
{

    return al_run_allegro(
    {
        // set up allegro
        al_init();
        display = al_create_display(1024, 768);
        queue = al_create_event_queue();
        al_install_keyboard();
        al_install_mouse();
        al_init_image_addon();
        al_init_font_addon();
        al_init_ttf_addon();
        al_init_primitives_addon();
        al_register_event_source(queue, al_get_display_event_source(display));
        al_register_event_source(queue, al_get_keyboard_event_source());
        al_register_event_source(queue, al_get_mouse_event_source());
        al_set_window_title(display, "Renascent");
        debug writeln("... allegro initialised");

        //init the keyboard AA
        keyList["esc"] = false;
        keyList["up"] = false;
        keyList["down"] = false;
        keyList["left"] = false;
        keyList["right"] = false;
        keyList["action"] = false;



        runGame();

        return 0;

    });
}
