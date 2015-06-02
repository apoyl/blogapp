//
//  lycCategory.m
//  blogapp
//
//  Created by aotuman on 13-10-28.
//  Copyright (c) 2013年 aotuman. All rights reserved.
//

#import "lycCategory.h"
#import "AFAppDotNetAPIClient.h"
@implementation lycCategory

#pragma mark 初始化类别
- (id)initWithName:(NSString *)newName andCid:(NSInteger)newCid andPid:(NSInteger)newPid{
    self=[super init];
    if (self!=nil) {
        _name=newName;
        _cid=newCid;
        _pid=newPid;
    }
    return self;
}

#pragma mark
- (id)initWithDic:(NSDictionary *)dic{
    self=[super init];
    if (self!=nil) {
        
        _name=[dic valueForKeyPath:@"name"];
        _cid=[[dic valueForKeyPath:@"term_id"] integerValue];
        _pid=[[dic valueForKeyPath:@"parent"] integerValue];
    }
    
    return self;
}

#pragma mark 使用block获取json数据
+ (void)categoryWithBlock:(void (^)(NSArray *cats, NSError *error))block{
    [[AFAppDotNetAPIClient sharedClient] getPath:api_terms_list parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArr=[responseObject valueForKeyPath:@"terms"];
        NSMutableArray *mulCats=[NSMutableArray arrayWithCapacity:[responseArr count]];
        for (NSDictionary *dic in responseArr) {
            lycCategory *cat=[[lycCategory alloc] initWithDic:dic];
            [mulCats addObject:cat];
        }
        if (block) {
            block([NSArray arrayWithArray:mulCats],nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(block){
        block([NSArray array],error);
        }
        
    }];
}




@end
