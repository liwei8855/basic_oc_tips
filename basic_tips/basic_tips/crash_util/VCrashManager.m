//
//  VCrashManager.m
//  basic_tips
//
//  Created by 李威 on 2022/3/3.
//

#import "VCrashManager.h"
#import "Swizzle.h"

@implementation VCrashManager

+ (instancetype)manager {
    static dispatch_once_t token;
    static VCrashManager *manager;
    dispatch_once(&token, ^{
        manager = [VCrashManager new];
    });
    return manager;
}

- (void)configCrashGuardService:(GuardType)guardType {
    if (![self isEnableCrashGuard]) {
        return;
    }
    //容器
    if (guardType & GuardTypeContainer) {
        [self setupGuardContainer];
    }
    
}

- (void)setupGuardContainer {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    
    NSArray *array0 = [NSArray array];
    NSArray *singleObjectArrayI = @[@1];
    NSArray *arrayI = @[@1,@2];
    
    [array0.class swizzleMethod:@selector(objectAtIndex:) newMethod:@selector(safeArray0ObjectAtIndex:) isClassMethod:NO];
    [singleObjectArrayI.class swizzleMethod:@selector(objectAtIndex:) newMethod:@selector(safeSingleArrayObjectAtIndex:) isClassMethod:NO];
    
    [arrayI.class swizzleMethod:@selector(objectAtIndex:) newMethod:@selector(safeObjectAtIndex:) isClassMethod:NO];
    [arrayI.class swizzleMethod:@selector(arrayWithObjects:count:) newMethod:@selector(safeArrayWithObjects:count:) isClassMethod:YES];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    [arrayM.class swizzleMethod:@selector(insertObject:atIndex:) newMethod:@selector(safeInsertObject:atIndex:) isClassMethod:NO];
    [arrayM.class swizzleMethod:@selector(addObject:) newMethod:@selector(safeAddObject:) isClassMethod:NO];
    [arrayM.class swizzleMethod:@selector(removeObjectAtIndex:) newMethod:@selector(safeRemoveObjectAtIndex:) isClassMethod:NO];
    [arrayM.class swizzleMethod:@selector(replaceObjectAtIndex:withObject:) newMethod:@selector(safeReplaceObjectAtIndex:withObject:) isClassMethod:NO];
    
    NSMutableDictionary *dictionaryM = [NSMutableDictionary dictionary];
    [dictionaryM.class swizzleMethod:@selector(setObject:forKey:) newMethod:@selector(safeSetObject:forKey:) isClassMethod:NO];
    [dictionaryM.class swizzleMethod:@selector(removeObjectForKey:) newMethod:@selector(safeRemoveObjectForKey:) isClassMethod:NO];
    
    [NSCache swizzleMethod:@selector(setObject:forKey:) newMethod:@selector(safeSetObject:forKey:) isClassMethod:NO];
    [NSCache swizzleMethod:@selector(setObject:forKey:cost:) newMethod:@selector(safeSetObject:forKey:cost:) isClassMethod:NO];
    
#pragma clang diagnostic pop
}

- (BOOL)isEnableCrashGuard {
    return YES;
}
@end
