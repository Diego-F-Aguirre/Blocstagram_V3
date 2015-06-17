//
//  CameraToolBar.h
//  Blocstagram_V3
//
//  Created by Diego Aguirre on 6/16/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraToolBar;

@protocol CameraToolBarDelegate <NSObject>

- (void) leftButtonPressedOnToolbar:(CameraToolBar *)toolbar;
- (void) rightButtonPressedOnToolbar:(CameraToolBar *)toolbar;
- (void) cameraButtonPressedOnToolbar:(CameraToolBar *)toolbar;

@end

@interface CameraToolBar : UIView

- (instancetype) initWithImageNames:(NSArray *)imageNames;

@property (nonatomic, weak) NSObject <CameraToolBarDelegate> *delegate;

@end
