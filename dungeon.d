// with int[x][y] tiles = [[0,1], [2,3]]
// tiles[0][1] == 1
// that is, tiles[row][column]


import globals;
import world;

enum SplitType { vertical, horizontal};


struct TileRegion
{
    TileRegion*[2] childRegions;
    TileRegion* siblingRegion;
    SplitType splitType;

    Rect rect;
}


Tile[][] generateBSPDungeonLevel (TileRegion region, Tile[][] tiles)
{
    import std.stdio;
    Tile[][] newTiles = copy2DArray(tiles);
    TileRegion[] regions = [region];

    //TODO: making sure that the end regions aren't too small!
    int i = 0;
    while ( i < 8)
    {
        try
        {
            regions = performBinarySplit(i, 0.5, regions);
        }
        catch (Exception exception)
        {
            writeln("can't split any more!");
            break;
        }
        ++i;
    }

    // find all the nodes which aren't parents and give them a room
    foreach (TileRegion r; regions)
    {
        if (r.childRegions[0] is null)
        {
            newTiles = filterAndConvertInRect(
                    newTiles,
                    addRandomRectInTileRegion(r),
                    (tile => Tile(TileType.grass, 1, true)),
                    ((newTiles, x, y) => true));
        }
    }
    writeln(tileArrayToString(newTiles));

    return newTiles;

    //connectRegions(regions[1]);


    //draw the result
    //writeln(tileArrayToString(tiles));
}


// need to fix splitRatio
private TileRegion[] performBinarySplit (
    in size_t parentRegionIndex,
    in double splitRatio,
    TileRegion[] regions)
{
    import std.random : uniform;
    import std.conv;
    import std.stdio;
    import std.math : floor;

    assert(splitRatio <= 0.5);

    TileRegion[] newRegions = regions.dup;

    Rect regionOneRect, regionTwoRect;

    size_t startHeight = newRegions[parentRegionIndex].rect.bottom - newRegions[parentRegionIndex].rect.top;
    size_t startWidth = newRegions[parentRegionIndex].rect.right - newRegions[parentRegionIndex].rect.left;

    //check width and height to determine allowed split types
    //if none is allowed then throw an exception which will be caught outside
    // EXCEPTION IS NOT STOPPING THE CALLING LOOP
    if ((startHeight < 8) && (startWidth < 8))
    {
        throw new Exception("Region is too small for BSP");
    }
    else if (startHeight < 8)
    {
        newRegions[parentRegionIndex].splitType = SplitType.vertical;
    }
    else if (startWidth < 8)
    {
        newRegions[parentRegionIndex].splitType = SplitType.horizontal;
    }
    else
    {
        newRegions[parentRegionIndex].splitType = uniform!SplitType();
    }

    if (newRegions[parentRegionIndex].splitType == SplitType.vertical)
    {
        size_t splitX;
        if (splitRatio == 0.5)
        {
            splitX = newRegions[parentRegionIndex].rect.right - startWidth/2;
        }
        else
        {
            splitX = uniform(newRegions[parentRegionIndex].rect.left + to!ulong(floor(startWidth*splitRatio))
                    ,newRegions[parentRegionIndex].rect.right - to!ulong(floor(startWidth*splitRatio)));
        }
        //debug writefln("vertical split at %s", splitX);

        regionOneRect = Rect(newRegions[parentRegionIndex].rect.left,
                splitX,
                newRegions[parentRegionIndex].rect.top,
                newRegions[parentRegionIndex].rect.bottom);
        regionTwoRect = Rect(splitX,
                newRegions[parentRegionIndex].rect.right,
                newRegions[parentRegionIndex].rect.top,
                newRegions[parentRegionIndex].rect.bottom);
    }
    else //horizontal split
    {
        size_t splitY;
        if (splitRatio == 0.5)
        {
            splitY = newRegions[parentRegionIndex].rect.bottom - startHeight/2;
        }
        else
        {
            splitY = uniform(newRegions[parentRegionIndex].rect.top + to!ulong(floor(startWidth*splitRatio))
                    ,newRegions[parentRegionIndex].rect.bottom - to!ulong(floor(startWidth*splitRatio)));
        }
        //debug writefln("horizontal split at %s", splitY);

        regionOneRect = Rect(newRegions[parentRegionIndex].rect.left,
                newRegions[parentRegionIndex].rect.right,
                newRegions[parentRegionIndex].rect.top,
                splitY);
        regionTwoRect = Rect(newRegions[parentRegionIndex].rect.left,
                newRegions[parentRegionIndex].rect.right,
                splitY,
                newRegions[parentRegionIndex].rect.bottom);
    }

    newRegions ~= TileRegion([null,null], null, SplitType.vertical, regionOneRect);
    newRegions ~= TileRegion([null,null], null, SplitType.vertical, regionTwoRect);

    newRegions[parentRegionIndex].childRegions[0] = &(newRegions[$-2]);
    newRegions[$-1].siblingRegion = &(newRegions[$-2]);
    newRegions[parentRegionIndex].childRegions[1] = &(newRegions[$-1]);
    newRegions[$-2].siblingRegion = &(newRegions[$-1]);

    return newRegions;
}


private Tile[][] filterAndConvertInRect(
        Tile[][] tiles,
        Rect rect,
        Tile function(Tile) converter,
        bool function(Tile[][], size_t, size_t) predicate)
{
    Tile[][] newTiles = copy2DArray(tiles);

    for (size_t y = rect.top; y < rect.bottom; y++)
    {
        for (size_t x = rect.left; x < rect.right; x++)
        {
            if (predicate(tiles, x, y))
            {
                newTiles[x][y] = converter(tiles[x][y]);
            }
        }
    }
    return newTiles;
}


private Rect addRandomRectInTileRegion(
        TileRegion region)
{
    import std.random : uniform;

    size_t roomTop = uniform(region.rect.top, region.rect.bottom-4);
    size_t roomBottom = uniform(roomTop+4, region.rect.bottom);
    size_t roomLeft = uniform(region.rect.left, region.rect.right-4);
    size_t roomRight = uniform(roomLeft+4, region.rect.right);

    Rect returnRect = Rect(roomTop, roomBottom, roomLeft, roomRight);
    return returnRect;
}



// this is horrible
// tidy up how I determine the overlap
//could instead create a rect in the gap and perform a random walk to connect
private void connectRegions(TileRegion parent)
{
    import std.stdio;
    //my childRegions arrays are null! :( why????
    writeln("connecting");
    writeln(parent.childRegions);
    TileRegion childOne = *(parent.childRegions[0]);
    writeln("got One");
    TileRegion childTwo = *(parent.childRegions[1]);
    // check the parent to get the split type
    if (parent.splitType == SplitType.vertical)
    {
    // check if the rects overlap across the split
        if (childTwo.rect.top <childOne.rect.top && childTwo.rect.bottom < childOne.rect.top)
        {
            writeln("no overlap");
        }
        else if (childTwo.rect.top < childOne.rect.top && childTwo.rect.bottom > childOne.rect.top && childTwo.rect.bottom < childOne.rect.bottom)
        {
            writeln("overlap at top of one");
        }
        else if(childTwo.rect.top > childOne.rect.top && childTwo.rect.bottom < childOne.rect.bottom)
        {
            writeln("two is inside one");
        }
        else if(childTwo.rect.top > childOne.rect.top && childTwo.rect.top < childOne.rect.bottom && childTwo.rect.bottom > childOne.rect.bottom)
        {
            writeln("overlap at bottom of one");
        }
        else if(childTwo.rect.top > childOne.rect.bottom)
        {
            writeln("no overlap");
        }
        else
        {
            writeln("one is inside two");
        }

    // if so, correct with a straight path
    }
    else if (parent.splitType == SplitType.horizontal)
    {

        if (childTwo.rect.left <childOne.rect.left && childTwo.rect.right < childOne.rect.left)
        {
            writeln("no overlap");
        }
        else if (childTwo.rect.left < childOne.rect.left && childTwo.rect.right > childOne.rect.left && childTwo.rect.right < childOne.rect.right)
        {
            writeln("overlap at left of one");
        }
        else if(childTwo.rect.left > childOne.rect.left && childTwo.rect.right < childOne.rect.right)
        {
            writeln("two is inside one");
        }
        else if(childTwo.rect.left > childOne.rect.left && childTwo.rect.left < childOne.rect.right && childTwo.rect.right > childOne.rect.right)
        {
            writeln("overlap at right of one");
        }
        else if(childTwo.rect.left > childOne.rect.right)
        {
            writeln("no overlap");
        }
        else
        {
            writeln("one is inside two");
        }
    }
}

// do some cellular automata-based dungeon generation!!!
// TODO: ensure traversability
// - can use flood-fill from entrance to check
// input var tiles is being changed through function. this shouldn't happen
// need to change iterations so that walls with too few neighbours are removed
Tile[][] generateCADungeonLevel (TileRegion region, Tile[][] tiles)
{
    import std.random : uniform;
    import std.stdio;
    Tile[][] newTiles = copy2DArray(tiles);

    //random start
    newTiles = filterAndConvertInRect(
            newTiles,
            region.rect,
            (tile) => Tile(TileType.grass, 1, true),
            (tiles, x, y) => uniform(0.0, 1.0) > 0.45);

    //iterate with the rule
    newTiles = filterAndConvertInRect(
            newTiles,
            region.rect,
            (tile) => Tile(TileType.grass, 1, true),
            (tiles, x, y) => countNeighboursOfType(tiles,x,y,TileType.grass) > 5);
    newTiles = filterAndConvertInRect(
            newTiles,
            region.rect,
            (tile) => Tile(TileType.rock, 2, false),
            (tiles, x, y) => countNeighboursOfType(tiles,x,y,TileType.grass) <= 5);


    //newTiles = floodFillInRect(
           //newTiles,
           //region.rect,
           //Point(0,0),
           //tile => Tile(TileType.tree, tile.bitmapIndex, tile.canPass),
           //(tiles, x, y) => tiles[x][y].tileType != TileType.rock);

    //writeln("after a flood of 3 from tile 0,0");
    //writeln(tileArrayToString(newTiles));

    return newTiles;
}

private int countNeighboursOfType(
        Tile[][] tiles,
        size_t x,
        size_t y,
        TileType tileType)
{
    int count = 0;

    size_t lowerX = (x==0) ? x: x-1;
    size_t upperX = (x==tiles[0].length-1) ? x+1: x+2;
    size_t lowerY = (y==0) ? y: y-1;
    size_t upperY = (y==tiles.length-1) ? y+1: y+2;

    for (size_t testY = lowerY; testY < upperY; ++testY)
    {
        for(size_t testX = lowerX; testX < upperX; ++testX)
        {
            if (tiles[testX][testY].tileType == tileType)
            {
                ++count;
            }
        }
    }
    return count;
}

private Tile[][] filterAndConvertOnWalk(
        Tile[][] tiles,
        Rect rect,
        Point point,
        Tile function(Tile) converter,
        bool function(Tile[][], size_t, size_t) predicate,
        bool function(Tile[][], size_t, size_t) stopCondition)
{
    import std.random : uniform;

    Tile[][] newTiles = copy2DArray(tiles);
    Point[] walk = [point];

    while (true)
    {
        int test;
        point = walk[$-1];

        if (stopCondition(newTiles, point.x, point.y))
        {
            break;
        }

        switch (uniform(0,4))
        {
            case 0:
                if (point.x > rect.left)
                {
                    walk ~= Point(point.x - 1, point.y);
                }
                break;
            case 1:
                if (point.x < rect.right - 1)
                {
                    walk ~= Point(point.x + 1, point.y);
                }
                break;
            case 2:
                if (point.y > rect.top)
                {
                    walk ~= Point(point.x, point.y - 1);
                }
                break;
            case 3:
                if (point.y < rect.bottom -1)
                {
                    walk ~= Point(point.x, point.y + 1);
                }
                break;
            default:
                break;
        }
    }

    foreach (p; walk)
    {
        if(predicate(newTiles, p.x, p.y))
        {
            newTiles[p.x][p.y] = converter(newTiles[p.x][p.y]);
        }
    }

    return newTiles;
}



//int main()
//{
    //import std.stdio;

    //TileRegion level;
    //Tile[][] tiles = new Tile[][](20,20);
    //level = TileRegion([null,null], null, SplitType.vertical, Rect(0,20,0,20));

    ////generateBSPDungeonLevel(level, tiles);
    //generateCADungeonLevel(level,tiles);

    ////writeln("creating start room");
    ////Rect startRoom = Rect(0, 3, 0, 3);
    ////tiles = filterAndConvertInRect(tiles, startRoom,
            ////tile => Tile(TileType.rock, tile.bitmapIndex, tile.canPass),
            ////(tiles, x, y) => true);

    ////writeln("starting walk");
    ////tiles = filterAndConvertOnWalk(
            ////tiles,
            ////level.rect,
            ////Point(5,5),
            ////tile => Tile(TileType.rock, tile.bitmapIndex, tile.canPass),
            ////(tiles, x, y) => true,
            ////(tiles, x, y) => tiles[x][y].tileType == TileType.rock);

    ////writeln(tileArrayToString(tiles));

    ////int choice;
    ////write("Choose 0-BSP, 1-CA: ");
    ////readf(" %s", &choice);
    ////if (choice == 0)
    ////{
        ////generateBSPDungeonLevel(level);
    ////}
    ////else if (choice == 1)
    ////{
        ////generateCADungeonLevel(level);
    ////}
    //return 0;
//}
