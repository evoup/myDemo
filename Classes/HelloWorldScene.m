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
    //if( (self=[super init] )) {
    if( (self=[super initWithColor:ccc4(0,0,0,255)] )) {
		// create and initialize a Label
		//CCLabel* label = [CCLabel labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director the the window size
		//CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		//label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		//[self addChild: label];
        /* {{{ */
        //self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMap.tmx"];
        //self.background = [_tileMap layerNamed:@"Background"];
        //self.background.anchorPoint = ccp(0, 0);
        //[self addChild:_tileMap z:2];
        //_tileMap.scale = 0.7;
        /* }}} */
        //CGSize winSize = [[CCDirector sharedDirector] winSize];
        /*{{{map background绿色背景*/
        CCSprite *realBackground = [CCSprite spriteWithFile:@"map_b0.png"];
        realBackground.position = ccp(100, 240);
        //realBackground.scale = 1;
        [self addChild:realBackground z:0]; 
        /*}}}*/
        /*{{{startgate敌军出现的地方*/
        //CCSprite *startGate = [CCSprite spriteWithFile:@"object_starte.png"];
        //startGate.position = ccp(26, 94);
        CCSprite *startGate = [CCSprite spriteWithFile:@"ec045.png"];
        startGate.position = ccp(60, 200);
        startGate.scale = 0.6;
        [self addChild:startGate z:4]; 
        /*}}}*/
        //CCSprite *player = [CCSprite spriteWithFile:@"playerUnit01.png"   
                                               //rect:CGRectMake(0, 0, 115, 80)];   
        //player.position = ccp(player.contentSize.width/2,   
                              //winSize.height/2);   
        //[self addChild:player z:2];
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        _players = [[NSMutableArray alloc] init];
        _enemys = [[NSMutableArray alloc] init];
        //id enemyx = [EnemyClass new];
        //[enemyx spriteUnit];
        //[enemyx addSpriteFrames:@"enemyx3.plist" pic:@"enemyx.png" classId:self zIndex:3];
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
    // CGSize winSize = [CCDirector sharedDirector].winSize;
    self.playerUnit = [CCSprite spriteWithSpriteFrameName:@"playerUnit01_00.png"];
    _playerUnit.position = ccp(winSize.width/2, winSize.height/2);
    _playerUnit.scale = 0.6;
    self.walkAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
    [_playerUnit runAction:_walkAction];
    [spriteSheet addChild:_playerUnit];
    [_players addObject:_playerUnit];
    /* }}} */
    /* {{{ TODO这里要封装成一个方法*/
#if 0
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
     @"enemyx3.plist"];
    CCSpriteBatchNode *spriteSheet1 = [CCSpriteBatchNode batchNodeWithFile:@"enemyx.png"];
    [self addChild:spriteSheet1 z:4];
    NSMutableArray *walkAnimFrames1 = [NSMutableArray array];
    for(int j = 0; j <= 2; ++j) {
        [walkAnimFrames1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"enemyx_0%d.png", j]]];
    }
    CCAnimation *walkAnim1 = [CCAnimation animationWithFrames:walkAnimFrames1 delay:0.1f];
    self.e3Unit = [CCSprite spriteWithSpriteFrameName:@"enemyx_00.png"];
    self.walkAction1 = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim1 restoreOriginalFrame:NO]];
    _enemy3Unit.position = ccp(winSize.width/2+20, winSize.height/2);
    [_enemy3Unit runAction:_walkAction1];
    [spriteSheet1 addChild:_enemy3Unit];
#endif
    /* }}} */
    [self schedule:@selector(update:)]; //每一桢检查是否接近碰撞，如果差不多则进行进行attack
	return self;
}

- (void)starButtonTapped:(id)sender {
    [_label setString:@"生产加倍大汉"];
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
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"enemyx_00.png"];
    [self addChild:spriteSheet z:6];
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    NSMutableArray *attackAnimFrames = [NSMutableArray array];
    for(int j = 0; j <= 2; ++j) {
        [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"enemyx_0%d.png", j]]];
    }
    for(int j = 3; j<=7; ++j) {
        [attackAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"enemyx_0%d.png", j]]];
    }
    CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.3f];
    CCAnimation *attackAnim = [CCAnimation animationWithFrames:attackAnimFrames delay:0.3f];

    CCSprite * spriteUnit = [CCSprite spriteWithSpriteFrameName:@"enemyx_00.png"];
    CCAction * spriteWalkAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
    CCAction * spriteAttackAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:attackAnim restoreOriginalFrame:NO]];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    spriteUnit.position = ccp(winSize.width, winSize.height/2);
    [spriteUnit runAction:spriteWalkAction];
    CGSize s = [[CCDirector sharedDirector] winSize]; 
    CGPoint p = ccp(s.width/2, 170);
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
    //int actualY=spriteUnit.contentSize.height/2+100;
    int actualY=winSize.height/2;
    int minDuration =4.0;
    int maxDuration =8.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    actualDuration=actualDuration*4;
    //id actionMove = [CCMoveTo actionWithDuration:actualDuration 
                              //position:cpp(-spriteUnit.contentSize.width/2,actualY)];
    id actionMove = [CCMoveTo actionWithDuration:actualDuration 
                                        position:ccp(-spriteUnit.contentSize.width/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                              selector:@selector(spriteMoveFinished:)];
    [spriteUnit runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    //[spriteUnit addChild:spriteUnit];
    //[_players addObject:spriteUnit];
    [self addChild:spriteUnit z:6];
    [_enemys addObject:spriteUnit];
    CCLOG(@"enemy added");
}

-(void)addTarget {
    
    CCSprite *target = [CCSprite spriteWithFile:@"enemyUnit_9_00.png" 
                                           rect:CGRectMake(0, 0, 115, 100)]; 
    target.scale = 0.9; //target就是敌人
    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //int minY = target.contentSize.height/2;
    //int maxY = winSize.height - target.contentSize.height/2;
    //int rangeY = maxY - minY;
    //int actualY = (arc4random() % rangeY) + minY;
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
        for (CCSprite *en in _enemys) {
            CCLOG(@"e position x:%f", en.position.x);
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
