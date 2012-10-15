//
//  DataModel.h
//  Cocos2D Build a Tower Defense Game
//
//  Created by iPhoneGameTutorials on 4/4/11.
//  Copyright 2011 iPhoneGameTutorial.com All rights reserved.
//

#import "cocos2d.h"

@interface DataModel : NSObject <NSCoding> {
    CCLayer *_gameLayer;
        
    NSMutableArray *_targets;   
    NSMutableArray *_waypoints; 
        
    NSMutableArray *_waves; 
        
}

@property (nonatomic, retain) CCLayer *_gameLayer;

@property (nonatomic, retain) NSMutableArray * _targets;
@property (nonatomic, retain) NSMutableArray * _waypoints;

@property (nonatomic, retain) NSMutableArray * _waves;

+ (DataModel*)getModel;

@end  
