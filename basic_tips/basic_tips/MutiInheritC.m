//
//  MutiInheritC.m
//  demo
//
//  Created by 李威 on 2021/9/16.
//  Copyright © 2021 lee. All rights reserved.
//

#import "MutiInheritC.h"
#import "MutiInheritProtocol.h"
#import "MutiInheritA.h"
#import "MutiInheritB.h"

@interface MutiInheritC()<MutiInheritAProtocol,MutiInheritBProtocol>
@property (nonatomic, strong) MutiInheritA *muA;
@property (nonatomic, strong) MutiInheritB *muB;
@end

@implementation MutiInheritC

//- (void)goToSchool {
//
//}
//
//- (void)goHome {
//
//}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.muA respondsToSelector:aSelector]) {
        return self.muA;
    } else if ([self.muB respondsToSelector:aSelector]){
        return self.muB;
    }
    return self;
}

- (MutiInheritA *)muA {
    if (!_muA) {
        _muA = [MutiInheritA new];
    }
    return _muA;
}

- (MutiInheritB *)muB {
    if (!_muB) {
        _muB = [MutiInheritB new];
    }
    return _muB;
}

@end
