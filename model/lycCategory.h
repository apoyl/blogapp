//
//  lycCategory.h
//  blogapp
//
//  Created by aotuman on 13-10-28.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lycCategory : NSObject
//分类id
@property (assign,nonatomic) NSInteger cid;
//父类
@property (assign,nonatomic) NSInteger pid;
//类别名
@property (strong,nonatomic) NSString *name;

#pragma mark 初始化类别
- (id)initWithName:(NSString *)newName andCid:(NSInteger)newCid andPid:(NSInteger)newPid;

#pragma mark 使用block获取json数据
+ (void)categoryWithBlock:(void(^)(NSArray *cats,NSError *error))block;
@end
