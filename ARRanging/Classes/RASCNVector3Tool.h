//
//  RASCNVector3Tool.h
//  ARRanging_Example
//
//  Created by mac on 2019/4/16.
//  Copyright © 2019 KuaShen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ARKit/ARKit.h>
#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RASCNVector3Tool : NSObject
//将相机世界坐标的x,y,z轴值转换并回传出去
+ (SCNVector3)positionTranform:(matrix_float4x4)tranform;

//转换平面坐标
+ (SCNVector3)positionExtent:(vector_float3)extent;

//计算三维坐标系中两点间的距离
+ (CGFloat)distanceWithVector:(SCNVector3)vector StartVector:(SCNVector3)startVector;

//对比两个SCNVector3
+ (BOOL)isEqualBothSCNVector3WithLeft:(SCNVector3)leftVector Right:(SCNVector3)rightVector;

//在两个点之间划线
+ (SCNNode *)drawLineWithVector:(SCNVector3)vector StartVector:(SCNVector3)startVector;

//文字位置放在center
+ (SCNVector3)computTextPostionWithVector:(SCNVector3)vector StartVector:(SCNVector3)startVector;

@end

NS_ASSUME_NONNULL_END
