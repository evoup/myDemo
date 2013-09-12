#import "EnemyClass.h"

@implementation EnemyClass

-(void)initWithSynthesize
{
    //@synthesize spriteUnit = _spu;
    //@synthesize spriteUnit = _spwa;
}


-(CCAction *) spriteWalkAction {
    return _spriteWalkAction;
}

-(void) setSpriteWalkAction:(CCAction *)spriteWalkAction{
    if (_spriteWalkAction != spriteWalkAction) {
        [_spriteWalkAction release];
        _spriteWalkAction = [spriteWalkAction copy];
    }
}

-(CCSprite *) spriteUnit{
    return _spriteUnit;
}

-(void) setSpriteUnit:(CCSprite *)spriteUnit{
    if (_spriteUnit != spriteUnit) {
        [_spriteUnit release];
        _spriteUnit = [spriteUnit copy];
    }
}

-(void) addSpriteFrames:(NSString *)plistName pic:(NSString *)picName classId:(id)cid zIndex:(int)zid{
    CCLOG(@"[EnemyClass::addSpriteFrames][plistName: %@][picName: %@]", plistName, picName);
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
     @"AnimPlayerUnit01.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"AnimPlayerUnit01.png"];
    [cid addChild:spriteSheet z:zid];
}

@end
