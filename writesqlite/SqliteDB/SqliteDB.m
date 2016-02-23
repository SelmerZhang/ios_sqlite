//
//  SqliteDB.m
//  writesqlite
//
//  Created by 大麦 on 16/2/22.
//  Copyright (c) 2016年 lsp. All rights reserved.
//

#import "SqliteDB.h"

@implementation SqliteDB

#define DBNAME    @"personinfo.sqlite"
#define NAME      @"name"
#define AGE       @"age"
#define ADDRESS   @"address"
#define TABLENAME @"PERSONINFO"


+(SqliteDB *)sharedSqliteDB
{
    static dispatch_once_t pred;
    static SqliteDB *operationQueueInstance = nil;
    dispatch_once(&pred, ^{
        operationQueueInstance = [[SqliteDB alloc] init];
    });
    
    return operationQueueInstance;
}

-(void)openDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
}
-(void)createDB
{
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)";
    [self execSql:sqlCreateTable];
}

-(void)inserDB
{
    NSString *sql1 = [NSString stringWithFormat:
                      @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
                      TABLENAME, NAME, AGE, ADDRESS, @"张三", @"23", @"西城区"];
    
    NSString *sql2 = [NSString stringWithFormat:
                      @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
                      TABLENAME, NAME, AGE, ADDRESS, @"老六", @"20", @"东城区"];
    [self execSql:sql1];
    [self execSql:sql2];
}

-(void)searchDB
{
    NSString *sqlQuery = @"SELECT * FROM PERSONINFO";
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char*)sqlite3_column_text(statement, 1);
            NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
            
            int age = sqlite3_column_int(statement, 2);
            
            char *address = (char*)sqlite3_column_text(statement, 3);
            NSString *nsAddressStr = [[NSString alloc]initWithUTF8String:address];
            
            NSLog(@"name:%@  age:%d  address:%@",nsNameStr,age, nsAddressStr);
        }
    }
    sqlite3_close(db);
}
-(NSMutableArray *)searchDBResult
{
    NSMutableArray *resultArray = [NSMutableArray array];
    [resultArray removeAllObjects];
    NSString *sqlQuery = @"SELECT * FROM PERSONINFO";
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char*)sqlite3_column_text(statement, 1);
            NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
            
            int age = sqlite3_column_int(statement, 2);
            
            char *address = (char*)sqlite3_column_text(statement, 3);
            NSString *nsAddressStr = [[NSString alloc]initWithUTF8String:address];
            
            NSLog(@"name:%@  age:%d  address:%@",nsNameStr,age, nsAddressStr);
            //
            NSString *ageString = [NSString stringWithFormat:@"%d",age];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:nsNameStr,@"name",ageString,@"age",nsAddressStr,@"address", nil];
            [resultArray addObject:dic];
        }
    }
    sqlite3_close(db);
    return resultArray;
}

-(void)deleteDB
{
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM PERSONINFO WHERE %@='%@'",NAME,@"张三"];
    [self execSql:sql];
}
-(void)deleteAll
{
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM PERSONINFO"];
    [self execSql:sql];
}

-(void)updateDB
{
    NSString *sql=[NSString stringWithFormat:@"UPDATE PERSONINFO SET %@='%d' WHERE %@='%@'",AGE,4,NAME,@"老六"];
    [self execSql:sql];
}

-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作数据失败!");
    }
}

@end
