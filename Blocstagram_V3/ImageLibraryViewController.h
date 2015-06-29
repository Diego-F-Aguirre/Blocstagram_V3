//
//  ImageLibraryViewController.h
//  
//
//  Created by Diego Aguirre on 6/27/15.
//
//

#import <UIKit/UIKit.h>

@class ImageLibraryViewController;

@protocol ImageLibraryViewControllerDelegate <NSObject>

- (void) imageLibraryViewController:(ImageLibraryViewController *)imageLibraryViewController didCompleteWithImage:(UIImage *)image;

@end

@interface ImageLibraryViewController : UICollectionViewController

@property (nonatomic, weak) id <ImageLibraryViewControllerDelegate> delegate;

@end