//
//  RASCNViewExtension.h
//  ARRanging_Example
//
//  Created by mac on 2019/4/17.
//  Copyright © 2019 KuaShen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RASCNViewExtension : NSObject

+ (SCNVector3)worldVectorForPosition:(CGPoint)position inView:(ARSCNView *)scnView API_AVAILABLE(ios(11.0));

@end

NS_ASSUME_NONNULL_END
