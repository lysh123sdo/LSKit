//
//  NSString+GW.h
//  GWBaseLib
//
//  Created by Lyson on 2017/12/22.
//  Copyright © 2017年 GWBaseLib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (LS)

+(void)test;

/**
 *  对字符串进行MD5加密
 *
 *  @return 加密后的字符串
 */
- (NSString *) md5EncodeString;

- (NSString *) urlEncodedString;

- (NSString *) urlDecodedString;

/**
 根据文字宽度及字体大小获取高度
 **/
- (CGFloat) heightWithFont:(UIFont *)font maxWith:(CGFloat)width;

/**
 根据文字字体大小获取宽度
 **/
- (CGFloat) widthWithFont:(UIFont *)font;

/**
 获取一个处理后的字符串NSAttributedString
 **/
- (NSAttributedString *)scaleStringWithRange:(NSRange)range font:(UIFont*)font color:(UIColor*)color;

/**
 *  判断字符串是否为空
 *
 *  @return YES 空 NO 非空
 */
+ (BOOL) isEmpty:(NSString*)text;

/**
 *  获取随机数
 *
 *  from :随机的起始
 *  to :终点数
 *  返回一个随机数
 */
+ (int) getRandomNumber:(int)from to:(int)to;



@end
