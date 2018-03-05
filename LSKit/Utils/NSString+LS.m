//
//  NSString+GW.m
//  GWBaseLib
//
//  Created by Lyson on 2017/12/22.
//  Copyright © 2017年 GWBaseLib. All rights reserved.
//

#import "NSString+LS.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LS)

/**
 *  对字符串进行MD5加密
 *
 *  @return 加密后的字符串
 */
- (NSString *) md5EncodeString{
    
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)self.length,digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02x", digest[i]];
    }

    return result;
}

- (NSString*) urlEncodedString {
    
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                          (__bridge CFStringRef) self,
                                                                          nil,
                                                                          CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "),
                                                                          kCFStringEncodingUTF8);
    
    NSString *encodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) encodedCFString];
    
    if(!encodedString)
        encodedString = @"";
    
    return encodedString;
}

- (NSString*) urlDecodedString {
    
    CFStringRef decodedCFString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                          (__bridge CFStringRef) self,
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);
    
    // We need to replace "+" with " " because the CF method above doesn't do it
    NSString *decodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) decodedCFString];
    return (!decodedString) ? @"" : [decodedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

/**
 根据文字最大高度字体大小获取宽度
 **/
- (CGFloat) widthWithFont:(UIFont *)font
{
    NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
    CGRect rect=[self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil];
    return rect.size.width;
}

/**
 根据文字宽度及字体大小获取高度
 **/
- (CGFloat) heightWithFont:(UIFont *)font maxWith:(CGFloat)width
{
    CGSize rtSize;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    rtSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return ceil(rtSize.height) + 0.5;
}

/**
 获取一个处理后的字符串NSAttributedString
 **/
- (NSAttributedString *)scaleStringWithRange:(NSRange)range font:(UIFont*)font color:(UIColor*)color{
    
    NSMutableAttributedString *modifyStr = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSMutableDictionary *stringDict = [NSMutableDictionary dictionary];
    [stringDict setValue:color forKey:NSForegroundColorAttributeName];
    [stringDict setValue:font forKey:NSFontAttributeName];
    [modifyStr setAttributes:stringDict range:range];
    
    return modifyStr;
}


/**
 *  判断字符串是否为空
 *
 *  @return YES 空 NO 非空
 */
+(BOOL)isEmpty:(NSString*)text{
    
    if ([text isKindOfClass:[NSNull class]] || text == nil  || text.length <=0) {
        
        return YES;
    }
    
    return NO;
}

/**
 *  获取随机数
 *
 *  from :随机的起始
 *  to :终点数
 *  返回一个随机数
 */
+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from + 1)));
}


@end
