//
//  BackgroundLayer.h
//  mouseHunt
//
//  Created by Inoue Yoshiki on 12/07/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BackgroundLayer : CCLayer {
    CCParticleSystem *paricle;
    CCSprite *hole;
    
}

@property (nonatomic, retain)CCParticleSystem *paricle;
@property (nonatomic, retain)CCSprite *hole;

@end
