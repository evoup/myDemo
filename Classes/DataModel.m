//  
//  DataModel.m
//  Cocos2D Build a Tower Defense Game
//

#import "DataModel.h"

@implementation DataModel

@synthesize _gameLayer;
@synthesize _targets;
@synthesize _waypoints;
@synthesize _waves;
@synthesize _gestureRecognizer;
static DataModel * _globalContent = nil;

+(DataModel*)getModel {
    if (!_globalContent) {
        _globalContent = [[self alloc] init];
    }
    return _globalContent;
}

-(void)encodeWithCoder:(NSCoder *)coder {

}

-(id)initWithCoder:(NSCoder *)coder {

    return self;
}

- (id) init
{
    if ((self = [super init])) {
        _targets = [[NSMutableArray alloc] init];

        _waypoints = [[NSMutableArray alloc] init];

        _waves = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    self._gameLayer = nil;
    self._gestureRecognizer = nil;

    [_targets release];
    _targets = nil;

    [_waypoints release];
    _waypoints = nil;

    [_waves release];
    _waves = nil;
    [super dealloc];
}
@end
