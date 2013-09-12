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
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(int j = 0; j <= 1; ++j) {
        [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"playerUnit01_0%d.png", j]]];
    }
    CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f];

    //self.spriteUnit = [CCSprite spriteWithSpriteFrameName:@"playerUnit01_00.png"];
    //self.spriteWalkAction = [CCRepeatForever actionWithAction:
                       //[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
    //CGSize winSize = [[CCDirector sharedDirector] winSize];
    //_spriteUnit.position = ccp(winSize.width/2+20, winSize.height/2);
    //[_spriteUnit runAction:_spriteWalkAction];
    //[_spriteUnit addChild:_spriteUnit];
}

@end
