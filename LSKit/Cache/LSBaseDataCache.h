//
//  QTDataCache.h
//  QuotData
//
//  Created by Lyson on 2018/1/3.
//  Copyright © 2018年 QuotData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBaseDataChangeBus.h"





/**
 缓存处理 基于YYCache
 */
@interface LSBaseDataCache : LSBaseDataChangeBus


/**
 注销实例
 */
+(void)deallocInstance;

/**
 获取缓存实例

 @return 实例
 */
+(instancetype _Nullable )shareInstance;


///从磁盘或者内存中获取
- (id _Nonnull )objectForKey:(id _Nullable )key;
///存储到磁盘或者内存中
- (void)setObject:(nullable id)object forKey:(id _Nullable )key;
///移除存储
-(void)removeObjectForKey:(id _Nullable )key;
///移除内存中的缓存
-(void)removeObjectInMemoryForKey:(id _Nullable )key;
///设置缓存到内存中
- (void)setObjectInMemory:(nullable id)object forKey:(id _Nullable )key;
///从内存中获取
- (id _Nullable )objectInMemoryForKey:(id _Nonnull)key;
///缓存存储key -对应到沙盒中的文件夹名
-(NSString*_Nullable)cacheKey;
///移除啥么中的缓存
-(void)removeDiskCache;
///移除所有的缓存
-(void)removeAllCache;
///移除所有内存中的缓存
-(void)removeAllMemoryCache;

@end
