//
//  CameraViewController.m
//  Blocstagram_V3
//
//  Created by Diego Aguirre on 6/17/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CameraToolBar.h"

@interface CameraViewController () <CameraViewControllerDelegate>

@property (nonatomic, strong) UIView *imagePreview;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong) NSArray *horizontalLines;
@property (nonatomic, strong) NSArray *verticalLines;
@property (nonatomic, strong) UIToolbar *topView;
@property (nonatomic, strong) UIToolbar *bottomView;

@property (nonatomic, strong) CameraToolBar *cameraToolbar;

@end

@implementation CameraViewController

@end
