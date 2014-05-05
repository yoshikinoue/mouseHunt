//
//  Enemy.m
//  Asteroids
//
//  Created by Inoue Yoshiki on 12/07/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "EnemyController.h"


@interface Enemy ()

-(void)gotHit:(CGPoint)position;

@end

@implementation Enemy

enum{
    kTagSequence,
};

@synthesize sprite, isStaged;
@synthesize radius;
//@synthesize posmob[5];

//@synthesize type;
//@synthesize state;
@synthesize line=line_;

@synthesize state=state_, type=type_;

@synthesize ih;

@synthesize isHite;

-(id)init {
    self = [super init];
    if (self) {
        
        //ランダム2択
        NSInteger sundrand;
        srand(time(nil));
        sundrand = arc4random()%2;
        if(sundrand==0){
            self.sprite = [CCSprite spriteWithFile:@"mouse.png"];
        } else if(sundrand==1) {
            self.sprite = [CCSprite spriteWithFile:@"mouse.png"]; 
        }
        
        
        speed = 4;
        
        [self addChild:self.sprite];
        radius = ENEMY_DEFAULT_RADIUS;
        
        isStaged = NO;
        isHite = NO;
        state_ = StateNormal;
        
        //敵の出現位置
        posmob[0] = 0;

        ih = 0;
        
        testAr = [CCArray array];  
        [testAr addObject:[CCRepeatForever actionWithAction:
                           [CCMoveBy actionWithDuration:1.5 
                                               position:ccp(-500,0)]]];  
        [testAr addObject:@"abdddc"];  
        //CCLOG(@"普通に testAr : %d",[testAr count]);  
        
        

    }
    return self;
}

-(void)dealloc {
    self.sprite = nil;
    [super dealloc];
}

-(void)moveFrom:(CGPoint)position 
          scale:(float)scale 
       velocity:(float)velocity 
          layer:(CCLayer *)layer {
    //敵のパラメータ
    self.position = position;
    self.scale = scale;
    radius *= scale;
    //life = (CCRANDOM_0_1()+0.5) * 2.5f; //耐久値は大きさ
    
    life = 1; //耐久値は大きさ
    
    // ゲームがにぎやかになるようスプライトに色を重ねます
    self.sprite.color = ccc3(CCRANDOM_0_1()*255, CCRANDOM_0_1()*255, CCRANDOM_0_1()*255);
    
    //アニメーションで正面に戻す。
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    CCTexture2D * animTexture = [[CCTextureCache sharedTextureCache] addImage:@"mouse.png"];
    CGSize size = [animTexture contentSize];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CCSpriteFrame * frame = [CCSpriteFrame frameWithTexture:animTexture rect:rect];
    
    [walkAnimFrames addObject:frame];
    
    CCAnimation *animation = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f];
    id repeatAnim = [CCRepeatForever actionWithAction:
                     [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO]];
    
    //selfだとエラーspriteだとオッケー
    [self.sprite runAction:repeatAnim];
    
    //下に移動
    [self moveDown:velocity];
    

    
    [self scheduleUpdate];
    [layer addChild:self];
    isStaged = YES;
    
}

-(void)removeFromParentAndCleanup:(BOOL)cleanup {
    // 画面から除外するときに、プロパティもリセットしておきます
    self.position = CGPointZero;
    self.scale = 1.0f;
    radius = ENEMY_DEFAULT_RADIUS;
    isStaged = NO;
    isHite = NO;
    ih = 0;
    state_ = StateNormal;
    posmob[0] = 0;
    
    // リセット後、オーバーライドした元の処理を呼びます
    [super removeFromParentAndCleanup:cleanup];
}

//ヒットコリジョン
-(BOOL)hitIfCollided:(CGPoint)position {
    // 座標との距離が自分のサイズよりも小さい場合は当たったとみなします
    BOOL isHit = ccpDistance(self.position, position) < radius;
    if (isHit) {
        [self gotHit:position];
        
    }
    return isHit;
}

//当たり判定
-(void)gotHit:(CGPoint)position {
    life--;
    
    
    if (life<=0 && state_ == StateNormal) {
        //敵ステータス変更
        state_ = StateDamaged;
        isHite = YES;
        
        
        //ヒット時のパーティクル
//        CCParticleSystem *bomb = [CCParticleSun node];
//        bomb.duration = 0.3f;
//        bomb.life = 0.5f;
//        bomb.speed = 40;
//        bomb.scale = self.scale * 2.0f;
//        bomb.position = self.position;
//        bomb.autoRemoveOnFinish = YES;
        
        //[[GameScene sharedInstance].baseLayer addChild:bomb z:200];
        
        
        //ヒット時の画像
        [self stopMove];
        
        //[self moveLeft];
        
        
        //サウンド
        [[SimpleAudioEngine sharedEngine] playEffect:@"03.caf"
                                               pitch:2.0-self.scale
                                                 pan:0.5
                                                gain:self.scale];
        
        //スコア処理
        NSInteger score = 100 * self.scale;
        [[GameScene sharedInstance] addScore:score];
        
    }
}

//回れ左
- (void)moveLeft {
    isHite = NO;

    //アニメーションで無理やり左を向かせる
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    CCTexture2D * animTexture = [[CCTextureCache sharedTextureCache] addImage:@"mouseLeft.png"];
    CGSize size = [animTexture contentSize];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CCSpriteFrame * frame = [CCSpriteFrame frameWithTexture:animTexture rect:rect];
    
    [walkAnimFrames addObject:frame];
    
    CCAnimation *animation = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f];
    id repeatAnim = [CCRepeatForever actionWithAction:
                     [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO]];
    
    //selfだとエラーspriteだとオッケー
    [sprite runAction:repeatAnim];

    
    //移動処理
    id moveleft = [CCRepeatForever actionWithAction:
                   [CCMoveBy actionWithDuration:1.5 
                                       position:ccp(-500,0)]];
    [self runAction:moveleft];
}


//回れ右
- (void)moveRight {
    isHite = NO;

    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    CCTexture2D * animTexture = [[CCTextureCache sharedTextureCache] addImage:@"mouseRight.png"];
    CGSize size = [animTexture contentSize];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CCSpriteFrame * frame = [CCSpriteFrame frameWithTexture:animTexture rect:rect];
    
    [walkAnimFrames addObject:frame];
    
    CCAnimation *animation = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f];
    id repeatAnim = [CCRepeatForever actionWithAction:
                     [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO]];
    //selfだとエラーspriteだとオッケー
    [sprite runAction:repeatAnim];
    
    //移動処理
    id moveright = [CCRepeatForever actionWithAction:
                   [CCMoveBy actionWithDuration:1.5 
                                       position:ccp(500,0)]];
    [self runAction:moveright];
}

//移動処理
- (void)moveDown:(float)velocity {
    
    //float winHeight = [[CCDirector sharedDirector] winSize].height;
    //float duration = (CCRANDOM_0_1()*winHeight) / velocity;  //移動スピード
    float duration = speed;  //移動スピード

//    if (duration >= 8) {
//        duration = duration-8;
//    }
//    
//    if (duration <= 1) {
//        duration = duration+0.5;
//    }
    
    
    //CCLOG(@"VELOCITY%f",CCRANDOM_0_1()*winHeight);
    //CCLOG(@"速度%f",duration);
    
    id movedown = [CCMoveTo actionWithDuration:duration position:ccp(self.position.x,40)];
    
    CCSequence* sequence;

    sequence = [CCSequence actions:movedown, nil];
    sequence.tag = kTagSequence;
    
    [self runAction:sequence];
    //[self runAction:movedown];


}

//アニメーション停止ダメージ画像に切り替える。
- (void)stopMove {
    
    //アニメーションの停止
    [self stopActionByTag:kTagSequence];
    
    //ダメージ画像に変更
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    CCTexture2D * animTexture = [[CCTextureCache sharedTextureCache] addImage:@"mousedamage.png"];
    CGSize size = [animTexture contentSize];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CCSpriteFrame * frame = [CCSpriteFrame frameWithTexture:animTexture rect:rect];
    
    [walkAnimFrames addObject:frame];
    
    CCAnimation *animation = [CCAnimation animationWithFrames:walkAnimFrames delay:1.0f];
    id repeatAnim = [CCRepeatForever actionWithAction:
                     [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO]];
    [sprite runAction:repeatAnim];
}


- (void)update:(ccTime)dt {
    
    if (speed >= 0) {
        speed = speed - 0.00001;
    }

    
    //ヒット処理後少し待って、左右に逃げる。
    if (isHite) {
        if(ih > 10) {
            //画面サイズ取得用
            CGSize winSize = [[CCDirector sharedDirector] winSize];
            if (self.position.x<winSize.width/2) {
                [self moveLeft];
            } else {
                [self moveRight];
            }
        }
        ih++;
    }
    
    // 地面に激突したかどうかを自機クラスに判定してもらいます。
    // self.positionだと隕石の中心になるため、半径を引いて下端で判定します。
    CGPoint position = ccp(self.position.x, self.position.y-radius);
    BOOL isHit = [[GameScene sharedInstance].player hitIfCollided:position];
    if (isHit) {

        [self removeFromParentAndCleanup:YES];
    }
    
    //敵が画面外に出た時の判定
    BOOL isOut;
    BOOL isOut2;
    BOOL isOut3;
    
    //画面サイズ取得用
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    isOut = self.position.y > winSize.height;
    isOut2 = self.position.x > winSize.width;
    isOut3 = self.position.x < -0;
    

    if (isOut) {
        //CCLOG(@"%f%f",self.position.y,winSize.height);
        [self removeFromParentAndCleanup:YES];
        CCLOG(@"上に出ていった");
    //x480以降に行った場合    
    } else if (isOut2) {
        //CCLOG(@"%f%f",self.position.x,winSize.width);
        [self removeFromParentAndCleanup:YES];
        CCLOG(@"右に出ていった");
    //xマイナスの座標に行った場合    
    } else if (isOut3) {
        [self removeFromParentAndCleanup:YES];
        CCLOG(@"左出ていった");
    }
    

}

@end
