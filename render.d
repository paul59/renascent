

// D imports
import std.conv;
import std.string;


// allegro imports
import allegro5.allegro;
import allegro5.allegro_primitives;
import allegro5.allegro_image;
import allegro5.allegro_font;
import allegro5.allegro_ttf;
import allegro5.allegro_color;

// app imports
import main :   MapSize,
                worldMap,
                imgTileSet,
                imgPlayer,
                TileSize,
                player,
                display,
                messageFont,
                messageLines;



// draw 21x21 tiles centred on player
void renderMap()
{
    int cellX = player.locX - 10;
    int cellY = player.locY - 10;
    int startX = cellX;

    // draw to buffer
    al_set_target_bitmap(al_get_backbuffer(display));

    // wrap if necessary
    if(cellY < 0) cellY += MapSize;

    foreach(y; 0..21)
    {
        // wrap?
        if(cellY == MapSize) cellY = 0;

        foreach(x; 0..21)
        {
            // wrap - can move some of this out of loop
            if(cellX < 0) cellX += MapSize;
            if(cellX == MapSize) cellX = 0;

            int tileIndex = worldMap[cellY][cellX].bitmapIndex;
            al_draw_bitmap_region(imgTileSet, tileIndex * TileSize, 0, TileSize, TileSize, x * TileSize, y * TileSize, 0);
            ++cellX;

        }
        ++cellY;
        cellX = startX;
    }
}

void renderPlayer()
{

    al_set_target_bitmap(al_get_backbuffer(display));

    al_draw_bitmap_region(imgPlayer, player.facing * TileSize, 0, TileSize, TileSize, 10 * TileSize, 10 * TileSize, 0);

}

void renderHUD()
{
	
    
    string output = "HP: " ~ to!string(player.hp);
    al_draw_text(messageFont, al_map_rgb(255,255,255), 0, 416, ALLEGRO_ALIGN_LEFT, output.toStringz);

    output = "ATT: " ~ to!string(player.att);
    al_draw_text(messageFont, al_map_rgb(255,255,255), 0, 432, ALLEGRO_ALIGN_LEFT, output.toStringz);
    
    output = "DEF: " ~ to!string(player.hp);
    al_draw_text(messageFont, al_map_rgb(255,255,255), 0, 448, ALLEGRO_ALIGN_LEFT, output.toStringz);
    
}


void renderMessages()
{
    
    foreach(y, output; messageLines)
    {
        al_draw_text(messageFont, al_map_rgb(255,255,255), 500, y * 16, ALLEGRO_ALIGN_LEFT, output.toStringz);
        
    }
    
}
