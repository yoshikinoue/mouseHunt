//
//  EnemyController.h
//  mouseHunt
//
//  Created by Inoue Yoshiki on 12/07/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EnemyController : CCNode {
    NSMutableArray *enemies;
    NSMutableArray *enemiesA;    
    NSMutableArray *enemiesB; 
    
    NSInteger enemyPos;

    ccTime nextTime;
    
    NSInteger stock[5];
    
    NSInteger enemylevel;
    
    float _timer;        // タイマー
    
}

@property (nonatomic,retain)NSMutableArray *enemies;
@property (nonatomic,retain)NSMutableArray *enemiesA;
@property (nonatomic,retain)NSMutableArray *enemiesB;

-(void)startController;

-(void)stopController;

//記述なし
// 管理している敵キャラ各に当たり判定を実施
- (BOOL)checkCollision:(CGPoint)position;

@end
