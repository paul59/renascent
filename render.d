


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
                display;



// draw 21x21 tiles centred on player
void renderMap()
{
    int cellX = playerX - 10;
    int cellY = playerY - 10;
    int startX = cellX;

    // draw to buffer
    al_set_target_bitmap(al_get_backbuffer(display));

    foreach(y; 0..21)
    {
        // wrap
        if(cellY < 0) cellY += MapSize;
        if(cellY == MapSize) cellY = 0;

        foreach(x; 0..21)
        {
            // wrap
            if(cellX < 0) cellX += MapSize;
            if(cellX == MapSize) cellX = 0;

            int tileIndex = worldMap[cellY][cellX];
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
