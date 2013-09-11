//
// enemy class 
//
@interface EnemyClass : NSObject {
    CCSprite *_spriteUnit;
    CCAction *_spriteWalkAction;
}
@property (nonatomic, retain) CCSprite *spriteUnit;
@property (nonatomic, retain) CCAction *spriteWalkAction;


-(void)initWithSynthesize (CCSprite *)_spu (CCAction *)_spwa
{
    @synthesize spriteUnit = _spu; 
    @synthesize spriteUnit = _spwa; 
}
@end
