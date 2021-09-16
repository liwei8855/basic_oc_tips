//
//  SQLiteManager.h
//  sqlite演练
//
//  Created by lw on 15/9/8.
//  Copyright © 2015年 lw. All rights reserved.
//

#import <Foundation/Foundation.h>

//sqlite管理器
@interface SQLiteManager : NSObject

+(instancetype)sharedManager;
-(void)openDB:(NSString *)dbName;
-(BOOL)exeSQL:(NSString *)sql;
-(int)insertTable:(NSString *)sql;
-(NSMutableArray *)exeRecordSet:(NSString *)sql;
@end
