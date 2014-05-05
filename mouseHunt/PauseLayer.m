//
//  PauseLayer.m
//  Asteroids
//
//  Created by Inoue Yoshiki on 12/07/19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "PauseLayer.h"
#import "GameScene.h"


@implementation PauseLayer

-(id)init {
    self = [super init];
    if (self) {
        CCLayerColor *shade = [CCLayerColor layerWithColor:ccc4(30, 30, 30, 200)];
        [self addChild:shade];
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap to resume."
                                               fontName:@"Helvetica"
                                               fontSize:48];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
    }
    return self;
}

-(void)onEnter {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                    priority:0 
                                              swallowsTouches:YES];
}

-(void)onExit {
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [self removeFromParentAndCleanup:YES];
    [[GameScene sharedInstance] resume];
}

@end
