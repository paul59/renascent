

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
                playerX,
                playerY,
                display,
                messageFont;



// draw 21x21 tiles centred on player
void renderMap()
{
    int cellX = playerX - 10;
    int cellY = playerY - 10;
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

    al_draw_bitmap(imgPlayer, 10 * TileSize, 10 * TileSize, 0);

}

void renderHUD()
{
	
	al_draw_text(messageFont, al_map_rgb(255,255,255), 600, 0, ALLEGRO_ALIGN_CENTRE, "HUD");
}
