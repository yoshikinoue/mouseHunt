//
//  TitleLayer.m
//  Asteroids
//
//  Created by Inoue Yoshiki on 12/07/20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TitleLayer.h"
#import "GameScene.h"
#import "HowtoLayer.h"
#import "SimpleAudioEngine.h"


@interface TitleLayer ()
//プレイボタン
-(void)pushedPlayButton:(id)sender;
-(void)pushedHowtoButton:(id)sender;

@end

@implementation TitleLayer
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	TitleLayer *layer = [TitleLayer node];
	
	[scene addChild:layer];
	return scene;
}

-(id)init {
    if ((self = [super init])) {
        
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
		gkHelper.delegate = self;
		[gkHelper authenticateLocalPlayer];
        
        
        
        //画面サイズの取得
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        //タイトル画面の描写
        CCSprite *background = [CCSprite spriteWithFile:@"Title.png"];
        //background.rotation = -90;
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:background z:-1];
        
        //タイトルラベル
        CCLabelTTF *Playlabel = [CCLabelTTF labelWithString:@"げーむすたーと"
                                               fontName:@"Helvetica"
                                               fontSize:36];
        
        CCMenuItemLabel *Playitem = [CCMenuItemLabel itemWithLabel:Playlabel 
                                                         target:self 
                                                       selector:@selector(pushedPlayButton:)]; 
        
        //遊び方ラベル
//        CCLabelTTF *Howtolabel = [CCLabelTTF labelWithString:@"How to play"
//                                               fontName:@"Helvetica"
//                                               fontSize:36];
        

                                  
//        CCMenuItemLabel *Howtoitem = [CCMenuItemLabel itemWithLabel:Howtolabel 
//                                                        target:self 
//                                                      selector:@selector(pushedHowtoButton:)]; 
                                 
        [Playitem  runAction:[CCTintTo actionWithDuration:0 red:10 green:10 blue:10]];
        //[Howtoitem runAction:[CCTintTo actionWithDuration:0 red:10 green:10 blue:10]];
        
        CCMenu *menu = [CCMenu menuWithItems:Playitem, nil];
        
        [menu alignItemsHorizontally];
        
        
        
        //menu.position = ccp(winSize.width/2, winSize.height/2);
        menu.position = ccp(winSize.width/2, 40);
        [self addChild:menu];
        
        //サウンドエンジンの初期化
        [SimpleAudioEngine sharedEngine];
            
    }
    return self;
}

//ゲームスクリーンに移動
-(void)pushedPlayButton:(id)sender {
    GameScene *gameScene = [GameScene sharedInstance];
    CCScene *transition = [CCTransitionFade transitionWithDuration:0.5f
                                                             scene:gameScene
                                                         withColor:ccc3(255, 255, 255)];
    [[CCDirector sharedDirector] replaceScene:transition];
    
}

//遊び方スクリーンに移動・・・予定
-(void)pushedHowtoButton:(id)sender {

    [self addChild:[HowtoLayer node] z:100];
}

#pragma mark GameKitHelper delegate methods
-(void) onLocalPlayerAuthenticationChanged
{
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	CCLOG(@"LocalPlayer isAuthenticated changed to: %@", localPlayer.authenticated ? @"YES" : @"NO");
	
	if (localPlayer.authenticated)
	{
		GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
		[gkHelper getLocalPlayerFriends];
		//[gkHelper resetAchievements];
	}	
}

-(void) onFriendListReceived:(NSArray*)friends
{
	CCLOG(@"onFriendListReceived: %@", [friends description]);
	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
	[gkHelper getPlayerInfo:friends];
}

-(void) onPlayerInfoReceived:(NSArray*)players
{
	CCLOG(@"onPlayerInfoReceived: %@", [players description]);
	
	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
	[gkHelper submitScore:1234 category:@"mouseOver"];
}

-(void) onScoresSubmitted:(bool)success
{
	CCLOG(@"onScoresSubmitted: %@", success ? @"YES" : @"NO");
	
	if (success)
	{
		//GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
		//[gkHelper retrieveTopTenAllTimeGlobalScores];
	}
}

-(void) onScoresReceived:(NSArray*)scores
{
	CCLOG(@"onScoresReceived: %@", [scores description]);
	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
	[gkHelper showLeaderboard];
}

-(void) onLeaderboardViewDismissed
{
	CCLOG(@"onLeaderboardViewDismissed");
}

//-(void)authenticateLocalPlayer {
//    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
//        if (error) 
//        { /* エラー処理 */ }
//        else 
//        { /* 認証済みユーザーを使ってハイスコアとか処理 */ }
//    }];
//}
//
//-(void)submitScore:(int64_t)score forCategory:(NSString*)category {
//    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
//    scoreReporter.value = score;
//    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
//        if (error) { /* エラー処理 */ }
//    }];
//}

@end
