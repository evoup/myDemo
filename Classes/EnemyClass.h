//
// enemy class 
//
#import "cocos2d.h"
@interface EnemyClass : NSObject {
    CCSprite *_spriteUnit;
    CCAction *_spriteWalkAction;
}
@property (nonatomic, retain) CCSprite *spriteUnit;
@property (nonatomic, retain) CCAction *spriteWalkAction;


-(void)initWithSynthesize;
/*-(CCAction *) －spriteＷalkAction;
*/
 @end
