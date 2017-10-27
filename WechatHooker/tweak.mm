//
//  main.m
//  WechatHooker
//
//  Created by  zcating on 2017/10/26.
//  Copyright © 2017年 Zcating. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+MainHooker.h"

static void __attribute__((constructor)) tweak(void) {
    NSLog(@"******************* Hooker Running *******************");
    [NSObject hook];
}
