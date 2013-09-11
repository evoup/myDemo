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

@end
