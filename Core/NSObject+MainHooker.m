//
//  NSObject+MainHooker.m
//  WechatHooker
//
//  Created by  zcating on 2017/10/27.
//  Copyright © 2017年 Zcating. All rights reserved.
//

#import "NSObject+MainHooker.h"


#import "Aspects.h"
#import "JRSwizzle.h"
#import "PreventRevocationMgr.h"
#import "FunctionMenuCreater.h"

@implementation NSObject (MainHooker)
+(void)hook {
    // Aspects can't hook class method
//    NSError *error = nil;
//    [RTCUtility aspect_hookSelector:NSSelectorFromString(@"HasWechatInstance") withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info) {
//        int alwaysNO = NO;
//        NSInvocation *invocation = info.originalInvocation;
//        [invocation setReturnValue:&alwaysNO];
//        [invocation invoke];
//
//    } error:&error];
//    NSLog(@"%@", error);
    
    [RTCUtility jr_swizzleMethod:NSSelectorFromString(@"HasWechatInstance") withMethod:@selector(hook_HasWechatInstance) error:nil];
    
    [RTMessageService aspect_hookSelector:NSSelectorFromString(@"onRevokeMsg:") withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info){
        if ([[NSUserDefaults standardUserDefaults] boolForKey: ALLOW_PREVENT_REVOCATION]) {
            [PreventRevocationMgr instance:[info instance] preventRevoking:[info arguments].firstObject];
        } else {
            [[info originalInvocation] invoke];
        }
    } error:nil];
    
    [RTAppDelegate aspect_hookSelector:@selector(applicationDidFinishLaunching:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info) {
        [FunctionMenuCreater createMenu];
    } error:nil];
}

+ (BOOL)hook_HasWechatInstance {
    return NO;
}

@end
