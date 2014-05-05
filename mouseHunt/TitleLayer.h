//
//  TitleLayer.h
//  Asteroids
//
//  Created by Inoue Yoshiki on 12/07/20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameKitHelper.h"

@interface TitleLayer : CCLayer <GameKitHelperProtocol>
{
    
}
// Titleレイヤーを含むCCSceneオブジェクトを作成して返します
+(CCScene *) scene;


@end
