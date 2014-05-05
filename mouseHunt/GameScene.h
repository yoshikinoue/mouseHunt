//
//  GameScene.h
//  mouseHunt
//
//  Created by Inoue Yoshiki on 12/07/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EnemyController.h"
#import "InterfaceLayer.h"
#import "Player.h"

#define LAND_HEIGHT 25 // 地面の高さ（画像の高さと一致しないためここで定義）
#define PLAYER_LIFE 5 // プレイヤーライフ



@interface GameScene : CCScene {
    CCLayer *baseLayer;
    CCLayer *enemyLayer;
    CCLayer *beamLayer;

    Player *player;         // 自機
    CCLabelTTF *scoreLabel; // スコア表示
    CCLabelTTF *lifeLabel; //ライフ表示
    CCLabelTTF *timerLabel; //タイマー
    
    EnemyController *enemyController;   // 敵の管理クラス
    InterfaceLayer *interfaceLayer;  // 入力を受け付けるレイヤー
    
    NSInteger score;    // スコア
    NSInteger hiscore;  //　ハイスコア
    NSInteger life;     // ライフ
    float _timer;        // タイマー
    
    CCSprite *cheese1;
    
}
@property (nonatomic,retain)CCLayer *baseLayer;
@property (nonatomic,retain)CCLayer *enemyLayer;
@property (nonatomic,retain)CCLayer *beamLayer;

@property (nonatomic, retain)Player *player;
@property (nonatomic, retain)CCLabelTTF *scoreLabel;
@property (nonatomic, retain)CCLabelTTF *lifeLabel;
@property (nonatomic, retain)CCLabelTTF *timerLabel;

@property (nonatomic, retain)CCSprite *cheese1;

@property (nonatomic)NSInteger score;
@property (nonatomic)NSInteger hiscore;


@property (nonatomic)float _timer;

@property (nonatomic, retain)EnemyController *enemyController;
@property (nonatomic, retain)InterfaceLayer *interfaceLayer;
+ (GameScene *)sharedInstance;

// ゲームを開始/停止する
- (void)startGame;
- (void)stopGame;

// ゲームを一時停止/再開する
- (void)pause;
- (void)resume;

// ゲームオーバーの処理を行う
- (void)gameover;

// スコアを加算する（スコア表示も更新）
- (void)addScore:(NSInteger)reward;
// スコアのリセット
- (void)resetScore;

//ライフ計算
- (void)life:(NSInteger)reward;

- (void)resetlife;

@end
