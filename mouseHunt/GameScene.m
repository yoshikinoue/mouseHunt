//
//  GameScene.m
//  mouseHunt
//
//  Created by Inoue Yoshiki on 12/07/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "BackgroundLayer.h"
#import "GameoverLayer.h"
#import "Player.h"
#import "PauseLayer.h"
#import "SimpleAudioEngine.h"
#import "TitleLayer.h"
#import "GameKitHelper.h"


@implementation GameScene

@synthesize enemyController;
@synthesize baseLayer;  //ベースレイヤー　すべてのレイヤーをこいつに配置する。
@synthesize enemyLayer;
@synthesize beamLayer;
@synthesize interfaceLayer;

@synthesize player;
@synthesize scoreLabel;
@synthesize lifeLabel;
@synthesize timerLabel;

@synthesize score;
@synthesize hiscore;

@synthesize cheese1;

@synthesize _timer;

static GameScene *scene_ =nil;

+ (GameScene *)sharedInstance {
    if (scene_ == nil) {
        scene_ = [GameScene node];
    }
    return scene_;
}

- (void) dealloc {
    self.enemyController = nil;
    self.baseLayer = nil;
    self.enemyLayer = nil;
    self.beamLayer = nil;
    self.interfaceLayer = nil;
    scene_ = nil;
    [super dealloc];
}


//main
-(id)init {
    if ((self = [super init])) {
        
        [SimpleAudioEngine sharedEngine];
        
        //画面サイズ取得用
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        //背景レイヤー
        //BackgroundLayer *background = [BackgroundLayer node];
        
        //ベース
        self.baseLayer = [CCLayer node];
        [self addChild:baseLayer z:0];
        
        CCSprite *background = [CCSprite spriteWithFile:@"back.png"];
        
        //background.rotation = -90;
        background.position = ccp(winSize.width/2, winSize.height/2);
        
        [self.baseLayer addChild:background z:1];
        
        //スコア表示用　バー
        CCSprite *land = [CCSprite spriteWithFile:@"land.png"];
        land.color = ccc3(0, 0, 0);
        land.rotation = -180;
        land.anchorPoint = ccp(0,0);
        land.position = ccp(winSize.width, winSize.height);
        
        //ネズミ出現用の穴の周りを配置
        CCSprite *holeTop = [CCSprite spriteWithFile:@"holeTop.png"];
        //holeTop.anchorPoint = ccp(0,0);
        holeTop.position = ccp(holeTop.contentSize.width/2, winSize.height - ((holeTop.contentSize.height/2)+30));
        
        
        //ネズミ出現用の穴を配置
        CCSprite *holePoint = [CCSprite spriteWithFile:@"holePoint.png"];
        //holePoint.anchorPoint = ccp(0,21);
        holePoint.position = ccp(winSize.width/2, winSize.height - (26+30));
        

        
        // 自機をbaseLayer上に配置
        self.player = [Player node];
        self.player.position = ccp(0,0);
        [self.baseLayer addChild:self.player z:10];
        
        
        // 敵を表示するレイヤーをbaseLayer上に配置
        self.enemyLayer = [CCLayer node];

        
        //敵キャラ管理クラス
        self.enemyController = [EnemyController node];
        [self.baseLayer addChild:self.enemyController z:-1];
        
        [self.enemyController startController];
        
        // スコア初期化と表示用のラベルをbaseLayer上に配置
        score = 0;
        NSString *scoreString = [NSString stringWithFormat:@"%06d", score];
        self.scoreLabel = [CCLabelTTF labelWithString:scoreString
                                             fontName:@"Helvetica"
                                             fontSize:22];
        self.scoreLabel.position = ccp(420, 304);
        
        //ライフ表示
        life = 5.5;
        NSString *lifeString = [NSString stringWithFormat:@"%02d", life];
        self.lifeLabel = [CCLabelTTF labelWithString:lifeString
                                             fontName:@"Helvetica"
                                             fontSize:22];
        self.lifeLabel.position = ccp(240, 304);
        
        //タイマー表示
        _timer = 0;
        
        hiscore = 0;
        NSUserDefaults *userDefeaults = [NSUserDefaults standardUserDefaults];
        hiscore = [userDefeaults integerForKey:@"hisocore"]; 
        NSString *timeString = [NSString stringWithFormat:@"%06d", hiscore];
        self.timerLabel = [CCLabelTTF labelWithString:timeString
                                            fontName:@"Helvetica"
                                            fontSize:22];
        self.timerLabel.position = ccp(60, 304);
        
        [self.baseLayer addChild:self.timerLabel z:60];
        [self.baseLayer addChild:self.lifeLabel z:60];
        [self.baseLayer addChild:self.scoreLabel z:60];

        
        // 弾を表示するレイヤーをbaseLayer上に配置
        //self.beamLayer = [CCLayer node];
       
        // ユーザーインタフェースを担当するクラスを起動・baseLayer上に配置
        self.interfaceLayer = [InterfaceLayer node];
        
        
        [self.baseLayer addChild:self.interfaceLayer z:100];
        

        //地面
        [self.baseLayer addChild:land z:51];
        
        //[self.baseLayer addChild:cheese1 z:51];
        
        [self.baseLayer addChild:holeTop z:90];
        
        [self.baseLayer addChild:holePoint z:40];
        
        //敵
        [self.baseLayer addChild:self.enemyLayer z:50];
        
        //背景
        //[self addChild:background z:-1];
        
        
        // ゲームを開始
        [self startGame];
        
        //[self.player start];
        
    }
    return self;
}
    
#pragma -
- (void)startGame {
    
    
    // 敵キャラクターの出現
    [self.enemyController startController];
    
    // 自機の位置をリセットして動作開始
    //self.player.position = ccp(240,0);
    [self.player start];
    
    //スコアリセット
    [self resetScore];
    NSUserDefaults *userDefeaults = [NSUserDefaults standardUserDefaults];
    hiscore = [userDefeaults integerForKey:@"hiscore"]; 
    [timerLabel setString:[NSString stringWithFormat:@"%06d",hiscore]];
    
    [self schedule:@selector(updateTimer) interval:0.1];
    
    //BGM
    [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0.5f;

    // バックグラウンドミュージックの再生開始
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"167.mp3" loop:YES];
}

- (void)stopGame {
    // 敵キャラクターを除去
    [self.enemyController stopController];
    
    // 自機の動作を停止
    [self.player stop];
    
    // バックグラウンドミュージックの停止
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void)pause {
    // ポーズ用のレイヤーを画面の最前面に追加します。
    [self addChild:[PauseLayer node] z:100];
    
    // 動作を止めたいオブジェクトに対してスケジュール停止と
    // アクションを一時停止するメソッドを呼びます
    [self.baseLayer pauseSchedulerAndActions];
    [self.player pauseSchedulerAndActions];
    [self.enemyController pauseSchedulerAndActions];
    CCNode *obj;
    CCARRAY_FOREACH(self.beamLayer.children, obj) {
        [obj pauseSchedulerAndActions];
    }
    CCARRAY_FOREACH(self.enemyLayer.children, obj) {
        [obj pauseSchedulerAndActions];
    }
    CCARRAY_FOREACH(self.baseLayer.children, obj) {
        [obj pauseSchedulerAndActions];
    }
}
- (void)resume {
    // 一時停止していたオブジェクトに対して、全てを再開します。
    [self.baseLayer resumeSchedulerAndActions];
    [self.player resumeSchedulerAndActions];
    [self.enemyController resumeSchedulerAndActions];
    CCNode *obj;
    CCARRAY_FOREACH(self.beamLayer.children, obj) {
        [obj resumeSchedulerAndActions];
    }
    CCARRAY_FOREACH(self.enemyLayer.children, obj) {
        [obj resumeSchedulerAndActions];
    }
    CCARRAY_FOREACH(self.baseLayer.children, obj) {
        [obj resumeSchedulerAndActions];
    }
}

- (void)gameover {
    if (hiscore < score) {
        NSUserDefaults *userDefeaults = [NSUserDefaults standardUserDefaults];
        [userDefeaults setInteger:score forKey:@"hiscore"];  // "hiscore"というキーで保存
        [userDefeaults synchronize];  // NSUserDefaultsに即時反映させる（即時で無くてもよい場合は不要）
        
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
        [gkHelper submitScore:(int)score category:@"mouseOver"];
        
        CCLOG(@"ハイスコア更新%d",score);
    } 

    
    // ゲームオーバー用のレイヤーを画面の最前面に追加します。
    [self addChild:[GameoverLayer node] z:101];
    

    
    
    //[self.player stop];
    //[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void)addScore:(NSInteger)reward {
    // 取得した得点を加算して、画面のスコア表示を更新します。
    score += reward;
    NSString *scoreString = [NSString stringWithFormat:@"%06d", score];
    [self.scoreLabel setString:scoreString];
}


- (void)resetScore {
    score = 0;
    [self addScore:0];
}

- (void)life:(NSInteger)reward {
    life = reward;
    NSString *lifeString = [NSString stringWithFormat:@"%02d", life];
    [self.lifeLabel setString:lifeString];
    
}

- (void)resetlife {
    life = PLAYER_LIFE;
    [self life:PLAYER_LIFE];
}

- (void)updateTimer{
    _timer += 0.1;
    
    if (_timer<=0.0) {
        
        //[timerLabel setString:[NSString stringWithFormat:@"0.0"]]; // -0.0と表示されてしまうため0の時は特別
        return;
    }
    //[timerLabel setString:[NSString stringWithFormat:@"%.1f",_timer]];
}


@end
