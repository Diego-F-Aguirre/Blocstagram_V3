//
//  UIImage+ImageUtilities.h
//  Blocstagram_V3
//
//  Created by Diego Aguirre on 6/24/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageUtilities)

- (UIImage *) imageWithFixedOrientation;
- (UIImage *) imageResizedToMatchAspectRatioOfSize:(CGSize)size;
- (UIImage *) imageCroppedToRect:(CGRect)cropRect;

@end
