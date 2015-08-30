

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
import entity : Entity;



// draw 21x21 tiles centred on player
void renderMap(Entity e)
{
    int cellX = e.locX - 10;
    int cellY = e.locY - 10;
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

void renderPlayer(Entity e)
{

    //al_set_target_bitmap(al_get_backbuffer(display));

    al_draw_bitmap_region(imgPlayer, e.facing * TileSize, 0, TileSize, TileSize, 10 * TileSize, 10 * TileSize, 0);
   

}




void renderMobs(Entity e, Entity p)
{
    
    al_set_target_bitmap(al_get_backbuffer(display));
    
    if( abs(e.locX - e.locX) <= 10 && abs(e.locY - e.locY) <= 10)
    {

        int dX = e.locX - p.locX;
        int dY = e.locY - p.locY;
        
        // ignore facing for now
        al_draw_bitmap_region(imgMob, 0, 0, TileSize, TileSize, 10 * TileSize + dX * TileSize, 10 * TileSize + dY * TileSize, 0);      
    
    }
    
}






void renderHUD(Entity e)
{

    ALLEGRO_COLOR colorWhite = al_map_rgb(255,255,255);
    
    enum StatsX = 680;
    enum StatsY = 16;
    
    
    
    string output = "Entity: " ~ e.entity.name;
    al_draw_text(messageFont, colorWhite, StatsX, StatsY, ALLEGRO_ALIGN_LEFT, output.toStringz);
        
    output = "Soul Points: " ~ to!string(e.sp);
    al_draw_text(messageFont, colorWhite, StatsX, StatsY+16, ALLEGRO_ALIGN_LEFT, output.toStringz);	
    
    output = "Life Points: " ~ to!string(e.entity.basehp);
    al_draw_text(messageFont, colorWhite, StatsX, StatsY+32, ALLEGRO_ALIGN_LEFT, output.toStringz);

    output = "ATT: " ~ to!string(e.att);
    al_draw_text(messageFont, colorWhite, StatsX, StatsY+48, ALLEGRO_ALIGN_LEFT, output.toStringz);
    
    output = "DEF: " ~ to!string(e.hp);
    al_draw_text(messageFont, colorWhite, StatsX, StatsY+64, ALLEGRO_ALIGN_LEFT, output.toStringz);

 
    // show info about tile under mouse cursor
    string[int] tileNames = [ 0:"Water", 1:"Grass", 2:"Rock", 3:"Tree"];
    if(flagMouseOverMap)
    {
        
        // get screen cell eg 5,5
        
        int mouseScreenCellX = mouseX/TileSize;
        int mouseScreenCellY = mouseY/TileSize;
        
        // convert to world co-ords, wrap if required
        int wX = e.locX + (mouseScreenCellX - 10);
        int wY = e.locY + (mouseScreenCellY - 10);
        
        if(wX < 0 )
        {
            wX += MapSize;
        }
        if(wX > MapSize-1 )
        {
            wX -= MapSize;
        }        
        if(wY < 0 )
        {
            wY += MapSize;
        }
        if(wY > MapSize - 1 )
        {
            wY -= MapSize;
        }                 
        output = "Terrain: " ~ tileNames[worldMap[wY][wX].tileType];
        al_draw_text(messageFont, colorWhite, StatsX, StatsY+128, ALLEGRO_ALIGN_LEFT, output.toStringz);
        
    }
    
}


void renderMessages()
{
    enum MsgBoxX = 680;
    enum MsgBoxY = 400;
    
    ALLEGRO_COLOR colorYellow = al_map_rgb(255,255,0);
    foreach(y, output; messageLines)
    {
        al_draw_text(messageFont, colorYellow, MsgBoxX, MsgBoxY + y * 16, ALLEGRO_ALIGN_LEFT, output.toStringz);
        
    }
    
}


void renderCursor()
{
    
    int mouseDrawX = (mouseX / TileSize) * TileSize;
    int mouseDrawY = (mouseY / TileSize) * TileSize;
    
    // only draw if over map 
    flagMouseOverMap = false;
    if(mouseX < 21*TileSize && mouseY < 21*TileSize)
    {
        al_draw_rectangle( mouseDrawX, mouseDrawY, mouseDrawX + TileSize, mouseDrawY + TileSize, al_map_rgb(255,255,255), 1);
        flagMouseOverMap = true;
    }
    
}

