//
//  MutableWechatMgr.m
//  WechatHooker
//
//  Created by  zcating on 2017/10/27.
//  Copyright © 2017年 Zcating. All rights reserved.
//

#import "MutableWechatMgr.h"

@implementation MutableWechatMgr

+ (void)hook {
    [RTCUtility aspect_hookSelector:NSSelectorFromString(@"HasWechatInstance") withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info) {
        [self hasWechatInstance];
    } error:nil];
    
    [RTAppDelegate aspect_hookSelector:@selector(applicationDidFinishLaunching:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
        NSMenu *mainMenu = [[NSApplication sharedApplication] mainMenu];
        
        NSMenu *functionMenu = [[NSMenu alloc] initWithTitle:@"功能"];
        NSMenuItem *functionItem = [[NSMenuItem alloc] initWithTitle:@"功能" action:nil keyEquivalent:@""];
        [functionItem setSubmenu:functionMenu];
        [mainMenu addItem:functionItem];
        [mainMenu removeAllItems];
        NSMenu *appMenu = [[mainMenu itemAtIndex:0] submenu];
        for (NSMenuItem *item in [appMenu itemArray]) {
            NSLog(@"%@", [item title]);
        }
    } error:nil];
    
    class_addMethod(RTAppDelegate, @selector(applicationDockMenu:), method_getImplementation(class_getInstanceMethod(RTAppDelegate, @selector(applicationDockMenu:))), "@:@");
}

+ (BOOL)hasWechatInstance {
    return NO;
}

- (NSMenu *)applicationDockMenu:(NSApplication *)sender {
    NSMenu *menu = [[NSMenu alloc] init];
    NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"登录新的微信账号" action:@selector(openNewWeChatInstance:) keyEquivalent:@""];
    [menu insertItem:menuItem atIndex:0];
    return menu;
}

- (void)openNewWeChatInstance:(id)sender {
    NSString *applicationPath = [[NSBundle mainBundle] bundlePath];
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/open";
    task.arguments = @[@"-n", applicationPath];
    [task launch];
}


@end
