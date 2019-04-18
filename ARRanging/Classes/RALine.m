//
//  RALine.m
//  ARRanging_Example
//
//  Created by mac on 2019/3/29.
//  Copyright © 2019 KuaShen. All rights reserved.
//

#import "RALine.h"
#import "RASCNVector3Tool.h"

#define kScale 0.003
#define METER 1.0
#define CENITMETER 100.0
#define INCH 39.3700787


API_AVAILABLE(ios(11.0))
@interface RALine()

@property (strong, nonatomic) UIColor *color;

@property (strong, nonatomic) SCNNode *startNode;

@property (strong, nonatomic) SCNNode *endNode;

@property (strong, nonatomic) SCNNode *textNode;

@property (strong, nonatomic) SCNText *text;

@property (strong, nonatomic) SCNNode *lineNode;

@property (strong, nonatomic) ARSCNView *sceneView;

@property (nonatomic) SCNVector3 startVector;

@property (nonatomic) LengthUnit unit;


@end

@implementation RALine

- (instancetype)initWithView:(ARSCNView *)scnView andStartVetor:(SCNVector3)vetor andUnit:(LengthUnit)unit API_AVAILABLE(ios(11.0)){
    if (self = [super init]) {
        self.sceneView = scnView;
        self.startVector = vetor;
        self.unit = unit;
        self.color = [UIColor whiteColor];
        SCNSphere *sph = [SCNSphere sphereWithRadius:.5];
        sph.firstMaterial.diffuse.contents = _color;
        sph.firstMaterial.lightingModelName = SCNLightingModelConstant;
        [sph.firstMaterial setDoubleSided:NO];
        
        self.startNode = [SCNNode nodeWithGeometry:sph];
        self.startNode.scale = SCNVector3Make(kScale, kScale, kScale);
        self.startNode.position = _startVector;
        [self.sceneView.scene.rootNode addChildNode:self.startNode];
        
        self.endNode = [SCNNode nodeWithGeometry:sph];
        self.endNode.scale = SCNVector3Make(kScale , kScale, kScale);
        
        self.text = [SCNText textWithString:@"" extrusionDepth:0.1];
        self.text.font = [UIFont systemFontOfSize:5];
        self.text.firstMaterial.diffuse.contents = _color;
        self.text.firstMaterial.lightingModelName = SCNLightingModelConstant;
        [self.text setAlignmentMode:kCAAlignmentCenter];
        [self.text.firstMaterial setDoubleSided:YES];
        [self.text setTruncationMode:kCATruncationMiddle];
        
        SCNNode *tNode = [SCNNode nodeWithGeometry:self.text];
        [tNode setEulerAngles:SCNVector3Make(0, M_PI, 0)];
        tNode.scale = SCNVector3Make(kScale, kScale, kScale);
        
        self.textNode = [[SCNNode alloc]init];
        [self.textNode addChildNode:tNode];//添加到包装节点上
        SCNLookAtConstraint *constranint = [SCNLookAtConstraint lookAtConstraintWithTarget:_sceneView.pointOfView];
        [constranint setGimbalLockEnabled:YES];
        self.textNode.constraints = @[constranint];
        [_sceneView.scene.rootNode addChildNode:self.textNode];
        
    }
    return self;

}
- (void)updateToVector:(SCNVector3)vector{
    [_lineNode removeFromParentNode];
    //划线
    _lineNode = [RASCNVector3Tool drawLineWithVector:vector StartVector:_startVector];
    [_sceneView.scene.rootNode addChildNode:self.lineNode];
    //放置文字
    _text.string = [self distanceToVector:vector];
    _textNode.position = SCNVector3Make((_startVector.x + vector.x) / 2.0, (_startVector.y + vector.y) / 2.0, (_startVector.z + vector.z) / 2.0);
    
    _endNode.position = vector;
    
    if (_endNode.parentNode == nil) {
        [_sceneView.scene.rootNode addChildNode:self.endNode];
    }
    
}


- (NSString *)distanceToVector:(SCNVector3)vector{
    if (_unit == meter) {
        return [NSString stringWithFormat:@"%.2f %@",[RASCNVector3Tool distanceWithVector:vector StartVector:_startVector] * METER, @"m"];
    }else if (_unit == cenitMeter){
        return [NSString stringWithFormat:@"%.2f %@",[RASCNVector3Tool distanceWithVector:vector StartVector:_startVector] * CENITMETER, @"cm"];
    }else if (_unit == inch){
        return [NSString stringWithFormat:@"%.2f %@",[RASCNVector3Tool distanceWithVector:vector StartVector:_startVector] * INCH, @"inch"];
    }else{
        return @"";
    }
    return @"";
}

- (void)remove{
    
    [_startNode removeFromParentNode];
    [_endNode removeFromParentNode];
    [_textNode removeFromParentNode];
    [_lineNode removeFromParentNode];
    
}


@end
