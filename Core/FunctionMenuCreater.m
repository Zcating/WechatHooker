//
//  FunctionMenuCreater.m
//  WechatHooker
//
//  Created by  zcating on 2017/10/27.
//  Copyright © 2017年 Zcating. All rights reserved.
//

#import "FunctionMenuCreater.h"

@implementation FunctionMenuCreater

+(instancetype)shared {
    static FunctionMenuCreater *creater;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        creater = [[FunctionMenuCreater alloc] init];
    });
    return creater;
}

+(void)createMenu {
    NSMenu *functionMenu = [self menu];
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"防消息撤回" action:@selector(preventRevocation:) keyEquivalent:@""];
    item.enabled = YES;
    item.hidden = NO;
    item.target = [self shared];
    item.state = [[NSUserDefaults standardUserDefaults] boolForKey:ALLOW_PREVENT_REVOCATION];
    [functionMenu addItem:item];
    
    
    item = [[NSMenuItem alloc] initWithTitle:@"打开新的微信实例" action:@selector(openNewInstance) keyEquivalent:@"n"];
    item.keyEquivalentModifierMask = NSEventModifierFlagCommand | NSEventModifierFlagShift;
    item.target = [self shared];
    [functionMenu addItem:item];
    
}


+(NSMenu *)menu {
    NSMenu *mainMenu = [[NSApplication sharedApplication] mainMenu];
    NSMenuItem *functionItem = mainMenu.itemArray.lastObject;
    if (![functionItem.title isEqualToString:@"功能"]) {
        functionItem = [[NSMenuItem alloc] initWithTitle:@"功能" action:nil keyEquivalent:@""];
        NSMenu *functionMenu = [[NSMenu alloc] initWithTitle:@"功能"];
        [functionItem setSubmenu:functionMenu];
        [mainMenu addItem:functionItem];
        return functionMenu;
    }
    return functionItem.submenu;
}

-(void)preventRevocation:(NSMenuItem *)item {
    item.state = !item.state;
    [[NSUserDefaults standardUserDefaults] setBool:item.state forKey:ALLOW_PREVENT_REVOCATION];
}

-(void)openNewInstance {
    NSString *applicationPath = [[NSBundle mainBundle] bundlePath];
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/open";
    task.arguments = @[@"-n", applicationPath];
    [task launch];
}

@end
