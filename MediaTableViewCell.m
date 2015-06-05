//
//  MediaTableViewCell.m
//  Blocstagram_V3
//
//  Created by Diego Aguirre on 5/7/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "MediaTableViewCell.h"
#import "Media.h"
#import "Comment.h"
#import "User.h"

@interface MediaTableViewCell() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *mediaImageView;
@property (nonatomic, strong) UILabel *usernameAndCaptionLabel;
@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, strong) NSLayoutConstraint *imageHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *usernameAndCaptionLabelHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *commentLabelHeightConstraint;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressureGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;


@end

static UIFont *lightFont;
static UIFont *boldFont;
static UIColor *usernameLabelGray;
static UIColor *commentLabelGray;
static UIColor *linkColor;
static NSParagraphStyle *paragraphStyle;
static UIColor *commentLabelColor;
static UIColor *commentLabelTextColor;

@implementation MediaTableViewCell


+(void)load {

    lightFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
    boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    usernameLabelGray = [UIColor colorWithRed:160/255.0 green:158/255.0 blue:150/255.0 alpha:1]; /*#eeeeee*/
    commentLabelGray = [UIColor colorWithRed:75/255.0 green:74/255.0 blue:70/255.0 alpha:1]; /*#e5e5e5*/
    linkColor = [UIColor colorWithRed:0.345 green:0.314 blue:0.427 alpha:1]; /*#58506d*/
    commentLabelColor = [UIColor colorWithRed:242/250.0 green:110/250.0 blue:60/250.0 alpha:1]; /*F26E3C*/
    commentLabelTextColor = [UIColor whiteColor];
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    mutableParagraphStyle.headIndent = 20.0;
    mutableParagraphStyle.firstLineHeadIndent = 20.0;
    mutableParagraphStyle.tailIndent = -20.0;
    mutableParagraphStyle.paragraphSpacingBefore = 5;
    
    paragraphStyle = mutableParagraphStyle;

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //initialization code
        self.mediaImageView = [[UIImageView alloc]init];
        self.mediaImageView.userInteractionEnabled = YES;
        
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
        self.tapGestureRecognizer.delegate = self;
        [self.mediaImageView addGestureRecognizer:self.tapGestureRecognizer];
        
        
        self.longPressureGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        self.longPressureGestureRecognizer.delegate = self;
        [self.mediaImageView addGestureRecognizer:self.longPressureGestureRecognizer];
        
        self.doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTappedFired:)];
        self.doubleTapGestureRecognizer.delegate = self;
        self.doubleTapGestureRecognizer.numberOfTouchesRequired = 2;
        
        
        self.usernameAndCaptionLabel = [[UILabel alloc]init];
        self.usernameAndCaptionLabel.numberOfLines = 0;
        self.usernameAndCaptionLabel.backgroundColor = usernameLabelGray;
        
        
        
        self.commentLabel = [[UILabel alloc]init];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.backgroundColor = commentLabelGray;
        self.commentLabel.textColor = commentLabelTextColor;

        
        for (UIView *view in @[self.mediaImageView,self.usernameAndCaptionLabel,self.commentLabel]) {
        
            [self.contentView addSubview:view];
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_mediaImageView, _usernameAndCaptionLabel, _commentLabel);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mediaImageView]|" options:kNilOptions metrics:nil views:viewDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_usernameAndCaptionLabel]|" options:kNilOptions metrics:nil views:viewDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentLabel]|" options:kNilOptions metrics:nil views:viewDictionary]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mediaImageView][_usernameAndCaptionLabel][_commentLabel]" options:kNilOptions metrics:nil views:viewDictionary]];
        
        
        
        self.imageHeightConstraint = [NSLayoutConstraint constraintWithItem:_mediaImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];
        self.imageHeightConstraint.identifier = @"Image height constraint";
        
        self.usernameAndCaptionLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_usernameAndCaptionLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];
        self.usernameAndCaptionLabelHeightConstraint.identifier = @"Username and caption label height constraint";
        
        self.commentLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_commentLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];
        self.commentLabelHeightConstraint.identifier = @"Comment label height constraint";
        
        [self.contentView addConstraints:@[self.imageHeightConstraint, self.usernameAndCaptionLabelHeightConstraint, self.commentLabelHeightConstraint]];
        
       
    }

    return self;
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {

    [super setHighlighted:NO animated:animated];
    
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:NO animated:animated];
}



- (NSAttributedString *)usernameAndCaptionString {

    //#1
    CGFloat usernameFontSize = 11;
    
    // #2 - Make a string that says "username caption"
    NSString *baseString = [NSString stringWithFormat:@"%@ %@", self.mediaItem.user.userName, self.mediaItem.caption];
    
    // #3 - Make an attributed string, with the "username" bold
    NSMutableAttributedString *mutableUsernameAndCaptionString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : [lightFont fontWithSize:usernameFontSize], NSParagraphStyleAttributeName:paragraphStyle}];
    
    // #4
    NSRange usernameRange = [baseString rangeOfString:self.mediaItem.user.userName];
//    NSRange commentNameRange = [baseString rangeOfString:self.mediaItem.caption];
    [mutableUsernameAndCaptionString addAttribute:NSFontAttributeName value:[boldFont fontWithSize:usernameFontSize] range:usernameRange];
//    [mutableUsernameAndCaptionString addAttribute:NSFontAttributeName value:commentLabelColor range:commentNameRange];
    [mutableUsernameAndCaptionString addAttribute:NSForegroundColorAttributeName value:commentLabelColor range:usernameRange];
    
    
    
    return mutableUsernameAndCaptionString;
    
}

- (NSAttributedString *) commentString {
        NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] init];
    
        for (Comment *comment in self.mediaItem.comments) {
                // Make a string that says "username comment" followed by a line break
                NSString *baseString = [NSString stringWithFormat:@"%@ %@\n", comment.from.userName, comment.text];
        
                // Make an attributed string, with the "username" bold
        
                NSMutableAttributedString *oneCommentString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : lightFont, NSParagraphStyleAttributeName : paragraphStyle}];
        
                NSRange usernameRange = [baseString rangeOfString:comment.from.userName];
                [oneCommentString addAttribute:NSFontAttributeName value:boldFont range:usernameRange];
                [oneCommentString addAttribute:NSForegroundColorAttributeName value:linkColor range:usernameRange];
        
                [commentString appendAttributedString:oneCommentString];
            }
    
        return commentString;
    }



- (void) layoutSubviews {
        [super layoutSubviews];
    
         // Before layout, calculate the intrinsic size of the labels (the size they "want" to be), and add 20 to the height for some vertical padding.
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
    CGSize usernameLabelSize = [self.usernameAndCaptionLabel sizeThatFits:maxSize];
    CGSize commentLabelSize = [self.commentLabel sizeThatFits:maxSize];
    
    self.usernameAndCaptionLabelHeightConstraint.constant = usernameLabelSize.height == 0 ? 0 : usernameLabelSize.height + 20;
    self.commentLabelHeightConstraint.constant = commentLabelSize.height == 0 ? 0 : commentLabelSize.height + 20;
    
    if (self.mediaItem.image.size.width > 0 && CGRectGetWidth(self.contentView.bounds) > 0) {
        self.imageHeightConstraint.constant = self.mediaItem.image.size.height / self.mediaItem.image.size.width * CGRectGetWidth(self.contentView.bounds);
    }else {
    
        self.imageHeightConstraint.constant = 0;
    }

    
    
        // Hide the line between cells
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(self.bounds));
    }

- (void) setMediaItem:(Media *)mediaItem {
        _mediaItem = mediaItem;
        self.mediaImageView.image = _mediaItem.image;
        self.usernameAndCaptionLabel.attributedText = [self usernameAndCaptionString];
        self.commentLabel.attributedText = [self commentString];
    
    
    }


+ (CGFloat) heightForMediaItem:(Media *)mediaItem width:(CGFloat)width {
        // Make a cell
        MediaTableViewCell *layoutCell = [[MediaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"layoutCell"];
    
    layoutCell.mediaItem = mediaItem;
    
    layoutCell.frame = CGRectMake(0, 0, width, CGRectGetHeight(layoutCell.frame));
    
    [layoutCell setNeedsLayout];
    [layoutCell layoutIfNeeded];
    
    
         // Get the actual height required for the cell
        return CGRectGetMaxY(layoutCell.commentLabel.frame);
}

#pragma mark - Image View
- (void) tapFired:(UITapGestureRecognizer *)sender{

    [self.delegate cell:self didTapImageView:self.mediaImageView];
}

- (void) longPressFired: (UILongPressGestureRecognizer *)sender {

    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.delegate cell:self didLongPressImageView:self.mediaImageView];
    }
}

- (void) doubleTappedFired: (UITapGestureRecognizer *)sender{

    [self.delegate cell:self didTapImageView:self.mediaImageView];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.isEditing == NO;
}



@end
