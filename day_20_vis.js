
//let STARTING_TILE = 1049 // Center Tile at 2,2 of a 5x5 mosiac
/**
 * Expected result
 * 1381 1993 3881 1489 3943
 * 3257 2389 1709 1423 1523
 * 1093 3583 1049 2027 3793
 * 1693 3691 2699 1451 1787
 * 3607 3373 3067 2087 1997                      
 */
let STARTING_TILE = 1049;
let VOID_TILE = {
    bottom: "          ",
    content: ["          ", "          ", "          ", "          ", "          ",
        "          ", "          ", "          ", "          ", "          ",],
    found: false,
    id: 0,
    left: "          ",
    right: "          ",
    top: "          ",
    visited: false,
    x: null,
    y: null
}
let tileData = [{
    bottom: "#.#.#.#..#",
    content: ["#.####..#.", "...##...#.", "##...#..#.", ".#....##.#",
        "#..#...#..", "#.##....##", "#.####....", "#..#.....#", ".##.#...##",
        "#.#.#.#..#"],
    found: false,
    id: 3691,
    left: "#.#.####.#",
    right: "...#.#.###",
    top: "#.####..#.",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "...#.#.#..",
    content: ["..#####.##", "#.....#...", ".........#", "##.#.....#",
        "###.##....", ".##.....##", "#...#.....", "..#.#....#", "...#.....#",
        "...#.#.#.."],
    found: false,
    id: 3943,
    left: ".#.##.#...",
    right: "#.##.#.##.",
    top: "..#####.##",
    visited: false,
    x: null,
    y: null
},
{
    bottom: ".##....###",
    content: ["####..#..#", "#..#.....#", "#...##..#.", "#.....#...",
        "#..#..###.", "###.#.##..", "..##.#..#.", "##...#####", ".....#..#.",
        ".##....###"],
    found: false,
    id: 3881,
    left: "######.#..",
    right: "##.....#.#",
    top: "####..#..#",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "###.###.#.",
    content: ["#.#.####.#", "#.#.#....#", "#...###...", "..........",
        ".#..##.##.", "####....##", ".#......##", "..#.#.....", ".#.....#..",
        "###.###.#."],
    found: false,
    id: 1693,
    left: "###..#...#",
    right: "##...##...",
    top: "#.#.####.#",
    visited: false,
    x: null,
    y: null
},
{
    bottom: ".##.#.####",
    content: ["##..##.#..", "#...##....", "..#..##..#", ".....#...#",
        "....#..###", "##.......#", "#....#.##.", "....#.....", ".#....#.#.",
        ".##.#.####"],
    found: false,
    id: 3607,
    left: "##...##...",
    right: "..####...#",
    top: "##..##.#..",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "##....#...",
    content: ["##.#......", "#..##..#..", "..##..#...", "###.#....#",
        "..#.###...", "#..#......", "#.....##..", "#.##......", "#..#.#...#",
        "##....#..."],
    found: false,
    id: 2027,
    left: "##.#.#####",
    right: "...#....#.",
    top: "##.#......",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "#.#..#..##",
    content: ["..##.#...#", ".##.##....", ".....#....", "......##.#",
        ".........#", "...#.#....", "#.##.#...#", ".#..###...", "#...##....",
        "#.#..#..##"],
    found: false,
    id: 1451,
    left: "......#.##",
    right: "#..##.#..#",
    top: "..##.#...#",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "#.#...#..#",
    content: ["##....#...", "#...##....", "#...#..###", ".#.#...#.#",
        "#..#..#..#", "....#....#", ".#.#......", "...##.#.##", "#...##.#.#",
        "#.#...#..#"],
    found: false,
    id: 1423,
    left: "###.#...##",
    right: "..####.###",
    top: "##....#...",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "####.#.#..",
    content: ["#...#..###", "##.......#", "..##...#.#", "#....#...#",
        "#.#.##..##", "##..##....", ".##..#.#..", "..#.....##", "......#.#.",
        "####.#.#.."],
    found: false,
    id: 1093,
    left: "##.###...#",
    right: "#####..#..",
    top: "#...#..###",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "#..##..#.#",
    content: [".#..##....", "...###....", "..#......#", "##.....#.#",
        ".#.##...#.", "##.......#", "........#.", "##..#.#...", "#.#.#.#...",
        "#..##..#.#"],
    found: false,
    id: 2699,
    left: "...#.#.###",
    right: "..##.#...#",
    top: ".#..##....",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "#.#.#.#..#",
    content: ["...##.##.#", "..#.....##", "#.#......#", ".#..#..#.#",
        "#.#.......", "##....#...", "..##......", "...#......", "#..##..#..",
        "#.#.#.#..#"],
    found: false,
    id: 3373,
    left: "..#.##..##",
    right: "####.....#",
    top: "...##.##.#",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "#.###..#..",
    content: ["#...##..#.", ".#........", ".##..##.#.", "#.####....",
        "..#..#.###", ".####.##..", ".#.##.....", "......#..#", ".#....#.##",
        "#.###..#.."],
    found: false,
    id: 1381,
    left: "#..#.....#",
    right: "....#..##.",
    top: "#...##..#.",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "##.#..#.#.",
    content: ["#....#.#..", "##.......#", ".#.......#", "#.###....#",
        "........#.", ".........#", "..#..##.##", "#..#......", "...###....",
        "##.#..#.#."],
    found: false,
    id: 1997,
    left: "##.#...#.#",
    right: ".###.##...",
    top: "#....#.#..",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "##.#..##.#",
    content: ["##.####...", ".#...#....", ".....#...#", "#...##.##.",
        "........##", "...#.####.", "......##.#", "..###....#", ".#.......#",
        "##.#..##.#"],
    found: false,
    id: 3257,
    left: "#..#.....#",
    right: "..#.#.####",
    top: "##.####...",
    visited: false,
    x: null,
    y: null
},
{
    bottom: ".####.#.#.",
    content: ["...#....#.", ".##......#", "..#...#...", ".#...#..#.",
        "##..#..###", "##..#..#..", "..#....##.", ".....#..#.", "#.........",
        ".####.#.#."],
    found: false,
    id: 1049,
    left: "....##..#.",
    right: ".#..#.....",
    top: "...#....#.",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "#...###..#",
    content: ["#.##...#.#", "#..#..#.#.", "..#..#..##", "##.#....##",
        ".###.#....", "#....#...#", "#........#", "#....#..##", "#.......##",
        "#...###..#"],
    found: false,
    id: 3793,
    left: "##.#.#####",
    right: "#.##.#####",
    top: "#.##...#.#",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "##.#..#.#.",
    content: ["##.###.##.", ".........#", "...#.#..##", "#....#...#",
        "#.#..#.#..", "...#....#.", "#.........", "..#..#....", "...#......",
        "##.#..#.#."],
    found: false,
    id: 2087,
    left: "#..##.#..#",
    right: ".###......",
    top: "##.###.##.",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "##...#.###",
    content: ["....##.#.#", "...##.....", "#...#..#..", "#.#...##.#",
        "#........#", "#...#.##.#", "##....#...", "...##...#.", "#..#####..",
        "##...#.###"],
    found: false,
    id: 1523,
    left: "..#####.##",
    right: "#..###...#",
    top: "....##.#.#",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "#.#..##..#",
    content: ["..####.#.#", "#.#....#.#", "#....##..#", ".....##..#",
        "##..#.....", "#.#...#.#.", "#.....#...", "...####...", "#.......#.",
        "#.#..##..#"],
    found: false,
    id: 3067,
    left: ".##.###.##",
    right: "####.....#",
    top: "..####.#.#",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "..#..#####",
    content: [".#.#.####.", ".#..#..#.#", "##...##...", "......#...",
        ".#.###..##", "#....###.#", "#.##..#..#", "###..#.###", ".##..##...",
        "..#..#####"],
    found: false,
    id: 3583,
    left: "..#..###..",
    right: ".#..####.#",
    top: ".#.#.####.",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "##.##.##.#",
    content: ["..#..###..", "..#....#..", "..##....#.", "..#......#",
        "#..##...##", "...#....##", "#.....##.#", "..........", ".....###.#",
        "##.##.##.#"],
    found: false,
    id: 2389,
    left: "....#.#..#",
    right: "...####.##",
    top: "..#..###..",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "####..#..#",
    content: [".#..##...#", "#...####..", "#......###", ".#.....###",
        "..#.#.....", "...#...#.#", "#.####..##", "#.........", "#....#.###",
        "####..#..#"],
    found: false,
    id: 1993,
    left: ".##...####",
    right: "#.##.##.##",
    top: ".#..##...#",
    visited: false,
    x: null,
    y: null
},
{
    bottom: ".##.#.##.#",
    content: [".##....###", "#...#.....", "......#...", ".......###",
        "##..#..#..", "#..#....#.", "#...#.##..", "...#.....#", "##.#.#..#.",
        ".##.#.##.#"],
    found: false,
    id: 1489,
    left: ".#..###.#.",
    right: "#..#...#.#",
    top: ".##....###",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "....#.#..#",
    content: ["..####.###", "#.........", "...#.#...#", "...#..#...",
        "#..####...", "....##....", "......#.#.", ".#...#....", "..##.#..##",
        "....#.#..#"],
    found: false,
    id: 1709,
    left: ".#..#.....",
    right: "#.#.....##",
    top: "..####.###",
    visited: false,
    x: null,
    y: null
},
{
    bottom: "##.#...#.#",
    content: ["#.#...##.#", "..........", "...#.....#", "#...#.....",
        "...#......", "###.....##", "#.....##..", "..##......", "##.......#",
        "##.#...#.#"],
    found: false,
    id: 1787,
    left: "#..#.##.##",
    right: "#.#..#..##",
    top: "#.#...##.#",
    visited: false,
    x: null,
    y: null
}]

let SEA = {
    id: "sea",
    content: ["#.#....#.#.....##...##.........##....#.#",
        "....#.......#.#..#.#.##.....###......#..",
        "##.#....#......#.#.......##.....#.##....",
        ".......##....###...##...####.#..####.##.",
        "##..#...##.##..#..####..#........#..#.##",
        "...#...................###.##....####...",
        "..##..#...###....#...#.....#....##..##.#",
        "...##.......#.#....#..##...#...##.......",
        "..#.#...#....##...##..##.#.##....####...",
        "##.#.#..#.##....##.#..###....#.###......",
        ".....###.####..#..#..##......#.###.....#",
        "..#....##.#....#.###...........#....#.#.",
        "..........#...#.#..###.#...#.....#...#..",
        "....#........#....#......#.##...#..####.",
        "..#....#....##....##...####.............",
        "#.......#..#..##.#..#..#........##.#....",
        "....#..#.#.###...........##.#..#.....#..",
        "#.......#.....#.....#..##...#...#..##...",
        ".##.###.....#..#.#....##.....#.#..#.....",
        ".##...#.##..#..##..#..#....##...###..#..",
        "...#..#........##..#..##..####...##.#.##",
        "......#.##......#...#..#..#..#..#..#.##.",
        "#...#........#...#...#....#.#...####...#",
        "...#......#.#...##..............#..#....",
        "...........##.##.........#....#.....#...",
        "#..#.#.....#....#....#...##....#..#.....",
        "...#.....##......#.#.#.....#..#.##......",
        ".#.#..#............#...##......#.#..#..#",
        "#....#.....#.#..#.##....##..#.###....#..",
        "...........#.##.##..#.##..##.##..##.#...",
        "...#..#...###..#.###..#..............#..",
        ".....#.....##.....#.......#..#..#..#.#.#",
        "...###.....#......##.....#####......#...",
        ".....#....#......#.#....#...##..........",
        "#.##..#...#.....#.##......#....##.......",
        ".........................##.#......#....",
        "#............#...#.##.#............#.##.",
        "....###..#..#.#.#........##...#...#....#",
        ".......#.#.#.............#..#......##.#.",
        ".......##..#....###...##....##....###..."]
};

/*****************************************************************************
 * RENDERING
 ****************************************************************************/
function printTile(tile, borders) {
    let innerHtml = "";
    let idx = 0;
    tile.content.forEach(function (row) {
        let start = row.slice(0, 1);
        let middle = row.slice(1, -1);
        let end = row.slice(-1);

        let middleHtml = ""
        if (0 === idx || idx === tile.content.length - 1) {
            [...middle].forEach(char => middleHtml += charToDiv(char, true && borders))
        } else {
            [...middle].forEach(char => middleHtml += charToDiv(char), false && borders)
        }
        innerHtml += charToDiv(start, true && borders) + middleHtml + charToDiv(end, true && borders) + "<br>"
        idx++;
    });
    let style = "";
    if (!tile.found) { style = 'style="opacity: .3"' }
    let str = '<div ' + style + ' title="' + tile.id + '" class="tile">' + innerHtml + "</div>";
    return str;
}

function charToDiv(char, edge) {
    let div = ""
    if ("#" === char) {
        if (edge) {
            div = '<div class="square black-box"></div>'
        } else {
            div = '<div class="square wave"></div>'
        }
    } else if ("." === char) {
        if (edge) {
            div = '<div class="square white-box"></div>'
        } else {
            div = '<div class="square water"></div>'
        }
    } else {
        div = '<div class="square void"></div>'
    }
    return div;
}

function printTileMap(tiles) {
    innerHtml = ""
    for (y = 0; y <= 4; y++) {
        for (x = 0; x <= 4; x++) {
            t = tiles.find(t => t.x === x && t.y === y)
            innerHtml += printTile(t, true)
        }
        innerHtml += '<br>'
    }
    return innerHtml;
}

function replaceInBoard(board, tile) {
    board = board.filter(t => t.x !== tile.x || t.y !== tile.y)
    board.push(tile)
    // Reindex
    //board = board.filter(val => val)
    return board;
}

function buildBlankBoard(cursorTile) {
    let board = [];
    for (y = 0; y <= 4; y++) {
        for (x = 0; x <= 4; x++) {
            let vt = JSON.parse(JSON.stringify(VOID_TILE));
            vt.x = x;
            vt.y = y;
            board.push(vt)
        }
    }
    cursorTile.x = 2;
    cursorTile.y = 2;
    cursorTile.found = true;
    board = replaceInBoard(board, cursorTile);
    return board;
}
/*****************************************************************************
 * TILE BEHAVIORS
 ****************************************************************************/
const recalculateSides = (tile) => {
    leftStr = tile.content.map(row => row.split("")[0]).join("");
    rightStr = tile.content.map(row => row.split("")[row.length - 1]).join("");

    tile.top = tile.content[0];
    tile.bottom = tile.content[tile.content.length - 1];
    tile.right = rightStr;
    tile.left = leftStr;
    return tile
}

const nop = (tile) => {
    return recalculateSides(tile);
}

const flipTile = (tile) => {
    tile.content = tile.content.reverse();
    return recalculateSides(tile);
}

const rotate90 = (tile) => {
    // Split each content row into a list of lists
    let contentMatrix = []
    tile.content.forEach((row) => {
        let row_list = [];
        row.split("").forEach((char) => {
            row_list.push(char);
        });
        contentMatrix.push(row_list);
    });
    // Rotate - https://stackoverflow.com/a/58668351 - Elegant.
    contentMatrix = contentMatrix[0].map((val, index) => contentMatrix.map(row => row[index]).reverse())
    // Rejoin the rows
    contentMatrix = contentMatrix.map(row => row.join(""));
    tile.content = contentMatrix;
    return recalculateSides(tile);
}

function op(cursorTile, tile, tileFunc, sideToCheck) {
    if (tile.visited) { return false; } // Seen it! Bail out.

    tileFunc(tile)
    // Check stuff!
    if ("bottom" === sideToCheck) {
        if (cursorTile.bottom === tile.top) { return true; }
    } else if ("top" === sideToCheck) {
        if (cursorTile.top === tile.bottom) { return true; }
    } else if ("right" === sideToCheck) {
        if (cursorTile.right === tile.left) { return true; }
    } else if ("left" === sideToCheck) {
        if (cursorTile.left === tile.right) { return true; }
    }
    return false;
}

const sleep = ms => {
    return new Promise(resolve => setTimeout(resolve, ms))
}

const runOper = async (board, cursorTile, tile, operation, check) => {
    return sleep(20).then(() => {
        let result = op(cursorTile, tile, operation, check)
        board = replaceInBoard(board, tile)
        document.getElementById("container").innerHTML = printTileMap(board)
        return result;
    });
}

const tileFoundAt = (tiles, x, y) => {
    query = tiles.find(t => t.x === x && t.y === y && t.id !== 0);
    return query !== undefined;
}

const findTile = async (board, cursorTile, tiles, operations) => {
    // Check every tile
    for (let t = 0; t < tiles.length; t++) {
        tile = tiles[t];
        // Skip tiles already found
        if (tile.found) { continue; }
        // At every possible spot
        spot_block: {
            for (let o = 0; o < offsets.length; o++) {
                // For every possible orientation
                dx = cursorTile.x + offsets[o].x;
                dy = cursorTile.y + offsets[o].y;
                // Skip positions we've already found
                if (tileFoundAt(board, dx, dy)) { continue; }
                // Skip out of bounds
                if (dx > 4 || dx < 0) { continue; }
                if (dy > 4 || dy < 0) { continue; }
                tile.x = dx;
                tile.y = dy;

                for (let i = 0; i < operations.length; i++) {
                    result = await runOper(board, cursorTile, tile, operations[i], offsets[o].check);
                    if (result) {
                        totalFound++;
                        tile.found = true;
                        board = replaceInBoard(board, tile)
                        break spot_block;
                    }
                }
            }
        }
        // Reset the tile x/y coordinates if it wasn't found
        if (!tile.found) {
            tile.x = null;
            tile.y = null;
        }
    }
    cursorTile.visited = true;
    board = replaceInBoard(board, cursorTile);
    return board;
}
/*****************************************************************************
 * MAIN FUNCTION BLOCK
 ****************************************************************************/
let startTile = tileData.find(t => t.id === STARTING_TILE);
rotate90(rotate90(rotate90(startTile)));
let board = buildBlankBoard(startTile);
document.getElementById("container").innerHTML = printTileMap(board);

// Spin through all positions, flip it and do it all again. Running through
// the entire set of operations will leave the tile as it started.
let operations = [nop,
    rotate90, rotate90, rotate90, rotate90, flipTile,
    rotate90, rotate90, rotate90, rotate90, flipTile
];

// Cursor search positions
offsets = [
    { x: -1, y: 0, check: "left" },
    { x: 0, y: -1, check: "top" },
    { x: 1, y: 0, check: "right" },
    { x: 0, y: 1, check: "bottom" },
]

let totalFound = 1; // Initial Block

const findAll = async () => {
    cursorTile = tileData.find(t => t.found && (!t.visited));
    board = await findTile(board, cursorTile, tileData, operations);
    if (25 === totalFound) {
        cursorTile.found = true;
        cursorTile.visited = true;
        board = replaceInBoard(board, cursorTile);
        document.getElementById("container").innerHTML = printTileMap(board);
    } else {
        findAll();
    }
};

findAll();