//
//  RAViewController.m
//  ARRanging
//
//  Created by KuaShen on 03/28/2019.
//  Copyright (c) 2019 KuaShen. All rights reserved.
//

#import "RAViewController.h"
#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import "RALine.h"
#import "RASCNViewExtension.h"

#define SCREEN_W ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_H ([[UIScreen mainScreen] bounds].size.height)

API_AVAILABLE(ios(11.0))
@interface RAViewController ()<ARSCNViewDelegate>{
    BOOL isMeasuring;
    SCNVector3 vectorZero;
    SCNVector3 vectorStart;
    SCNVector3 vectorEnd;
    RALine *currentLine;
    NSMutableArray <RALine *>* lines;
    LengthUnit unit;
}

@property (nonatomic, strong) ARSCNView *sceneView;

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) UIImageView *targetImageView;

@property (nonatomic, strong) ARSession *session;

@property (nonatomic, strong) ARWorldTrackingConfiguration *trackConfig;


@end

@implementation RAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isMeasuring = false;
    unit = cenitMeter;
    
    vectorStart = SCNVector3Zero;
    vectorZero = SCNVector3Zero;
    vectorEnd = SCNVector3Zero;
    
    self.view = self.sceneView;
    _sceneView.delegate = self;
    _sceneView.session = self.session;
    
    [_sceneView addSubview:self.infoLabel];
    [_sceneView addSubview:self.targetImageView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [_session runWithConfiguration:self.trackConfig options:ARSessionRunOptionResetTracking | ARSessionRunOptionRemoveExistingAnchors];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!isMeasuring) {
        [self reset];
        isMeasuring = true;
        _targetImageView.image = [UIImage imageNamed:@"GreenTarget"];
    }else{
        
        isMeasuring = false;
        if (currentLine) {
            RALine *line = currentLine;
            [lines addObject:line];
            currentLine = nil;
            _targetImageView.image = [UIImage imageNamed:@"WhiteTarget"];
        }
    }
    
    
}

- (void)reset{
    vectorStart = SCNVector3Zero;
    vectorEnd = SCNVector3Zero;
}

- (void)scanWorld{
    
    if (@available(iOS 11.0, *)) {
        SCNVector3 worldPosition = [RASCNViewExtension worldVectorForPosition:self.sceneView.center inView:_sceneView];
        if (lines.count  == 0) {
            if (SCNVector3EqualToVector3(vectorStart, vectorZero)){
                vectorStart = worldPosition;
                if (@available(iOS 11.0, *)) {
                    currentLine = [[RALine alloc]initWithView:_sceneView andStartVetor:vectorStart andUnit:unit];
                }
            }
            
            vectorEnd = worldPosition;
            [currentLine updateToVector:vectorEnd];
            [_infoLabel setHidden:NO];
            if ([[currentLine distanceToVector:vectorEnd] isEqualToString:@""]) {
                _infoLabel.text = [currentLine distanceToVector:vectorEnd];
            }else{
                _infoLabel.text = @"";
            }
            
        }
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)labelHidden{
    
    [_infoLabel setHidden:YES];
    
}

- (void)showLabelWithText:(NSString *)text{
    _infoLabel.hidden = NO;
    _infoLabel.text = text;
    [self performSelector:@selector(labelHidden) withObject:nil afterDelay:3.0];
}

#pragma mark -------------  lazy load  -------------------

- (UILabel *)infoLabel{
    if (!_infoLabel){
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.frame = CGRectMake((SCREEN_W - 300) / 2, 40, 300, 30);
        _infoLabel.text = @"环境初始化中......";
        _infoLabel.textColor = [UIColor whiteColor];
        [_infoLabel setHidden:NO];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
//        [self performSelector:@selector(labelHidden) withObject:nil afterDelay:3.0];
    }
    
    
    return _infoLabel;
}

- (UIImageView *)targetImageView{
    if (!_targetImageView){
        _targetImageView = [[UIImageView alloc] init];
        _targetImageView.frame = CGRectMake((SCREEN_W - 40) / 2, (SCREEN_H - 40) / 2, 40, 40);
        _targetImageView.image = [UIImage imageNamed:@"WhiteTarget"];
        
    }
    
    
    return _targetImageView;
}

- (ARSCNView *)sceneView API_AVAILABLE(ios(11.0)){
    if (!_sceneView){
        if (@available(iOS 11.0, *)) {
            _sceneView = [[ARSCNView alloc] init];
            _sceneView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        }
        
    }
    
    
    return _sceneView;
}

- (ARSession *)session API_AVAILABLE(ios(11.0)){
    if (!_session){
        if (@available(iOS 11.0, *)) {
            _session = [[ARSession alloc] init];
        }
        
    }
    
    
    return _session;
}

- (ARWorldTrackingConfiguration *)trackConfig API_AVAILABLE(ios(11.0)){
    if (!_trackConfig) {
        //创建追踪
        if (@available(iOS 11.0, *)) {
            ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc]init];
            configuration.planeDetection = ARPlaneDetectionHorizontal;
            
            //自适应灯光(有强光到弱光会变的平滑一些)
            _trackConfig = configuration;
            _trackConfig.lightEstimationEnabled = true;
            
            [_session runWithConfiguration:configuration];
        }
  
    }

    return _trackConfig;
}

#pragma mark -------------- delegate ----------------

- (void)renderer:(id<SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scanWorld];
    });
    
}

- (void)session:(ARSession *)session didFailWithError:(NSError *)error API_AVAILABLE(ios(11.0)){
    
    [self showLabelWithText:@"通信错误！！！"];
    
}

- (void)sessionWasInterrupted:(ARSession *)session API_AVAILABLE(ios(11.0)){
    
    [self showLabelWithText:@"通信中断~~~"];
    
}

- (void)sessionInterruptionEnded:(ARSession *)session API_AVAILABLE(ios(11.0)){
    
    
    [self showLabelWithText:@"通信恢复"];
    
}


@end
