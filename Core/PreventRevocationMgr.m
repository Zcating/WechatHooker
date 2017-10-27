//
//  PreventRevocationMgr.m
//  WechatHooker
//
//  Created by  zcating on 2017/10/25.
//  Copyright © 2017年 Zcating. All rights reserved.
//

#import "PreventRevocationMgr.h"


#import <objc/runtime.h>

//
#import "Aspects.h"
#import "RTRegexHelper.h"

//
#import "MMServiceCenter.h"
#import "MMService.h"
#import "MessageService.h"
#import "MessageData.h"
//
//#import "MMSessionInfo.h"
//#import "MMSessionMgr.h"


@import Cocoa;

@implementation PreventRevocationMgr

+(void)hook {
    [RTMessageService aspect_hookSelector:NSSelectorFromString(@"onRevokeMsg:") withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info){
        if ([[NSUserDefaults standardUserDefaults] boolForKey: ALLOW_PREVENT_REVOCATION]) {
            [self instance:[info instance] preventRevoking:[info arguments].firstObject];
        } else {
            [[info originalInvocation] invoke];
        }
    } error:nil];
    
    [RTMessageService aspect_hookSelector:NSSelectorFromString(@"AddLocalMsg:msgData:") withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info) {
        for (id argument in [info arguments]) {
            NSLog(@"%@", argument);
        }
    } error:nil];
}

#pragma mark - No Revoke Message

+ (void)instance:(MessageService *)service preventRevoking:(NSString *)message {
    ///<sysmsg type="revokemsg"><revokemsg><session>wxid_qdxmce84ueno12</session><msgid>1656418240</msgid><newmsgid>8250926699869451612</newmsgid><replacemsg><![CDATA["sunhay" 撤回了一条消息]]></replacemsg></revokemsg></sysmsg>
//    NSArray *pair = [informativeText componentsSeparatedByString:@" "];
//    NSString *name = [pair[0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//    NSString *receiveMsg = pair[1];
    NSString *session   = [RTRegexHelper matchXMLTag:@"session"  inXMLText:message];
//    NSString *msgID     = [RTRegexHelper matchXMLTag:@"msgid"    inXMLText:message];
    NSString *newMsgID  = [RTRegexHelper matchXMLTag:@"newmsgid" inXMLText:message];
    NSUInteger newMsgID_llType = [newMsgID longLongValue];

    id lastMsgData = [service GetMsgData:session svrId:newMsgID_llType];
    if (lastMsgData == nil) {
        return;
    }
    
    NSString *receiveMsg = [RTRegexHelper getChatContent:message];
    id msgData = [[RTMessageData alloc] initWithMsgType:0x2710];
    [msgData setMsgStatus:0x4];
    [msgData setMsgContent:receiveMsg];
    [msgData setFromUsrName:[lastMsgData toUsrName]];
    [msgData setToUsrName:[lastMsgData fromUsrName]];
    [msgData setMsgCreateTime:[lastMsgData msgCreateTime]];
    [msgData setMesLocalID:[lastMsgData mesLocalID]];

    
    NSString *revokeContent = [NSString stringWithFormat:@"Ta 撤回了：%@", [lastMsgData msgContent]];
    id revokingData = [[RTMessageData alloc] initWithMsgType:0x2710];
    [revokingData setMsgStatus:0x4];
    [revokingData setMsgContent:revokeContent];
    [revokingData setFromUsrName:[lastMsgData toUsrName]];
    [revokingData setToUsrName:[lastMsgData fromUsrName]];
    [revokingData setMsgCreateTime:[lastMsgData msgCreateTime]];
    [revokingData setMesLocalID:[lastMsgData mesLocalID]];
//    [service DelMsg:session msgList:@[lastMsgData] isDelAll:0 isManual:1];
    
    [service AddLocalMsg:session msgData:msgData];
    [service AddLocalMsg:session msgData:revokingData];
}



@end
