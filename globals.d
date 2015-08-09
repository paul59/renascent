


Tile[MapSize][MapSize] worldMap;
Player player;
bool[string] keyList;
string[MessageBuffer] messageLines;


// app enums
enum TileSize = 16;
enum MapSize = 100;
enum Direction {north, east, south, west};
enum TileType {water, grass, rock, tree};
enum EntityType {human, rat, pig, bear, snake, ogre, butterfly}
enum MessageBuffer = 20;


struct Tile
{

    int tileType;     		// could add functions to change the type based on time
                            // so grass near water could become marsh in winter
                            // water could become ice etc

    int bitmapIndex;        // index in the tileset

    bool canPass;           // whether an entity can enter the tile
                            // water is passable subject ot other checks (eg if player also has a boat)
                            // wall or rock is not passable
}



struct Player
{

    int locX;
    int locY;
    int facing;
    int hp;
    int att;
    int def;
    int wood;

}
