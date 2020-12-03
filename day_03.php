<?php
/**
 * An Enterprise-grade implementation of Day 3's Advent of Code Challenge
 */
class MapInputDatatype {
    private array $data;
    private int $mapWidth;

    function __construct(string $inputData) {
        $this->data = explode("\n", $inputData);
        $this->mapWidth = strlen(strtok($inputData, "\n"));
    }
    public function getData() : array {
        return $this->data;
    }
    public function getMapWidth() : int {
        return $this->mapWidth;
    }
}

class MapResultDatatype {
    function __construct(int $treeCount) {
        $this->treeCount = $treeCount;
    }
    public function getTreeCount() : int {
        return $treeCount;
    }
}

class MapInputDataStorageAdapterFactory {
    public static function getMapInputDataStorageAdapterFromString(string $adapter) : MapInputDataStorageAdapter {
        if( "$adapter" === "LocalFileSystem" ) {
            return new LocalFileSystemMapInputDataStorageAdapter;
        }
        throw new Exception("Requested MapInputDataStorageAdapter was not found.");
    }
}

interface MapInputDataStorageAdapter {
    public static function populateMapInputDataFromUri(string $uri) : MapInputDatatype;
}

class LocalFileSystemMapInputDataStorageAdapter implements MapInputDataStorageAdapter {
    public static function populateMapInputDataFromUri(string $uri) : MapInputDatatype {
        $mapInputDatatype = new MapInputDatatype(file_get_contents($uri));
        return $mapInputDatatype;
    }
}

class Terrain {
    private MapInputDatatype $mapInputData;
    private PathFinderImpl $pathFinder;
    
    function __construct(MapInputDatatype $mapInputDatatype, PathFinderImpl $pathFinder) {
        $this->pathFinder = $pathFinder;
        $this->mapInputData = $mapInputDatatype;
    }

    public function findTreesHitFromTerrainNavigation() : int {
        return $this->pathFinder->navigatePathAndReturnTreeImpactCount($this->mapInputData);
    }
}

interface PathFinderImpl {
    public function __construct(int $rightwardMovementPerIteration = 3, int $downwardMovementPerIteration = 1);
    public function navigatePathAndReturnTreeImpactCount(MapInputDatatype $map) : int;
}

class GenericPathFinder implements PathFinderImpl {

    private int $downwardMovementPerIteration; 
    private int $rightwardMovementPerIteration;
    private int $cursor;

    public function __construct(int $rightwardMovementPerIteration = 3, int $downwardMovementPerIteration = 1) {
        $this->downwardMovementPerIteration = $downwardMovementPerIteration;
        $this->rightwardMovementPerIteration = $rightwardMovementPerIteration;
        $this->cursor = 0;
    }

    public function navigatePathAndReturnTreeImpactCount(MapInputDatatype $map) : int {
        $hitTreeCount = 0;
        $rowCursor = 0;
        foreach($map->getData() as $line) {
            if (0 == $rowCursor % $this->downwardMovementPerIteration) {                
                if($this->isTreeImpact(substr($line, $this->cursor, 1))) {
                    $hitTreeCount++;
                }
                $this->cursor += $this->rightwardMovementPerIteration;
                if ($this->cursor >= $map->getMapWidth()) {
                    $this->cursor = $this->cursor - $map->getMapWidth();
                }
            }
            $rowCursor++;
        }
        return $hitTreeCount;
    }

    private function isTreeImpact(string $locationIcon) {
        return "#" === $locationIcon;
    }
}

class PathFinderFactory {
    public static final function getPathFinderImplementationFromString(string $adapter) : PathFinderImpl {
        switch ("$adapter") {
            case "Problem1":
                return new GenericPathFinder(3, 1);
                break;
            case "Problem2Part1":
                return new GenericPathFinder(1, 1);
                break;
            case "Problem2Part2":
                return new GenericPathFinder(3, 1);
                break;
            case "Problem2Part3":
                return new GenericPathFinder(5, 1);
                break;
            case "Problem2Part4":
                return new GenericPathFinder(7, 1);
                break;
            case "Problem2Part5":
                return new GenericPathFinder(1, 2);
                break;
            default:
                throw new Exception("Requested PathFinderImpl was not found.");
        }
    }
}

/** Main **/
$mapInputDataStorageAdapter = MapInputDataStorageAdapterFactory::getMapInputDataStorageAdapterFromString("LocalFileSystem");
$mapData = $mapInputDataStorageAdapter::populateMapInputDataFromUri("files/day_3_input.txt");

# Part 1
$pathFinder = PathFinderFactory::getPathFinderImplementationFromString("Problem1");
$terrain = new Terrain($mapData, $pathFinder);
print("Part 1: " . $terrain->findTreesHitFromTerrainNavigation() . "\n");

# Part 2
$product = 1;
$strategems = ["Problem2Part1", "Problem2Part2", "Problem2Part3","Problem2Part4", "Problem2Part5"];


foreach($strategems as $strategy) {
    $pathFinder = PathFinderFactory::getPathFinderImplementationFromString($strategy);
    $terrain = new Terrain($mapData, $pathFinder);
    $product *= $terrain->findTreesHitFromTerrainNavigation();
}
print("Part 2: " . $product  . "\n");