//
//  GameoverLayer.m
//  mouseHunt
//
//  Created by Inoue Yoshiki on 12/07/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameoverLayer.h"
#import "GameScene.h"

@implementation GameoverLayer

- (id)init {
    self = [super init];
    if (self) {
        // 透明白色で画面を覆います
        CCLayerColor *shade = [CCLayerColor layerWithColor:ccc4(230, 230, 230, 200)];
        [self addChild:shade];
        
        // 画面中央にゲームオーバーのラベルを表示します
        CCLabelTTF *gameoverlabel = [CCLabelTTF labelWithString:@"げーむおーば〜"
                                               fontName:@"Helvetica"
                                               fontSize:64];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        gameoverlabel.position = ccp(winSize.width/2, winSize.height/2);
        gameoverlabel.color = ccc3(1, 1, 1);
        [self addChild:gameoverlabel];
        
        // スコアを表示します
        
        CCLabelTTF *scoretxt = [CCLabelTTF labelWithString:@"あなたのスコア"
                                                    fontName:@"Helvetica"
                                                    fontSize:24];
        
        scoretxt.position = ccp(winSize.width/3, winSize.height/4);
        scoretxt.color = ccc3(1, 1, 1);
        
        [self addChild:scoretxt];
        
        NSInteger score = [[GameScene sharedInstance]score];
        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@""
                                                     fontName:@"Helvetica"
                                                     fontSize:32];
        [scoreLabel setString:[[NSNumber numberWithInt:score] stringValue]];
        scoreLabel.position = ccp(winSize.width/3*2, winSize.height/4);
        scoreLabel.color = ccc3(1, 1, 1);
        
        [self addChild:scoreLabel];
        
        // 画面中央の下部にリプレイを促すラベルを表示します
        CCLabelTTF *replayLabel = [CCLabelTTF labelWithString:@"もう一度あそぶ"
                                                     fontName:@"Helvetica"
                                                     fontSize:32];
        replayLabel.position = ccp(winSize.width/2, winSize.height/7);
        replayLabel.color = ccc3(1, 1, 1);
        [self addChild:replayLabel];
    }
    return self;
}

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

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // タッチイベントを取り扱う場合はccTouchBeganを必ず実装します
    return YES;
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    // 画面がタップされたらゲームを再開します
    [self removeFromParentAndCleanup:YES];
    [[GameScene sharedInstance] stopGame];
    [[GameScene sharedInstance] resetScore];
    [[GameScene sharedInstance] resetlife];
    [[GameScene sharedInstance] startGame];
}
@end
