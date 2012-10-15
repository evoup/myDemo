//  
//  DataModel.m
//  Cocos2D Build a Tower Defense Game
//

#import "DataModel.h"

@implementation DataModel

@synthesize _gameLayer;
@synthesize _target;
@synthesize _waypoints;
@synchronized _waves;
static DataModel * _globalContent = nil;

+(DataModel*)getModel {
    if (!_globalContent) {
        _globalContent = [[self alloc] init];
    }
    return _globalContent;
}
