//
//  RTRegexHelper.h
//  WechatHooker
//
//  Created by  zcating on 2017/10/26.
//  Copyright © 2017年 Zcating. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTRegexHelper : NSObject

+(NSString *)matchXMLTag:(NSString *)tag inXMLText:(NSString *)text;

+(NSString *)getChatContent:(NSString *)text;

@end
