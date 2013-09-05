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
        [self addChild:_tileMap z:2];
        _tileMap.scale = 0.7;
        CGSize winSize = [[CCDirector sharedDirector] winSize];   
        /*{{{map background绿色背景*/
        CCSprite *realBackground = [CCSprite spriteWithFile:@"map_b0.png"];
        realBackground.position = ccp(120, 120);
        [self addChild:realBackground z:0]; 
        /*}}}*/
        /*{{{startgate敌军出现的地方*/
        CCSprite *startGate = [CCSprite spriteWithFile:@"object_starte.png"];
        startGate.position = ccp(26, 94);
        startGate.scale = 0.7;
        [self addChild:startGate z:4]; 
        /*}}}*/
        //CCSprite *player = [CCSprite spriteWithFile:@"playerUnit01.png"   
                                               //rect:CGRectMake(0, 0, 115, 80)];   
        //player.position = ccp(player.contentSize.width/2,   
                              //winSize.height/2);   
        //[self addChild:player z:2];
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
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
    _playerUnit.scale = 0.6;
    self.walkAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
    [_playerUnit runAction:_walkAction];
    [spriteSheet addChild:_playerUnit];
    [_players addObject:_playerUnit];
    /* }}} */
	return self;
}

- (void)starButtonTapped:(id)sender {
    [_label setString:@"生产PHP农民工"];
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
    [self addTarget];
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
