//
//  InterfaceLayer.m
//  mouseHunt
//
//  Created by Inoue Yoshiki on 12/07/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
//  ユーザのアクション（タッチ）を検出するレイヤー


#import "InterfaceLayer.h"
#import "GameScene.h"
#import "EnemyController.h"

@implementation InterfaceLayer



// 本クラスがアクティブなレイヤーに登録されたタイミングで、
// タッチイベントの受信を開始します
- (void)onEnter {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                     priority:0
                                              swallowsTouches:YES];
}
- (void)onExit {
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

#pragma mark タッチイベントの取り扱い
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // タッチされたポイントの座標系をcocos2dの座標系(原点:左下)に変換します。
    CGPoint locationInView = [touch locationInView: [touch view]];
    CGPoint location = [[CCDirector sharedDirector]
                        convertToGL:locationInView];


    //座標
    //CCLOG(@"%f",location.x);
    //CCLOG(@"%f",location.y);
    
    //タッチ範囲を限定する。
    if (location.y < 280) {
        BOOL isHit = [[GameScene sharedInstance].enemyController checkCollision:location];
        if (isHit) {
            //CCLOG(@"ヒット");  
        }
    }
    
    return YES;
}

@end