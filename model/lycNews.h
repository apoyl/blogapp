//
//  lycNews.h
//  blogapp
//
//  Created by aotuman on 13-10-28.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lycNews : NSObject
//id
@property (assign,nonatomic) NSUInteger newid;
//信息类型
@property (assign,nonatomic) NSUInteger newtype;
//标题
@property (strong,nonatomic) NSString *title;
//标题图片
@property (strong,nonatomic) NSString *img;
//简要
@property (strong,nonatomic) NSString *desc;
//内容
@property (strong,nonatomic) NSString *msgs;
//信息发布时间
@property (strong,nonatomic) NSString *pubtime;
//发布作者
@property (strong,nonatomic) NSString *author;
//游览次数
@property (assign,nonatomic) NSUInteger viewnums;
//评论次数
@property (assign,nonatomic) NSUInteger commitnums;


#pragma mark  初始标题列表
- (id)initWithList:(NSUInteger)newid
            andTitle:(NSString *)newTitle
            andNewtype:(NSUInteger)newtype
            andImg:(NSString *)newImg
            andPubtime:(NSString *)newPubtime;
#pragma mark 初始单个信息
- (id)initWithId:(NSUInteger)newid
            andTitle:(NSString *)newTitle
            andNewtype:(NSUInteger)newsType
            andMsgs:(NSString *)newMsgs
            andAuthor:(NSString *)newAuthor
            andViewnums:(NSUInteger)newViewnums
            andCommitnums:(NSUInteger)newCommitnums
            andPubtime:(NSString *)newPubtime;

#pragma mark 返回数据设置
- (id)initWithDic:(NSDictionary *)dic;
#pragma mark 某一个分类信息列表
+ (void) newsWithCid:(NSUInteger) cid withPage:(NSUInteger)p withBlock:(void (^)(NSArray *cats, NSError *error))block;
#pragma mark
+ (void)newsWithId:(NSUInteger)newid withBlock:(void (^)(NSArray *news, NSError *error))block;
@end
