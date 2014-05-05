//
//  Enemy.h
//  mouseHunt
//
//  Created by Inoue Yoshiki on 12/07/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import "CCTouchDelegateProtocol.h"

//当たり判定用マクロ
#define ENEMY_DEFAULT_RADIUS 50

//
typedef enum{
    StateNormal,     // 通常状態。攻撃可能
    StateDamaged    // ダメージを受けているとき。当たり判定あり、攻撃不可
} mobState;

// 敵の種類を表すenum型
typedef enum{
    TypeNormal,
    Typedamage
} mobType;

typedef enum{
    a,
    b,
    c,
    d,
    e
} mobLine;

@interface Enemy : CCNode {
    CCSprite *sprite;
    BOOL isStaged;
    BOOL isHite;
    
    // 敵キャラクターのプロパティ
    float radius;   // 大きさ（半径）
    NSInteger posmob[5];   //　出現位置
    NSInteger life;     // 耐久力
    float speed;    // 移動スピード

    
    
    NSString *Enemytype;
    
    
    mobType type_;
    mobState state_;
    mobLine line_;
    
    NSInteger ih;

    @public CCArray* testAr;
    
    
}

@property (nonatomic, retain)CCSprite *sprite;
@property (nonatomic, readonly)BOOL isStaged;
@property (nonatomic, readonly)BOOL isHite;
@property (nonatomic, readonly)float radius;
//@property (nonatomic, readwrite)NSInteger posmob[5];

@property(readonly) mobState state; 
@property(readonly) mobType type;
@property(readonly) mobLine line;

@property(nonatomic)NSInteger ih;


-(void)moveFrom:(CGPoint)position
          scale:(float)scale
       velocity:(float)velocity
          layer:(CCLayer *)layer;

-(BOOL)hitIfCollided:(CGPoint)position;

-(void)moveLeft;

@end
