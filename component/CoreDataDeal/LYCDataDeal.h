//
//  LYCDataDeal.h
//  FailedBankCD
//
//  Created by aotuman on 13-11-21.
//  Copyright (c) 2013年 Adam Burkepile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYCDataDeal : NSObject
@property (strong,nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(id) defaultCenter;
#pragma mark 添加一个数据对象 到DB
-(BOOL) addRowDataToDB:(NSString *)entity withFields:(NSDictionary *)fields;
#pragma mark 添加多个数据对象 到DB
-(BOOL) addMultiRowDataWithModelNameAndsFieldsToDB:(id)firstobj,... NS_REQUIRES_NIL_TERMINATION;
#pragma mark 查询数据 contains
-(NSArray *) fetchSearchData:(NSString *)entity predicateWithLikeKey:(NSString *)key predicateWithLikeValue:(NSString *)value withCurrentPage:(NSInteger)currentPage withLimit:(NSInteger)nums;
#pragma mark 分页查询 多行数据
-(NSArray *) fetchMultiRowData:(NSString *)entity withSortField:(NSString *)fieldname withAscending:(BOOL)y  withCurrentPage:(NSInteger)currentPage withLimit:(NSInteger)nums;
#pragma mark 删除一条数据
-(BOOL) deleteRowData:(id)entity;
#pragma mark 修改一条数据
-(BOOL) updateRowData:(id)entity withFields:(NSDictionary *)fields;

#pragma mark 返回实体对象
-(id) entity:(NSString *)entity;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
