//
//  PreventRevocationMgr.h
//  WechatHooker
//
//  Created by  zcating on 2017/10/25.
//  Copyright © 2017年 Zcating. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MessageService;
@interface PreventRevocationMgr : NSObject

+ (void)instance:(MessageService *)service preventRevoking:(NSString *)message;

@end
