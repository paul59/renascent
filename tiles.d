

enum TileTypes = {"water", "grass", "marsh", "woodland", "sand", "wall_ns", "wall_ew"};

struct Tile
{

	TileTypes tileType;		// use to select bitmap for drawing and other things
							// could add functions to change the type based on time
							// so grass near water could become marsh in winter
							// water could become ice etc
							
	bool canPass;			// whether an entity can enter the tile 
							// water is passable subject ot other checks (eg if player also has a boat)
							// wall or rock is not passable
	

}
