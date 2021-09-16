//
//  Person.m
//  sqlite演练
//
//  Created by lw on 15/9/9.
//  Copyright © 2015年 lw. All rights reserved.
//

#import "SQLPerson.h"
#import "SQLiteManager.h"

@implementation SQLPerson

//查询数据
-(NSArray *)selectPerson{

    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM T_person LIMIT 20"];
    NSArray *array = [[SQLiteManager sharedManager]exeRecordSet:sql];
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        SQLPerson *p = [SQLPerson personWithDict:dict];
        [temp addObject:p];
    }
    return temp;
}
//删除数据
-(BOOL)deletePerson{

    NSString *sql = [NSString stringWithFormat:@"DELETE FROM T_Person WHERE id = '%d'",self.id];
    return [[SQLiteManager sharedManager] exeSQL:sql];
}
//更新数据
-(BOOL)updatePerson{
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE T_Person SET name = '%@',age = '%d',height = '%f',title = '%@' WHERE id = '%d'",self.name,self.age,self.height,self.title,self.id];
    return [[SQLiteManager sharedManager] exeSQL:sql];
}

//插入数据
-(BOOL)insertPerson{

    NSString *sql = [NSString stringWithFormat:@"INSERT INTO T_person (name, age, height, title) VALUES ('%@','%d','%f','%@')",self.name,self.age,self.height,self.title];
    
//    执行完成后，需要知道id 否则无法更新模型数据
    self.id = [[SQLiteManager sharedManager] insertTable:sql];
//    NSLog(@"%d",value);
    
    return self.id > 0 ? true : false;
}
-(NSString *)description{

    NSString *str = [NSString stringWithFormat:@"%d %@ %d %f %@",self.id,self.name,self.age,self.height,self.title];
    return str;
}

-(instancetype)initWithDict:(NSDictionary *)dict{

    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)personWithDict:(NSDictionary *)dict{

    return [[self alloc]initWithDict:dict];
}
@end
