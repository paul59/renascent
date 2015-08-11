

// D imports
import std.conv;
import std.string;
import std.math : abs;


// allegro imports
import allegro5.allegro;
import allegro5.allegro_primitives;
import allegro5.allegro_image;
import allegro5.allegro_font;
import allegro5.allegro_ttf;
import allegro5.allegro_color;

// app imports
import globals;
import main;



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




void renderMobs()
{
    
    al_set_target_bitmap(al_get_backbuffer(display));
    
    if( abs(mob.locX - player.locX) <= 10 && abs(mob.locY - player.locY) <= 10)
    {

        int dX = mob.locX - player.locX;
        int dY = mob.locY - player.locY;
        
        // ignore facing for now
        al_draw_bitmap_region(imgMob, 0, 0, TileSize, TileSize, 10 * TileSize + dX * TileSize, 10 * TileSize + dY * TileSize, 0);
        
        //al_draw_bitmap_region(imgPlayer, player.facing * TileSize, 0, TileSize, TileSize, 10 * TileSize, 10 * TileSize, 0);
    
    }
    
}






void renderHUD()
{

    ALLEGRO_COLOR colorWhite = al_map_rgb(255,255,255);
    
    string output = "Entity: " ~ player.entity.name;
    al_draw_text(messageFont, colorWhite, StatsX, StatsY, ALLEGRO_ALIGN_LEFT, output.toStringz);
        
    output = "Soul Points: " ~ to!string(player.sp);
    al_draw_text(messageFont, colorWhite, StatsX, StatsY+16, ALLEGRO_ALIGN_LEFT, output.toStringz);	
    
    output = "Life Points: " ~ to!string(player.entity.basehp);
    al_draw_text(messageFont, colorWhite, StatsX, StatsY+32, ALLEGRO_ALIGN_LEFT, output.toStringz);

    output = "ATT: " ~ to!string(player.att);
    al_draw_text(messageFont, colorWhite, StatsX, StatsY+48, ALLEGRO_ALIGN_LEFT, output.toStringz);
    
    output = "DEF: " ~ to!string(player.hp);
    al_draw_text(messageFont, colorWhite, StatsX, StatsY+64, ALLEGRO_ALIGN_LEFT, output.toStringz);

    output = "WOOD: " ~ to!string(player.wood);
    al_draw_text(messageFont, colorWhite, StatsX, StatsY+80, ALLEGRO_ALIGN_LEFT, output.toStringz);
    
}


void renderMessages()
{
    
    ALLEGRO_COLOR colorYellow = al_map_rgb(255,255,0);
    foreach(y, output; messageLines)
    {
        al_draw_text(messageFont, colorYellow, MsgBoxX, MsgBoxY + y * 16, ALLEGRO_ALIGN_LEFT, output.toStringz);
        
    }
    
}
