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

/**
 *@brief 封装载入图片后返回batchNode的操作
 *@param fileName NSString * plist文件和png文件的前缀，导出时写成一样 
 */
-(void) addSpriteFrames:(NSString *)plistName pic:(NSString *)picName classId:(id)cid zIndex:(int)zid;
 @end
