//
//  SQLiteManager.m
//  sqlite演练
//
//  Created by lw on 15/9/8.
//  Copyright © 2015年 lw. All rights reserved.
//

#import "SQLiteManager.h"
#import <sqlite3.h>

@implementation SQLiteManager

//    全局的数据库‘句柄’ ，指向结构体的指针
sqlite3 *db;


//执行sql返回结果
-(NSMutableArray *)exeRecordSet:(NSString *)sql{
/*
    /// 准备sql 预编译sql
    /// @param db#>    : <#db#> 数据库句柄
    /// @param zSql#>  : <#zSql#> 执行的sql语句
    /// @param nByte#> : <#nByte#> sql语句字节的长度 但是传入－1能够自动计算其长度
    /// @param ppStmt#>: <#ppStmt#> stmt 语句的指针，后续的查找操作，全部依赖这个指针 相当于预编译好的sql，需要“释放”
    /// @param pzTail#>: <#pzTail#> 尾部参数，通常nil
*/
 //定义语句的指针
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) != SQLITE_OK) {
        NSLog(@"sql语句错误");
        return nil;
    }
    NSLog(@"sql语句正确");
    NSMutableArray *recordSet = [self selectResults:stmt];
//释放stmt
    sqlite3_finalize(stmt);
    return recordSet;    
}
-(NSMutableArray *)selectResults:(sqlite3_stmt *)stmt{
    
//创建数组存储每一条记录
    NSMutableArray *recordSet = [NSMutableArray array];
//sqlite3_step 单步执行sql 每调用一次，就获得一个结果
//SQLITE_ROW表示获得一条记录
    while (sqlite3_step(stmt) == SQLITE_ROW) {
//再继续操作就是针对‘行’ 一条记录，每条记录应该有多个字段
        //1.每一行有多少个字段 －－列
        int column = sqlite3_column_count(stmt);
        //设置一个字典纪录每一条记录的完整内容
        NSMutableDictionary *oneRecord = [NSMutableDictionary dictionary];
        //2.知道每一列的名字以及内容
        for (int i=0; i < column; i++) {
            //          字段名
            const char *cname = sqlite3_column_name(stmt, i);
            NSString *name = [NSString stringWithUTF8String:cname];
            
            //          每一列的数据类型
            int type = sqlite3_column_type(stmt, i);
            //          根据类型获取数值
            if (type == SQLITE_INTEGER) {
                int value = (int)sqlite3_column_int64(stmt, i);
                [oneRecord setValue:@(value) forKey:name];
            }else if (type == SQLITE_FLOAT){
                float value = sqlite3_column_double(stmt, i);
                [oneRecord setValue:[NSString stringWithFormat:@"%f",value] forKey:name];
            }else if (type == SQLITE3_TEXT){
                const unsigned char *cvalue = sqlite3_column_text(stmt, i);
                NSString *value = [NSString stringWithUTF8String:(char *)cvalue];
                [oneRecord setValue:value forKey:name];
            }else if (type == SQLITE_NULL){
                NSNull *value = [NSNull null];
                [oneRecord setValue:value forKey:name];
            }else{
                NSLog(@"不支持的类型");
            }
        }
        [recordSet addObject:oneRecord];
    }
    return recordSet;
}


//插入数据后返回id 对于自动增长的id有效
-(int)insertTable:(NSString *)sql{
    //sqlite3_exec(db, [sql UTF8String], nil, nil, nil)
    if ( [self exeSQL:sql]) {
        return (int)sqlite3_last_insert_rowid(db);
    }else{
        return -1;
    }
}

//打开数据库
-(void)openDB:(NSString *)dbName{
    
    //    数据库沙盒路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
    /// @param filename#>: <#filename#> 数据库完整路径
    /// @param ppDb#>    : <#ppDb#> 数据库句柄
    ///
    /// 如果数据库存在直接打开，如果不存在 新建打开
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return;
    }else{
        NSLog(@"%@",path);
        if ([self creatTable]) {
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
        }
        NSLog(@"打开数据库成功");
    }
}

//创建表IF NOT EXISTS
-(BOOL)creatTable{

    NSString *sql = @"CREATE TABLE \"T_person\" (\"id\" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,\"name\" TEXT,\"age\" INTEGER,\"height\" REAL,\"title\" TEXT)";
    
    return [self exeSQL:sql];
}

//执行SQL
-(BOOL)exeSQL:(NSString *)sql{
    /*
     1.db全局句柄
     2.要执行的sql
     3.callback 执行完sql完毕回调的函数，通常nil
     4.第三个参数回调函数的第一个参数的地址，通常nil
     5.错误信息字符串的地址，通常不需要
     */
    return  (sqlite3_exec(db, [sql UTF8String], nil, nil, nil) == SQLITE_OK);
   
}


//设置数据库管理单例
+(instancetype)sharedManager{

    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

@end
