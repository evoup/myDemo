//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "DataModel.h"

// HelloWorld implementation
@implementation HelloWorld

// At the top, under @implementation
@synthesize playerUnit = _playerUnit;
@synthesize moveAction = _moveAction;
@synthesize walkAction = _walkAction;

@synthesize jzeUnit = _jzeUnit;
@synthesize jzemoveAction = _jzemoveAction;
@synthesize jzewalkAction = _jzewalkAction;

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

    DataModel *dm = [DataModel getModel];
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
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMap.tmx"];
        self.background = [_tileMap layerNamed:@"Background"];
        self.background.anchorPoint = ccp(0, 0);
        [self addChild:_tileMap z:1];
        CGSize winSize = [[CCDirector sharedDirector] winSize];   
        /*{{{map background*/
        CCSprite *realBackground = [CCSprite spriteWithFile:@"map_b0.png"];
        realBackground.position = ccp(120, 120); 
        [self addChild:realBackground z:0]; 
        /*}}}*/
        /*{{{startgate*/
        CCSprite *startGate = [CCSprite spriteWithFile:@"object_starte.png"];
        startGate.position = ccp(48, 136); 
        [self addChild:startGate z:4]; 
        /*}}}*/
        //CCSprite *player = [CCSprite spriteWithFile:@"playerUnit01.png"   
                                               //rect:CGRectMake(0, 0, 115, 80)];   
        //player.position = ccp(player.contentSize.width/2,   
                              //winSize.height/2);   
        //[self addChild:player z:2]; 
        _players = [[NSMutableArray alloc] init];
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
    starMenuItem.position = ccp(60, 60);
    CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem, nil];
    starMenu.position = CGPointZero;
    [self addChild:starMenu z:5];
    CCMenuItem *soldierMenuItem = [CCMenuItemImage 
                                itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png" 
                                target:self selector:@selector(soldierButtonTapped:)];
    soldierMenuItem.position = ccp(140, 60);
    CCMenu *soldierMenu = [CCMenu menuWithItems:soldierMenuItem, nil];
    soldierMenu.position = CGPointZero;
    [self addChild:soldierMenu z:5];
    /* }}} */
    /* {{{ add sprite animation
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
    self.walkAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
    [_playerUnit runAction:_walkAction];
    [spriteSheet addChild:_playerUnit];
    [_players addObject:_playerUnit];
    /* }}} */
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
     @"ani_jze.plist"];
    CCSpriteBatchNode *spriteSheet1 = [CCSpriteBatchNode batchNodeWithFile:@"ani_jze.png"];
    [self addChild:spriteSheet1 z:3];
    NSMutableArray *walkAnim1Frames = [NSMutableArray array];

    for(int i = 0; i <= 58; ++i) {
        [walkAnim1Frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"jze_%03d.jpg", i]]];
    }
   
    CCAnimation *walkAnim1 = [CCAnimation animationWithFrames:walkAnim1Frames delay:0.1f];
    self.jzeUnit = [CCSprite spriteWithSpriteFrameName:@"jze_000.jpg"];
    
    _jzeUnit.position = ccp(winSize.width/2, winSize.height/2);
    
    self.jzewalkAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim1 restoreOriginalFrame:NO]];
    [_jzeUnit runAction:_jzewalkAction];
    [spriteSheet1 addChild:_jzeUnit];
	return self;
}

- (void)starButtonTapped:(id)sender {
    [_label setString:@"夺宝奇兵恶搞"];
    for (CCSprite *target in _players) {
        [target setPosition:ccp(target.position.x-12, target.position.y)];
    }
}
- (void)soldierButtonTapped:(id)sender {
    [_label setString:@"XX恶搞"];
    for (CCSprite *target in _players) {
        [target setPosition:ccp(target.position.x+12, target.position.y)];
    }
}
-(void)addTarget {
    
    CCSprite *target = [CCSprite spriteWithFile:@"enemyUnit_9_00.png" 
                                           rect:CGRectMake(0, 0, 115, 100)]; 
    
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
    [self addTarget];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [_label release];
    _label = nil;
    [_moneyLabel release];
    _moneyLabel = nil;
    // In dealloc
    self.playerUnit = nil;
    self.walkAction = nil;
    self.jzewalkAction = nil;
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
