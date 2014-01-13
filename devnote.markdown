整个项目完成到了，加载一个主角精灵，然后不断出现的敌军涌向玩家进行攻击。
项目问题，没有控制好内存的优化。

整体程序分析，包括objective-c语法的诠释。


首先是main.m
```cpp
#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        int retVal = UIApplicationMain(argc, argv, nil, @"myDemoAppDelegate");
        [pool release];
        return retVal;
}
```
这个没什么好说的，就是Cocoa的一个自动释放池的概念。myDemoAppDelegate直接关联到一个叫做myDemoAppDeligate的委托类

---------------------------------------
该类的头文件中
```cpp
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

    CCSpriteBatchNode *_spriteSheetEx;
    NSMutableArray *_walkAnimFrames;
    CCAnimation *_walkAnim;
    CCAnimation *_attackAnim;
    NSMutableArray *_attackAnimFrames;
    CCAction *_spriteWalkAction;
    CCAction *_spriteAttackAction;
    
    
    BOOL _moving;
    CCSprite * selSprite;
    NSMutableArray *_players;
    NSMutableArray *_enemys;
    NSMutableArray *_enemysActs;
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


@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, assign) int currentLevel;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

@end
```
申明了需要用到的ui组件，如CCLabelTTF的指针。
然后是接口语法interface，这个在objective中是定义一个接口，其实就是C++的class，但是这个通常放在头文件里，因为接下来还有implementation来真正起作用，也就是C++里的去实现。
可以看到在类里有若干个CCSprite和CCAction已经CCSpriteBatchNode和MSMutableArrray，分别用来作为精灵类指针、动作类指针、批处理Node类指针和数组。注意在cocos2d-x的2.x版本中已经改名CCMutableArray为CCArray了。一个布尔值_moving作为判断是否在运动的标记。然后有一个CCTMXTiledmap来使用tiled地图编辑器编辑出来的地图。已经CCMXLayer来画背景。_currentLevel这个暂时没有作用。 
接下马上是接口之后必须跟上的objective-c必须有的retain语法，记住这是自动管理内存的机制,就是要求对象的保留计数器数值+1。
nonatomic是表示是互斥。property则是说明支持getter和setter的访问属性。

---------------------------------------
接着是myDemoAppDelegate.m
```cpp
//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "DataModel.h"
#import "EnemyClass.h"

// HelloWorld implementation
@implementation HelloWorld

// At the top, under @implementation
@synthesize playerUnit = _playerUnit;
@synthesize e3Unit = _enemy3Unit;
@synthesize moveAction = _moveAction;
@synthesize walkAction = _walkAction;
@synthesize walkAction1 = _walkAction1;

@synthesize tileMap    = _tileMap; 
@synthesize background = _background;
@synthesize currentLevel = _currentLevel;

+(id) scene
{
        // 'scene' is an autorelease object.
        CCScene *scene = [CCScene node];
        
        // 'layer' is an autorelease object.
        HelloWorld *layer = [HelloWorld node];
        
        // add layer as a child to scene
        //[scene addChild: layer];
    [scene addChild: layer z:1];

    //DataModel *dm = [DataModel getModel];
    //dm._gameLayer = layer;
        
        // return the scene
        return scene;
}


// on "init" you need to initialize your instance
-(id) init
{
        // always call "super" init
        // Apple recommends to re-assign "self" with the "super" return value
    if( (self=[super initWithColor:ccc4(0,0,0,255)] )) {
        /*{{{map background绿色背景*/
        CCSprite *realBackground = [CCSprite spriteWithFile:@"map_b0.png"];
        realBackground.position = ccp(100, 240);
        [self addChild:realBackground z:0]; 
        /*}}}*/
        /*{{{startgate敌军出现的地方*/
        CCSprite *startGate = [CCSprite spriteWithFile:@"ec045.png"];
        startGate.position = ccp(60, 200);
        startGate.scale = 0.6;
        [self addChild:startGate z:4]; 
        /*}}}*/
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        _players = [[NSMutableArray alloc] init];
        _enemys = [[NSMutableArray alloc] init];
        _enemysActs = [[NSMutableArray alloc] init];
        }
    [self schedule:@selector(gameLogic:) interval:3.0];
    
    /* {{{head test text
     */
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    // Create a label for display purposes
    _label = [[CCLabelTTF labelWithString:@"建造的项目" 
                               dimensions:CGSizeMake(420, 50) alignment:UITextAlignmentCenter 
                                 fontName:@"Arial" fontSize:28.0] retain];
    _label.position = ccp(winSize.width/2, 
                          winSize.height-(_label.contentSize.height/2));
    [self addChild:_label];
    /* }}} */
    /* {{{ money label
     */
    _moneyLabel = [[CCLabelTTF labelWithString:@"金钱数:0"
                                dimensions:CGSizeMake(420, 50) alignment:UITextAlignmentCenter 
                                fontName:@"Arial" fontSize:20.0] retain];
    _moneyLabel.position = ccp(40, 
                          winSize.height-(_label.contentSize.height/2));
    [self addChild:_moneyLabel];

    /* }}} */
    /* {{{Standard method to create a button
     */
    CCMenuItem *starMenuItem = [CCMenuItemImage 
                                itemFromNormalImage:@"ButtonPlus.png" selectedImage:@"ButtonPlusSel.png" 
                                target:self selector:@selector(starButtonTapped:)];
   
    CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem, nil];
    starMenu.position = CGPointZero;
    starMenu.scale = 0.6;
    starMenuItem.position = ccp(60, -80);
    [self addChild:starMenu z:5];
    CCMenuItem *soldierMenuItem = [CCMenuItemImage 
                                itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png" 
                                target:self selector:@selector(soldierButtonTapped:)];
    soldierMenuItem.position = ccp(130, -80);
    CCMenu *soldierMenu = [CCMenu menuWithItems:soldierMenuItem, nil];
    soldierMenu.position = CGPointZero;
    soldierMenu.scale = 0.6;
    [self addChild:soldierMenu z:5];
    /* }}} */
    /* {{{ add sprite animation for player
     */
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
     @"AnimPlayerUnit01.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"AnimPlayerUnit01.png"];
    [self addChild:spriteSheet z:3];
    // Load up the frames of our animation
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(int i = 0; i <= 1; ++i) {
        [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"playerUnit01_0%d.png", i]]];
    }
    CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f];
    self.playerUnit = [CCSprite spriteWithSpriteFrameName:@"playerUnit01_00.png"];
    _playerUnit.position = ccp(winSize.width/2, winSize.height/2);
    _playerUnit.scale = 0.6;
    self.walkAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
    [_playerUnit runAction:_walkAction];
    [spriteSheet addChild:_playerUnit];
    [_players addObject:_playerUnit];
    /* }}} */
    [self schedule:@selector(update:)]; //每一桢检查是否接近碰撞，如果差不多则进行进行attack
        return self;
}

- (void)starButtonTapped:(id)sender {
    [_label setString:@"生产士兵"];
    for (CCSprite *target in _players) {
        [target setPosition:ccp(target.position.x-12, target.position.y)];
    }
}
- (void)soldierButtonTapped:(id)sender {
    [_label setString:@"生产PHP架构师"];
    for (CCSprite *target in _players) {
        [target setPosition:ccp(target.position.x+12, target.position.y)];
    }
}

-(void) CallBack3:(id)sender data:(void*)data {
    CCSprite *sp = (CCSprite *)sender;
    NSLog(@"[in CallBack][x:%d]",sp.position.x);
    [sender stopAllActions];
    [sender runAction:[CCTintBy actionWithDuration:(NSInteger)data red:255 green:0 blue:255]];
}

-(void)addEnemy {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
     @"enemyx3.plist"];
    _spriteSheetEx = [CCSpriteBatchNode batchNodeWithFile:@"enemyx_1.png"];
    [self addChild:_spriteSheetEx z:6];
    _walkAnimFrames = [NSMutableArray array];
    _attackAnimFrames = [NSMutableArray array];
    for(int j = 0; j <= 2; ++j) {
        [_walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"enemyx_0%d.png", j]]];
    }
    for(int j = 3; j<=7; ++j) {
        [_attackAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"enemyx_0%d.png", j]]];
    }
    _walkAnim = [CCAnimation animationWithFrames:_walkAnimFrames delay:0.3f];
    _attackAnim = [CCAnimation animationWithFrames:_attackAnimFrames delay:0.3f];

    CCSprite * spriteUnit = [CCSprite spriteWithSpriteFrameName:@"enemyx_00.png"];
    _spriteWalkAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:_walkAnim restoreOriginalFrame:NO]];
    _spriteAttackAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:_attackAnim restoreOriginalFrame:NO]];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    spriteUnit.position = ccp(winSize.width, winSize.height/2);
    [spriteUnit runAction:_spriteWalkAction];
    CGSize s = [[CCDirector sharedDirector] winSize]; 
    //CGPoint p = ccp(s.width/2, 170);
    CGPoint p = ccp(s.width/2, 170);
#if 0 
    // 创建5个动作
    id ac0 = [spriteUnit runAction:[CCPlace actionWithPosition:p]];
    id ac1 = [CCMoveTo actionWithDuration:2 position:ccp(s.width - 50, s.height - 50)];
    id ac2 = [CCJumpTo actionWithDuration:2 position:ccp(150, 50) height:30 jumps:5];
    id ac3 = [CCBlink actionWithDuration:2 blinks:3];
    id ac4 = [CCScaleTo actionWithDuration:1 scale:4];
    //id ac5 = [CCTintBy actionWithDuration:0.5 red:0 green:255 blue:255];
    //id acf = [CCCallFunc actionWithTarget:self selector:@selector(CallBack1:spriteUnit)];
    id acf = [CCCallFuncND actionWithTarget:self selector:@selector(CallBack3:data:) data:(void*)2]; 
    [spriteUnit runAction:[CCSequence actions:ac0, ac1, ac2, ac3, ac4, ac0, acf, nil]];
#endif
    //id ac0 = [spriteUnit runAction:[CCPlace actionWithPosition:p]];
    //id ac1 = [CCMoveTo actionWithDuration:2 position:ccp(100, s.height - 50)];
    //[spriteUnit runAction:[CCSequence actions:ac0, ac1, nil]];
    //int actualY=spriteUnit.contentSize.height/2+100;
    int actualY=winSize.height/2;
    int minDuration =4.0;
    int maxDuration =8.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    actualDuration=actualDuration*4;
    id actionMove = [CCMoveTo actionWithDuration:actualDuration 
                                        position:ccp(-spriteUnit.contentSize.width/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                              selector:@selector(spriteMoveFinished:)];
    [spriteUnit runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    [self addChild:spriteUnit z:6];
    [_enemys addObject:spriteUnit];
    NSString *actId = [[NSString alloc] init];
    actId = @"walk";
    NSLog(@"actId:%@",actId);
    [_enemysActs addObject:actId];
    CCLOG(@"enemy added");
}

-(void)addTarget {
    
    CCSprite *target = [CCSprite spriteWithFile:@"enemyUnit_9_00.png" 
                                           rect:CGRectMake(0, 0, 115, 100)]; 
    target.scale = 0.9; //target就是敌人
    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    // 一直在地面
    int actualY=target.contentSize.height/2+100;
    
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
    [self addChild:target z:3];
    
    // Determine speed of the target
    int minDuration =2.0;
    int maxDuration =4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    // 速度稍微慢点，塔防！
    actualDuration=actualDuration*4;
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration 
                                        position:ccp(-target.contentSize.width/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self 
                                             selector:@selector(spriteMoveFinished:)];
    [target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    
}

// 运行完删除
-(void)spriteMoveFinished:(id)sender {
    CCSprite *sprite = (CCSprite *)sender;
    [self removeChild:sprite cleanup:YES];
}

-(void)gameLogic:(ccTime)dt {
    [self addEnemy];
    //[self addTarget];
}

- (void) update:(ccTime)dt {
    NSMutableArray *emToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *pl in _players) {
            CCLOG(@"p position x:%f", pl.position.x);
        //for (CCSprite *en in _enemys) {
        for (int i=0;i<[_enemys count];i++) {
            CCSprite *en=[_enemys objectAtIndex:i];
            NSString *current_action_id = [_enemysActs objectAtIndex:i];
            CCLOG(@"e position x:%f", en.position.x);
            CCLOG(@"current_action_id:%s", current_action_id);
            if (en.position.x-pl.position.x<=40 && en.position.x-pl.position.x>=20) { //cannot exceed player 
                en.position=ccp(pl.position.x+40,en.position.y);
                if (current_action_id==@"walk") {
                    _attackAnimFrames = [NSMutableArray array];
                    for(int j = 3; j<=7; ++j) {
                        [_attackAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"enemyx_0%d.png", j]]];
                    }
                    _attackAnim = [CCAnimation animationWithFrames:_attackAnimFrames delay:0.3f];
                    _spriteAttackAction = [CCRepeatForever actionWithAction:
                    [CCAnimate actionWithAnimation:_attackAnim restoreOriginalFrame:NO]];
                    [en runAction:_spriteAttackAction];
                    NSString *attack_act_string = @"attack"; //change current action states to attack 
                    [_enemysActs replaceObjectAtIndex:i withObject:attack_act_string];
                }
            } else if (en.position.x<=pl.position.x) { //adjust range
                en.position=ccp(pl.position.x+40,en.position.y);
            }
        }
    }
} 


- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in _players) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
            newSprite = sprite;
            break;
        }
    }
    if (newSprite != selSprite) {
        [selSprite stopAllActions];
        [selSprite runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        CCRotateTo * rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
        CCRotateTo * rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
        CCRotateTo * rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
        CCSequence * rotSeq = [CCSequence actions:rotLeft, rotCenter, rotRight, rotCenter, nil];
        [newSprite runAction:[CCRepeatForever actionWithAction:rotSeq]];
        selSprite = newSprite;
    }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation]; 
    return TRUE; 
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [_label release];
    _label = nil;
    [_moneyLabel release];
    _moneyLabel = nil;
    [_players release];
    _players = nil;
    [_enemys release];
    _enemys = nil;
    // In dealloc
    self.playerUnit = nil;
    self.walkAction = nil;
        // in case you have something to dealloc, do it in this method
        // in this particular example nothing needs to be released.
        // cocos2d will automatically release all the children (Label)
        
        // don't forget to call "super dealloc"
        [super dealloc];
}
@end
```
首先是几个头文件的引入，然后是implementation实现HelloWorld
针对刚刚定义的几个类,synthesize这个关键字叫做合成,我们称类对实例变量合成访问器属性。2个合成的元素都在头文件里定义，只是合成在源文件里,实际和游戏程序打交道的是实例变量。

然后+(id) scene这个id为一种泛型指针。
接着定义CCScene类指针scene,因为helloworld继承自CCColorLayer，接着直接定义这个CCColorLayer指针layer
再马上在把layer加到scene上去，这样就形成了一个有色图层。

init方法中，直接把背景图加载到了CCSprite中去，并调整坐标。
CCSprite制造玩家出现的地方的图片。
然后初始化那些数组_player和_enemys和_enemyActs。
把CCLabelTTF生成的文字用self addChild方法加载到图层上。
对于money文字也是一样的操作。
接着采用CCMenuItemImage函数制作一个button，同样用self addChild方法加到layer上。而回调函数是通过该函数的最后一个参数
selector:@selector(回调函数:)实现的。
然后要加载一系列动作序列了，用CCSpriteBatchNode来加载，得到一个spriteSheet,由于CCSpriteBatchNode继承子CCNode，所以也可以用过self addChild加到layer上。
对定义好的帧数目，循环加载到一个帧数组中，之后用CCAnimation的animationWithFrames方法加载到CCAnimation的指针walkAnim中。
之后对walkAction动作，才起CCRepeatForever类的actionWithAction方法加载walkAnim
接下来就可以指导玩家精灵用CCSprite的runAction方法加载动作了。把精灵加到SpriteSheet中。同时把这个精灵加到精灵数组中去。
再来是starButtonTapped等几个按钮的回调函数。

然后定义一个定时出现enemy的函数addEnemy,主要就是初始化shriteSheet，加载，然后加载CCSpriteFrameCache的帧，以及他们的动作。

攻击判断,放在update函数里去实现，主要就是去遍历精灵数组了，如果谁的射程中有玩家，则进行攻击。

最后这个update函数放在schedule中

除了以上说的以外,还可以touch主角，这个暂时不提了。比较少的情况才会遇到。



