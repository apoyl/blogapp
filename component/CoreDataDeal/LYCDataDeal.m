//
//  LYCDataDeal.m
//  FailedBankCD
//
//  Created by aotuman on 13-11-21.
//  Copyright (c) 2013年 Adam Burkepile. All rights reserved.
//

#import "lycDataDeal.h"

@implementation LYCDataDeal

static id dataDeal;
+(id)defaultCenter{
    @synchronized(self) {
        if (nil==dataDeal) {
            dataDeal=[[self alloc] init];
        }
    }
    return dataDeal;
}

-(void) addRowData:(NSString *)entity withFields:(NSDictionary *)fields{
    __block id tab=[self entity:entity];
    
    [fields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [tab setValue:obj forKey:key];
    }];
  
   
}
#pragma mark 添加一个数据对象 到数据库 fields k=>v 字段明=>值
-(BOOL)addRowDataToDB:(NSString *)entity withFields:(NSDictionary *)fields{
     [self addRowData:entity withFields:fields];
     return [self saveDB];
}
#pragma mark 添加多个数据对象 到数据库里
-(BOOL) addMultiRowDataWithModelNameAndsFieldsToDB:(id)firstobj,... {
    id eobj;
    va_list argslist;
    if (firstobj) {
        va_start(argslist, firstobj);
        NSInteger i=1;
        NSString *tempModel;
        while ((eobj=va_arg(argslist, id))) {
            if (i==1) {
                [self addRowData:firstobj withFields:eobj];
            }else if(i%2==0){
                tempModel=eobj;
            }else if(i%2==1){
                [self addRowData:tempModel withFields:eobj];
            }
            va_end(argslist);
            i++;
        }
    }
    return [self saveDB];
}

#pragma mark 查询数据 contains
-(NSArray *) fetchSearchData:(NSString *)entity predicateWithLikeKey:(NSString *)key predicateWithLikeValue:(NSString *)value withCurrentPage:(NSInteger)currentPage withLimit:(NSInteger)nums{
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *tab=[NSEntityDescription entityForName:entity inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:tab];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"%K contains[cd] %@",key,value];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:nums];
    [fetchRequest setFetchOffset:nums*currentPage];
   
    NSError *error;
    NSArray *arr=[_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return arr;
}
#pragma mark 分页查询
-(NSArray *) fetchMultiRowData:(NSString *)entity withSortField:(NSString *)fieldname withAscending:(BOOL)y  withCurrentPage:(NSInteger)currentPage withLimit:(NSInteger)nums{
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
   
    NSEntityDescription  *tab=[NSEntityDescription entityForName:entity inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:tab];
  
    NSSortDescriptor *sortDescriptor=[[NSSortDescriptor alloc] initWithKey:fieldname ascending:y];
    NSArray *sortArray=[[NSArray alloc] initWithObjects:sortDescriptor, nil];
    //排序
    [fetchRequest setSortDescriptors:sortArray];
 
    //条数
    [fetchRequest setFetchLimit:nums];
    //偏移量
    [fetchRequest setFetchOffset:nums*currentPage];
//    if ([arrFetch count]>0) {
//        //指定查询的字段
//        [fetchRequest setPropertiesToFetch:arrFetch];
//    }
    NSError *error;
    NSArray *reArr=[_managedObjectContext executeFetchRequest:fetchRequest error:&error];
 
    return reArr;
}
#pragma mark 删除一条数据
-(BOOL) deleteRowData:(id)entity{
    [_managedObjectContext deleteObject:entity];
    return [self saveDB];
}

#pragma mark 修改一条数据
-(BOOL) updateRowData:(id)entity withFields:(NSDictionary *)fields{
    __block id o=entity;
    [fields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [o setValue:obj forKey:key];
        
    }];
    return [self saveDB];
}
#pragma mark 保存到数据库文件里
-(BOOL) saveDB{
    NSError *error;
    if (![_managedObjectContext save:&error]) {
        return FALSE;
    }
    return TRUE;
}

#pragma mark 返回添加实体对象
-(id) entity:(NSString *)entity{
    return [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:_managedObjectContext];
}


#pragma mark --原有的
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FailedBankCD" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"test3.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
