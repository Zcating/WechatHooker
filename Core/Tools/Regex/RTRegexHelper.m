//
//  RTRegexHelper.m
//  WechatHooker
//
//  Created by  zcating on 2017/10/26.
//  Copyright © 2017年 Zcating. All rights reserved.
//

#import "RTRegexHelper.h"



@implementation RTRegexHelper


/// <sysmsg type="revokemsg"><revokemsg><session>wxid_qdxmce84ueno12</session><msgid>1656418240</msgid><newmsgid>8250926699869451612</newmsgid><replacemsg><![CDATA["sunhay" 撤回了一条消息]]></replacemsg></revokemsg></sysmsg>
+(NSString *)matchXMLTag:(NSString *)tag inXMLText:(NSString *)text {
    id tagRegex = [NSString stringWithFormat:@"<%@[a-zA-Z =\"]*>.*<\\/%@>", tag, tag];
    id startRegex = [NSString stringWithFormat:@"<%@>", tag];
    id endRegex = [NSString stringWithFormat:@"<\\/%@>", tag];
    id targetXML = [self matchFirst:text regex:tagRegex];
    id startXML = [self matchFirst:text regex:startRegex];
    id endXML = [self matchFirst:text regex:endRegex];
    return [[targetXML stringByReplacingOccurrencesOfString:startXML withString:@""] stringByReplacingOccurrencesOfString:endXML withString:@""];
    
}


+(NSString *)getChatContent:(NSString *)text {
    NSRange begin = [text rangeOfString:@"CDATA["];
    NSRange end = [text rangeOfString:@"]]"];
    NSRange subRange = NSMakeRange(begin.location + begin.length,end.location - begin.location - begin.length);
    return [text substringWithRange:subRange];
}


+(NSString *)matchFirst:(NSString *)text regex:(NSString *)regex {
    NSUInteger options = NSRegularExpressionCaseInsensitive |NSRegularExpressionDotMatchesLineSeparators;
    NSRange textRange = NSMakeRange(0, [text length]);
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    
    NSTextCheckingResult *result = [expression firstMatchInString:text options:NSMatchingReportCompletion range:textRange];
    
    return [text substringWithRange:[result range]];
}

@end
