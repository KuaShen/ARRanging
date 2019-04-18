//
//  RALine.h
//  ARRanging_Example
//
//  Created by mac on 2019/3/29.
//  Copyright © 2019 KuaShen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LengthUnit) {
    meter,
    cenitMeter,
    inch,
};

@interface RALine : NSObject

//初始化线条
- (instancetype)initWithView:(ARSCNView *)scnView andStartVetor:(SCNVector3)vetor andUnit:(LengthUnit)unit API_AVAILABLE(ios(11.0));

//更新线条信息
- (void)updateToVector:(SCNVector3)vector;

//两点之间的距离
- (NSString *)distanceToVector:(SCNVector3)vector;

//移除
- (void)remove;

@end

NS_ASSUME_NONNULL_END
