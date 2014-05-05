//
//  Player.m
//  mouseHunt
//
//  Created by Inoue Yoshiki on 12/07/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "GameScene.h"
#import "SimpleAudioEngine.h"

@interface Player ()
// 弾を発射するメソッド
//- (void)fire;
// 敵が地面に激突したイベントを扱うメソッド
- (void)gotHit:(CGPoint)position;
@end

@implementation Player

@synthesize sprite;

@synthesize cheese1;
@synthesize cheese2;
@synthesize cheese3;
@synthesize cheese4;
@synthesize cheese5;

-(id)init {
    self = [super init];
    if (self) {
        started = NO;
    

        
    }
    return self;
}

- (void)dealloc {
    self.sprite = nil;
    //self.cartridge = nil;
    // スケジューリングしていたイベントを全て停止してから終了します
    [self unscheduleAllSelectors];
    [self unscheduleUpdate];
    
    [super dealloc];
}

- (void)start {
    // 移動と弾を発射するためのイベントを動かし始めます
    life = PLAYER_LIFE;
    //画面サイズ取得用
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    self.cheese1 = [CCSprite spriteWithFile:@"cheese.png"];
    self.cheese1.position = ccp(winSize.width/10, LAND_HEIGHT);
    [self addChild:self.cheese1];
    
    self.cheese2 = [CCSprite spriteWithFile:@"cheese.png"];
    self.cheese2.position = ccp(winSize.width/10*3, LAND_HEIGHT);
    [self addChild:self.cheese2];        
    
    self.cheese3 = [CCSprite spriteWithFile:@"cheese.png"];
    self.cheese3.position = ccp(winSize.width/10*5, LAND_HEIGHT);
    [self addChild:self.cheese3];
    
    self.cheese4 = [CCSprite spriteWithFile:@"cheese.png"];
    self.cheese4.position = ccp(winSize.width/10*7, LAND_HEIGHT);
    [self addChild:self.cheese4];
    
    self.cheese5 = [CCSprite spriteWithFile:@"cheese.png"];
    self.cheese5.position = ccp(winSize.width/10*9, LAND_HEIGHT);
    [self addChild:self.cheese5];
    
    started = YES;
}

- (void)stop {
    started = NO;
    [self unscheduleUpdate];
}

- (BOOL)hitIfCollided:(CGPoint)position {
    // 地面の高さに到達している場合は衝突したとみなします
    BOOL isHit = position.y < LAND_HEIGHT;

    if (isHit) {
        [self gotHit:position];
    }
    return isHit;
}




- (void)gotHit:(CGPoint)position {
    if (position.x == 40 && cheese1.isRunning == YES) {
        [self removeChild:cheese1 cleanup:YES];
        life--;
        CCLOG(@"アウト40");
    } else if (position.x == 130 && cheese2.isRunning == YES) {
        [self removeChild:cheese2 cleanup:YES];
        life--;
        CCLOG(@"アウト130");
    } else if (position.x == 230 && cheese3.isRunning == YES) {
        [self removeChild:cheese3 cleanup:YES];
        life--;
        CCLOG(@"アウト230");
    } else if (position.x == 330 && cheese4.isRunning == YES) {
        [self removeChild:cheese4 cleanup:YES];
        life--;
        CCLOG(@"アウト330");
    } else if (position.x == 430 && cheese5.isRunning == YES) {
        [self removeChild:cheese5 cleanup:YES];
        life--;
        CCLOG(@"アウト430");
    }
    CCLOG(@"残りチーズ：%d", life);

    [[GameScene sharedInstance] life:life];
    
    id action = [CCShaky3D actionWithRange:5 shakeZ:YES grid:ccg(10,15) duration:0.5];
    id reset = [CCCallBlock actionWithBlock:^{
        [GameScene sharedInstance].baseLayer.grid = nil;
    }];
    [[GameScene sharedInstance].baseLayer runAction:[CCSequence actions:action, reset, nil]];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"out.caf" ];
    
    //ゲームオーバーの条件
    if (life < 1 && started == YES) {
        [[GameScene sharedInstance] gameover];
        started = NO;
        
    }
}

@end
