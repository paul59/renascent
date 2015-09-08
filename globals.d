
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


struct Mouse
{
    int x, y;               // position
}


Tile[][] worldMap = new Tile[][](MapSize, MapSize);
import entity: Entity;
Entity[numMobs] mobs;


// app enums

// map and tile related
enum TileSize = 32;
enum MapSize = 100;
enum Direction {north, east, south, west};
enum TileType {water, grass, rock, tree};

// message related
enum MsgBoxX = 680;
enum MsgBoxY = 200;
enum MsgBoxWidth = 280;
enum MessageColor {white, red, green, yellow};
enum MessageBufferSize = 30;

// creature related
enum numMobs = 50;
enum Creatures {human, butterfly, ogre, fox}


