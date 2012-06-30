
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
CCLabelTTF *_label;
CCLabelTTF *_moneyLabel;
// HelloWorld Layer
@interface HelloWorld : CCColorLayer
{
    // Add inside the HelloWorld interface
    CCSprite *_playerUnit;
    CCAction *_walkAction;
    CCAction *_moveAction;
    BOOL _moving;
    NSMutableArray *_players;
}

// Add after the HelloWorld interface
@property (nonatomic, retain) CCSprite *playerUnit;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *moveAction;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

@end
