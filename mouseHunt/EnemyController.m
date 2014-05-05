//
//  EnemyController.m
//  mouseHunt
//
//  Created by Inoue Yoshiki on 12/07/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//


#import "EnemyController.h"
#import "Enemy.h"
#import "GameScene.h"

#import "BackgroundLayer.h"

@interface EnemyController()
// 敵をステージ上に配置するメソッド
-(void)stageEnemy;

@end


@implementation EnemyController

@synthesize enemies;
@synthesize enemiesA;
@synthesize enemiesB;



-(id)init {
    self = [super init];
    if (self) {
        
        _timer = 0;
        
        //敵管理配列
        self.enemies = [NSMutableArray arrayWithCapacity:10];
        
        // 敵キャラクターを先に作成してストックしておき、
        // ゲームプレイ時に余計な処理を行わないようにしておきます。
        for (int i=0; i<10; i++) {
            Enemy *enemy = [Enemy node];
            [self.enemies addObject:enemy];
        }
        enemyPos = 0;
        
        self.enemiesA = [NSMutableArray arrayWithCapacity:20];
        
        // 敵キャラクターを先に作成してストックしておき、
        // ゲームプレイ時に余計な処理を行わないようにしておきます。
        for (int i=0; i<10; i++) {
            Enemy *enemy = [Enemy node];
            [self.enemiesA addObject:enemy];
        }
        
        self.enemiesB = [NSMutableArray arrayWithCapacity:10];
        
        // 敵キャラクターを先に作成してストックしておき、
        // ゲームプレイ時に余計な処理を行わないようにしておきます。
        for (int i=0; i<10; i++) {
            Enemy *enemy = [Enemy node];
            [self.enemiesB addObject:enemy];
        }
        
    }
    return self;
}

-(void)dealloc {
    self.enemies = nil;
    self.enemiesA = nil;
    self.enemiesB = nil;
    [super dealloc];
}

-(void)startController {
    // 初回の敵出現タイミングを1秒後にスケジュールすることで、
    // 管理クラスとして動作開始します。
    [self schedule:@selector(stageEnemy) interval:1.0f];
    
    [self schedule:@selector(updateTimer) interval:0.1];
    
    nextTime = 1;
    
    enemylevel = 1;
    
    _timer = 0.0;
}

-(void)stopController {
    // イベントをスケジューラーから解除し、
    // 画面表示している敵キャラクターを全て取り除きます
    [self unschedule:@selector(stageEnemy)];
    for (Enemy *e in self.enemies) {
        if (e.isStaged) {
            [e removeFromParentAndCleanup:YES];
        }
    }
    for (Enemy *eA in self.enemiesA) {
        if (eA.isStaged) {
            [eA removeFromParentAndCleanup:YES];
        }
    }
    for (Enemy *eB in self.enemiesB) {
        if (eB.isStaged) {
            [eB removeFromParentAndCleanup:YES];
        }
    }
}


//これを列ごとに複数用意する。
-(void)stageEnemy {
    // 敵の種類(このゲームでは大きさや耐久力)をこの時点で決定し、
    // ストックしておいた敵キャラクターのオブジェクトを個性付けした上で、
    // レイヤーに配置します。
    Enemy *e = [self.enemies objectAtIndex:enemyPos];
    Enemy *eA = [self.enemiesA objectAtIndex:enemyPos];
    Enemy *eB = [self.enemiesB objectAtIndex:enemyPos];
    
    // オブジェクトが既に配置されている場合は、何もせず次のタイミングを待ちます。
    if (!e.isStaged) {
        float scale = 1;
        float velocity = 20;
        //５箇所から出現させるためにランダムに選択
        NSInteger sundrand;
        
        srand(time(nil));
        sundrand = arc4random()%5;
        
        CGPoint position;
        
        if (nextTime <= 0.50) {
            nextTime = 0.50;
        }
        

            if(sundrand==0 && stock[0] != 1){
                position = ccp(40,300);
                stock[0] = stock[0]+1;
                CCLOG(@"stock[0]%d",stock[0]);
                [e moveFrom:position 
                      scale:scale
                   velocity:velocity 
                      layer:[GameScene sharedInstance].enemyLayer];

                
                if (enemylevel == 2 || enemylevel == 3) {
                    position = ccp(230,300);
                    [eA moveFrom:position 
                           scale:scale
                        velocity:velocity 
                           layer:[GameScene sharedInstance].enemyLayer];
                }
                
                if (enemylevel == 3) {
                    position = ccp(430,300);
                    [eB moveFrom:position 
                           scale:scale
                        velocity:velocity 
                           layer:[GameScene sharedInstance].enemyLayer];
                }

                enemyPos = (enemyPos + 1)%10;
                
            } else if(sundrand==0 && stock[0] == 1) {
                nextTime = nextTime - 0.04;
                stock[0] = stock[0]-1;

            } else if(sundrand==1 && stock[1] != 1) {
                position = ccp(130,300);
                stock[1] = stock[1]+1;
                CCLOG(@"stock[1]%d",stock[1]);
                [e moveFrom:position 
                      scale:scale
                   velocity:velocity 
                      layer:[GameScene sharedInstance].enemyLayer];
                
                
                if (enemylevel == 2 || enemylevel == 3) {
                    position = ccp(430,300);
                    [eA moveFrom:position 
                           scale:scale
                        velocity:velocity 
                           layer:[GameScene sharedInstance].enemyLayer];
                }
                
                if (enemylevel == 3) {
                    position = ccp(230,300);
                    [eB moveFrom:position 
                           scale:scale
                        velocity:velocity 
                           layer:[GameScene sharedInstance].enemyLayer];
                }
                
                enemyPos = (enemyPos + 1)%10;

            }else if(sundrand==1 && stock[1] == 1) {
                nextTime = nextTime - 0.04;
                
                stock[1] = stock[1]-1;
                
            } else if(sundrand==2 && stock[2] != 1) {
                position = ccp(230,300);
                stock[sundrand] = stock[sundrand]+1;
                CCLOG(@"stock[2]%d",stock[2]);
                [e moveFrom:position 
                      scale:scale
                   velocity:velocity 
                      layer:[GameScene sharedInstance].enemyLayer];
                
                
                if (enemylevel == 2 || enemylevel == 3) {
                    position = ccp(430,300);
                    [eA moveFrom:position 
                           scale:scale
                        velocity:velocity 
                           layer:[GameScene sharedInstance].enemyLayer];
                }
                
                if (enemylevel == 3) {
                    position = ccp(130,300);
                    [eB moveFrom:position 
                           scale:scale
                        velocity:velocity 
                           layer:[GameScene sharedInstance].enemyLayer];
                }
                
                enemyPos = (enemyPos + 1)%10;

            }else if(sundrand==2 && stock[2] == 1) {
                nextTime = nextTime - 0.04;
                
                stock[2] = stock[2]-1;
                
            } else if(sundrand==3 && stock[3] != 1) {    
                position = ccp(330,300);
                stock[sundrand] = stock[sundrand]+1;
                CCLOG(@"stock[3]%d",stock[3]);
                [e moveFrom:position 
                      scale:scale
                   velocity:velocity 
                      layer:[GameScene sharedInstance].enemyLayer];
                
                
                if (enemylevel == 2 || enemylevel == 3) {
                    position = ccp(230,300);
                    [eA moveFrom:position 
                           scale:scale
                        velocity:velocity 
                           layer:[GameScene sharedInstance].enemyLayer];
                }
                
                if (enemylevel == 3) {
                    position = ccp(130,300);
                    [eB moveFrom:position 
                           scale:scale
                        velocity:velocity 
                           layer:[GameScene sharedInstance].enemyLayer];
                }
                
                enemyPos = (enemyPos + 1)%10;

            }else if(sundrand==3 && stock[3] == 1) {    
                nextTime = nextTime - 0.04;
                
                stock[3] = stock[3]-1;
                
                
            } else if(sundrand==4 && stock[4] != 1) {
                position = ccp(430,300);
                stock[sundrand] = stock[sundrand]+1;
                CCLOG(@"stock[4]%d",stock[4]);
                [e moveFrom:position 
                      scale:scale
                   velocity:velocity 
                      layer:[GameScene sharedInstance].enemyLayer];
                
                
                if (enemylevel == 2 || enemylevel == 3) {
                    position = ccp(130,300);
                    [eA moveFrom:position 
                           scale:scale
                        velocity:velocity 
                           layer:[GameScene sharedInstance].enemyLayer];
                }
                
                if (enemylevel == 3) {
                    position = ccp(40,300);
                    [eB moveFrom:position 
                           scale:scale
                        velocity:velocity 
                           layer:[GameScene sharedInstance].enemyLayer];
                }
                
                enemyPos = (enemyPos + 1)%10;

            }else if(sundrand==4 && stock[4] == 1) {
                nextTime = nextTime - 0.04;
                
                stock[4] = stock[4]-1;
                
            }        

    }

    
    CCLOG(@"Nexttime%f",nextTime);
    
    // 次の出現タイミングを再スケジュールします
    //スケジュールを解除
    [self unschedule:@selector(stageEnemy)];
    //１秒待ってスケジュール再開
    [self schedule:@selector(stageEnemy) interval:nextTime];
}

//当たり判定
- (BOOL)checkCollision:(CGPoint)position {
    BOOL isHit = NO;
    for (Enemy *e in self.enemies) {
        // 画面に配置されていなければチェックしないようにして、無駄な処理を省きます。
        if (e.isStaged) {
            //EnemyクラスのhitIfCollidedにパス。
            isHit = [e hitIfCollided:position];
            // 当たっていればチェック終了
            if (isHit) {
                if (e.position.x == 40) {
                    stock[0] = stock[0]-1;
                    //CCLOG(@"%d",stock[0]);
                } else if (e.position.x == 130) {
                    stock[1] = stock[1]-1;
                    //CCLOG(@"%d",stock[1]);
                } else if (e.position.x == 230) {
                    stock[2] = stock[2]-1;
                    //CCLOG(@"%d",stock[2]);
                } else if (e.position.x == 330) {
                    stock[3] = stock[3]-1;
                    //CCLOG(@"%d",stock[3]);
                } else if (e.position.x == 430) {
                    stock[4] = stock[4]-1;
                    //CCLOG(@"%d",stock[4]);
                } else {
                    //無いとは思うが一応
                    CCLOG(@"例外発生");
                }
                
                break;
            }
        }
    }
    
    for (Enemy *eA in self.enemiesA) {
        // 画面に配置されていなければチェックしないようにして、無駄な処理を省きます。
        if (eA.isStaged) {
            //EnemyクラスのhitIfCollidedにパス。
            isHit = [eA hitIfCollided:position];
            // 当たっていればチェック終了
            if (isHit) {
                break;
            }
        }
    }

    for (Enemy *eB in self.enemiesB) {
        // 画面に配置されていなければチェックしないようにして、無駄な処理を省きます。
        if (eB.isStaged) {
            //EnemyクラスのhitIfCollidedにパス。
            isHit = [eB hitIfCollided:position];
            // 当たっていればチェック終了
            if (isHit) {
                break;
            }
        }
    }
    
    return isHit;

}

- (void)updateTimer{
    _timer += 0.1;
    
    if (_timer>=15.0 && enemylevel == 1) {
        enemylevel = 2;
        nextTime = 1;
        return;
    }
    if (_timer>=45.0 && enemylevel == 2) {
        enemylevel = 3;
        nextTime = 1;
        return;
    }

}


@end
