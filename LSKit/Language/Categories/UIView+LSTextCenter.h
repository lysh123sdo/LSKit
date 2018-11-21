//
//  UIView+LSTextCenter.h
//  iOS_Label
//
//  Created by Yvan.Peng on 2018/4/13.
//

#import <UIKit/UIKit.h>


/**
 <tab>核心类.当UIView(或者它的子类)将要显示到Window上时,系统会调用[willMoveToWindow:].此时,[lstext_callStoreMethodNow]方法会hook在[willMoveToWindow:]方法上,并且先调用.UIView的子类会在[lstext_callStoreMethodNow]方法中通过key查找文本,并且赋值给相应属性.
 */
@interface UIView (LSTextCenter)
/// 子类需要在该方法中实现key查找文本并赋值给相应属性的功能
- (void)lstext_callStoreMethodNow;
/// 当前对象所持有的语言信息
@property (nonatomic, copy) NSString *currentLanguage_lsText;
@end
