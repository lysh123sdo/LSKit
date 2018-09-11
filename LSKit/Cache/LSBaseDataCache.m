//
//  QTDataCache.m
//  QuotData
//
//  Created by Lyson on 2018/1/3.
//  Copyright © 2018年 QuotData. All rights reserved.
//

#import "LSBaseDataCache.h"
//#import <YYCache.h>
#import <YYKit/YYCache.h>
#import <YYKit/YYMemoryCache.h>
@interface LSBaseDataCache()

@property (nonatomic , strong) YYCache *yCache;

@end

@implementation LSBaseDataCache

#define GWCacheKey @"com.gw.plugin.cache"

static LSBaseDataCache *_cache;
static dispatch_once_t _onceToken;

+(void)deallocInstance{
  
    [_cache removeAllMemoryCache];
    
    _cache = nil;
    _onceToken = 0l;
    
}

+(instancetype)shareInstance{
    
    dispatch_once(&_onceToken, ^{
        
        _cache = [self new];
    });
    
    return _cache;
}

-(instancetype)init{
    
    if(self = [super init]){
    
        self.yCache = [YYCache cacheWithName:[self cacheKey]];
        self.yCache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        [self initEvent];
    }
    return self;
}

-(void)initEvent{
    
    
    
}

-(NSString*)cacheKey{
    
    return GWCacheKey;
}

- (BOOL)containsObjectForKey:(id)key{
    
    return [_yCache containsObjectForKey:key];
}

- (id)objectForKey:(id)key{
    
    return [_yCache objectForKey:key];
}

- (void)setObject:(nullable id)object forKey:(id)key{
    
    [_yCache setObject:object forKey:key];
    [self sendSignalWith:key value:object];
}

-(void)removeObjectForKey:(id)key{
    
    [_yCache removeObjectForKey:key];
    [self sendSignalWith:key value:nil];
}

- (BOOL)containsObjectInMemoryForKey:(id)key{
    
    return [_yCache.memoryCache containsObjectForKey:key];
}

- (id)objectInMemoryForKey:(id)key{
    
    id obj = [_yCache.memoryCache objectForKey:key];
    return obj;
}

- (void)setObjectInMemory:(nullable id)object forKey:(id)key{

    [_yCache.memoryCache setObject:object forKey:key];
    [self sendSignalWith:key value:object];
}

-(void)removeObjectInMemoryForKey:(id)key{
    
    [_yCache.memoryCache removeObjectForKey:key];
    [self sendSignalWith:key value:nil];
    
}

-(void)removeAllCache{
    
    [self.yCache removeAllObjects];
}

-(void)removeDiskCache{
    
    [self.yCache removeAllObjects];
}

-(void)removeAllMemoryCache{
    
    [self.yCache.memoryCache removeAllObjects];
}
@end
