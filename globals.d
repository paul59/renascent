
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


Tile[][] worldMap = new Tile[][](100,100);

import entity: Entity;
Entity[numMobs] mobs;


bool[string] keyList;

int mouseX, mouseY;
bool flagMouseOverMap;


import std.datetime : StopWatch;
StopWatch gameTimer;




// app enums
enum TileSize = 32;
enum MapSize = 100;


enum Direction {north, east, south, west};
enum TileType {water, grass, rock, tree};

enum MsgBoxX = 680;
enum MsgBoxY = 200;
enum MsgBoxWidth = 280;

enum numMobs = 50;
