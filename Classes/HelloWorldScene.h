
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
    CCSprite *_enemy3Unit;
    CCAction *_walkAction1;
    
    /*
    CCSprite *_jzeUnit;
    CCAction *_jzewalkAction;
    CCAction *_jzemoveAction;
    */
    
    BOOL _moving;
    CCSprite * selSprite;
    NSMutableArray *_players;
    NSMutableArray *_enemys;
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;  
    int _currentLevel;
}

// Add after the HelloWorld interface
@property (nonatomic, retain) CCSprite *playerUnit;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *moveAction;
@property (nonatomic, retain) CCSprite *e3Unit;
@property (nonatomic, retain) CCAction *walkAction1;

/*
@property (nonatomic, retain) CCSprite *jzeUnit;
@property (nonatomic, retain) CCAction *jzewalkAction;
@property (nonatomic, retain) CCAction *jzemoveAction;
*/

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, assign) int currentLevel;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

@end
