//
//  Person.h
//  sqlite演练
//
//  Created by lw on 15/9/9.
//  Copyright © 2015年 lw. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SQLPerson : NSObject

@property (nonatomic,assign) int id;
@property (nonatomic,assign) int age;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) double height;
@property (nonatomic,copy) NSString *title;
-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)personWithDict:(NSDictionary *)dict;
-(BOOL)insertPerson;
-(BOOL)updatePerson;
-(BOOL)deletePerson;
-(NSArray *)selectPerson;
@end
