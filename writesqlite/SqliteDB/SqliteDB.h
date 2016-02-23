//
//  SqliteDB.h
//  writesqlite
//
//  Created by 大麦 on 16/2/22.
//  Copyright (c) 2016年 lsp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface SqliteDB : NSObject
{
    sqlite3 *db;
}
+(SqliteDB *)sharedSqliteDB;

-(void)openDB;

-(void)createDB;

-(void)inserDB;

-(void)searchDB;
-(NSMutableArray *)searchDBResult;

-(void)deleteDB;
-(void)deleteAll;

-(void)updateDB;

-(void)execSql:(NSString *)sql;


@end
