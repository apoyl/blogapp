//
//  lycNews.m
//  blogapp
//
//  Created by aotuman on 13-10-28.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import "lycNews.h"
#import "AFAppDotNetAPIClient.h"

@implementation lycNews
#pragma mark  初始标题列表
- (id)initWithList:(NSUInteger)newid
                andTitle:(NSString *)newTitle
                andNewtype:(NSUInteger)newtype
                andImg:(NSString *)newImg
                andPubtime:(NSString *)newPubtime{
    self=[super init];
    if (self!=nil) {
        _newid=newid;
        _title=newTitle;
        _newtype=newtype;
        _img=newImg;
        _pubtime=newPubtime;
        
    }
    return self;
}
#pragma mark 初始单个信息
- (id)initWithId:(NSUInteger)newid
            andTitle:(NSString *)newTitle
            andNewtype:(NSUInteger)newType
            andMsgs:(NSString *)newMsgs
            andAuthor:(NSString *)newAuthor
            andViewnums:(NSUInteger)newViewnums
            andCommitnums:(NSUInteger)newCommitnums
            andPubtime:(NSString *)newPubtime{
    self=[super init];
    if (self!=nil) {
        _newid=newid;
        _title=newTitle;
        _newtype=newType;
        _msgs=newMsgs;
        _author=newAuthor;
        _viewnums=newViewnums;
        _commitnums=newCommitnums;
        _pubtime=newPubtime;
    }
    return self;
    
}
- (id)initWithDic:(NSDictionary *)dic{
    self=[super init];
    if (self) {
        _newid=[[dic valueForKeyPath:@"ID"] integerValue];
        _title=[dic valueForKeyPath:@"post_title"];
         _desc=[dic valueForKeyPath:@"post_excerpt"];
        _msgs=[dic valueForKeyPath:@"post_content"];
        _commitnums=[[dic valueForKeyPath:@"comment_count"] integerValue];
        _pubtime=[dic valueForKeyPath:@"post_date"];
    }
    return self;
}

#pragma mark 使用block获取json数据
+(void) newsWithCid:(NSUInteger) cid withPage:(NSUInteger)p withBlock:(void (^)(NSArray *cats, NSError *error))block {
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInteger:cid],@"cid",[NSNumber numberWithUnsignedInteger:p],@"p",nil];
    
    [[AFAppDotNetAPIClient sharedClient] getPath:api_terms_cat parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *responseArr=[responseObject valueForKeyPath:@"terms"];
        NSMutableArray *mulArrs=[NSMutableArray arrayWithCapacity:[responseArr count]];
        
        if (responseArr.count>0) {
        
            for (NSDictionary *dic in responseArr) {
                lycNews *cat=[[lycNews alloc] initWithDic:dic];
                [mulArrs addObject:cat];
                }
           
        }
        
        if (block) {
            block([NSArray arrayWithArray:mulArrs],nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block([NSArray array],error);
        }
        
    }];
}

+ (void)newsWithId:(NSUInteger)newid withBlock:(void (^)(NSArray *news, NSError *error))block{
    NSDictionary *param=[NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInteger:newid] forKey:@"id"];
    [[AFAppDotNetAPIClient sharedClient] getPath:api_posts_detail parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArr=[responseObject valueForKey:@"posts"];
        NSMutableArray *mulArrs=[NSMutableArray arrayWithCapacity:[responseArr count]];
        if (responseArr.count>0) {
            
            for (NSDictionary *dic in responseArr) {
                lycNews *cat=[[lycNews alloc] initWithDic:dic];
                [mulArrs addObject:cat];
            }
            
        }
        
        if (block) {
            block([NSArray arrayWithArray:mulArrs],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
            block([NSArray array],error);
        }
    }];
}
@end
