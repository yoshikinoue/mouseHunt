//
//  Player.h
//  mouseHunt
//
//  Created by Inoue Yoshiki on 12/07/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
// 現在の自機の状態を表す列挙子
typedef enum {
    kCannonIsStopped = 0,
    kCannonIsMovingToLeft,
    kCannonIsMovingToRight,
} MovingState;


@interface Player : CCNode {
    BOOL started;       // 動作開始しているか
    CCSprite *sprite;   // スプライト
    
    CCSprite *cheese1;
    CCSprite *cheese2;
    CCSprite *cheese3;
    CCSprite *cheese4;
    CCSprite *cheese5;
    
    
    MovingState state;  // 自機の動作状態
    NSInteger life;     // 残りライフ

}
@property (nonatomic, retain)CCSprite *sprite;

@property (nonatomic, retain)CCSprite *cheese1;
@property (nonatomic, retain)CCSprite *cheese2;
@property (nonatomic, retain)CCSprite *cheese3;
@property (nonatomic, retain)CCSprite *cheese4;
@property (nonatomic, retain)CCSprite *cheese5;

// 指定された座標に対して衝突しているかどうか判定
- (BOOL)hitIfCollided:(CGPoint)position;
// 動作開始
- (void)start;
// 動作停止
- (void)stop;

@end
