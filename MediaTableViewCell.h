//
//  MediaTableViewCell.h
//  Blocstagram_V3
//
//  Created by Diego Aguirre on 5/7/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media, MediaTableViewCell;

@protocol MediaTableViewCellDelegate <NSObject>

- (void)cell:(MediaTableViewCell *)cell didTapImageView:(UIImageView *)imageView;
- (void)cell:(MediaTableViewCell *)cell didLongPressImageView:(UIImageView *)imageView;
- (void)cell:(MediaTableViewCell *)cell didDoubltTapImageView:(UIImageView *)imageView;

@end

@interface MediaTableViewCell : UITableViewCell

@property (nonatomic, strong) Media *mediaItem;
@property (nonatomic, weak) id <MediaTableViewCellDelegate> delegate;

+ (CGFloat) heightForMediaItem:(Media *)mediaItem width:(CGFloat)width;

@end
