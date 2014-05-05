//
//  BackgroundLayer.m
//  mouseHunt
//
//  Created by Inoue Yoshiki on 12/07/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"


@implementation BackgroundLayer

@synthesize paricle;
@synthesize hole;

-(id)init {
    if ((self = [super init])) {
        //self.paricle = [CCParticleSmoke node];
        
        //画面サイズ取得用
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithFile:@"back.png"];
        //background.rotation = -90;
        background.position = ccp(winSize.width/2, winSize.height/2);
  
        [self addChild:background z:1];
        
        //[self addChild:self.paricle z:0];
    }
    return self;
}


@end
