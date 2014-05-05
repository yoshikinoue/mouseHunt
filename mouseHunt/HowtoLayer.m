//
//  HowtoLayer.m
//  Asteroids
//
//  Created by Inoue Yoshiki on 12/07/21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "HowtoLayer.h"

#import "SimpleAudioEngine.h"

@interface HowtoLayer ()
-(void)pushedBackbutton:(id)sender;     //バックボタンを押下時

@end

@implementation HowtoLayer


-(id)init {
    if ((self = [super init])) {
        
        //画面サイズの取得
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        //タイトル画面の描写
        CCSprite *background = [CCSprite spriteWithFile:@"Default.png"];
        background.rotation = -90;
        background.position = ccp(winSize.width/2, winSize.height/2);
        
        
        CCLayerColor* layer = [CCLayerColor layerWithColor:ccc4(128, 128, 128, 200)];
        
        //遊び方ラベル
        CCLabelTTF *Backlabel = [CCLabelTTF labelWithString:@"Back"
                                                    fontName:@"Helvetica"
                                                    fontSize:36];
        
        
        CCMenuItemLabel *Backitem = [CCMenuItemLabel itemWithLabel:Backlabel 
                                                             target:self 
                                                           selector:@selector(pushedBackbutton:)]; 
        
        CCMenu *menu = [CCMenu menuWithItems:Backitem, nil];
        
        [menu alignItemsHorizontally];
        
        menu.position = ccp(winSize.width/2, winSize.height/2);
        
        
        
        //[self addChild:background];
        [self addChild:layer];
        [self addChild:menu];
        
    }
    return self;
}


//バックボタンを押されたらタイトル画面に戻る
-(void)pushedBackbutton:(id)sender {
    [self removeFromParentAndCleanup:YES];
}



@end
