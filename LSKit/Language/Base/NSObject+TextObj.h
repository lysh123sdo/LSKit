//
//  NSObject+TextObj.h
//  TestProj
//
//  Created by Lyson on 2018/7/16.
//  Copyright © 2018年 TestProj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSBundle+LS.h"
@interface NSObject (TextObj)

- (void)setAssociateValue:(id)value withKey:(void *)key;

- (id)getAssociatedValueForKey:(void *)key;

+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;


@end
