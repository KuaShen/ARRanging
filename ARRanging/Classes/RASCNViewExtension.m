//
//  RASCNViewExtension.m
//  ARRanging_Example
//
//  Created by mac on 2019/4/17.
//  Copyright © 2019 KuaShen. All rights reserved.
//

#import "RASCNViewExtension.h"
#import "RASCNVector3Tool.h"

@implementation RASCNViewExtension

+ (SCNVector3)worldVectorForPosition:(CGPoint)position inView:(ARSCNView *)scnView API_AVAILABLE(ios(11.0)){
    if (@available(iOS 11.0, *)) {
       NSArray <ARHitTestResult *>*results = [scnView hitTest:position types:ARHitTestResultTypeFeaturePoint];
        if (results.count > 0) {
            ARHitTestResult *result = results.firstObject;
            return [RASCNVector3Tool positionTranform:result.worldTransform];
        }else{
            return SCNVector3Zero;
        }
    }
    return SCNVector3Zero;
}

@end
