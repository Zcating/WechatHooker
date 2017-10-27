//
//  main.m
//  WechatHooker
//
//  Created by  zcating on 2017/10/26.
//  Copyright © 2017年 Zcating. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Aspects.h"
#import "PreventRevocationMgr.h"
#import "MutableWechatMgr.h"
#import "FunctionMenuCreater.h"

static void __attribute__((constructor)) tweak(void) {
    NSLog(@"******************* Hooker Running *******************");
    [FunctionMenuCreater hook];
    [PreventRevocationMgr hook];
}
