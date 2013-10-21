//
//  DynamicMediaAndCarouselCell.m
//  FieldResearchTool
//
//  Created by Jacob Hanshaw on 10/14/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "DynamicMediaAndCarouselCell.h"

#import "EnumJudgementViewController.h"
#import "ProjectComponent.h"

@interface DynamicMediaAndCarouselCell()
{
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *detailLabel;
    UIButton *expandButton;
    
    UIImageView *infoPlaceholderView;
    UIView *observationView;
}

@end

/*
 <UILabel: 0x9c5c3b0; frame = (51 2; 153 22); text = 'Leaf arrangement'; clipsToBounds = YES; userInteractionEnabled = NO; layer = <CALayer: 0x9c5c440>>
 2013-10-14 16:37:28.889 FieldResearchTool[3159:c07] <UITableViewLabel: 0x9c5c5e0; frame = (51 24; 96 18); text = 'Not Interpreted'; clipsToBounds = YES; userInteractionEnabled = NO; layer = <CALayer: 0x9c5c670>>
 2013-10-14 16:37:28.890 FieldResearchTool[3159:c07] <UIImageView: 0x9c5c990; frame = (1 1; 40 40); opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x9c5c9f0>>
 */

@implementation DynamicMediaAndCarouselCell

@synthesize delegate, expanded;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds = YES;
        self.autoresizingMask |= (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CAROUCELL_PADDING_XY, CAROUCELL_PADDING_XY, CAROUCELL_IMAGE_HEIGHT, CAROUCELL_IMAGE_HEIGHT)];
   //     imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + CAROUCELL_IMAGE_TEXT_PADDING, CAROUCELL_PADDING_XY, self.contentView.frame.size.width - (imageView.frame.origin.x + imageView.frame.size.width + CAROUCELL_IMAGE_TEXT_PADDING) - (CAROUCELL_BUTTON_WIDTH + CAROUCELL_PADDING_XY), CAROUCELL_TITLE_LABEL_HEIGHT)];
        titleLabel.backgroundColor = [UIColor clearColor];
   //     titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:titleLabel];
        
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + CAROUCELL_IMAGE_TEXT_PADDING, titleLabel.frame.origin.y + titleLabel.frame.size.height, self.contentView.frame.size.width - (imageView.frame.origin.x + imageView.frame.size.width + CAROUCELL_IMAGE_TEXT_PADDING) - (CAROUCELL_BUTTON_WIDTH + CAROUCELL_PADDING_XY), CAROUCELL_DETAIL_LABEL_HEIGHT)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:titleLabel.font.pointSize - 4];
   //     detailLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:detailLabel];
        
        expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        expandButton.frame = CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width, CAROUCELL_PADDING_XY, CAROUCELL_BUTTON_WIDTH, titleLabel.frame.size.height);
   //     expandButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [expandButton addTarget:self action:@selector(expandButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [expandButton setTitle:@"Info" forState:UIControlStateNormal];
        [expandButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview: expandButton];
        
        infoPlaceholderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2 * CAROUCELL_PADDING_XY + imageView.frame.size.height, self.contentView.frame.size.width, CAROUCELL_MEDIA_HEIGHT)];
        infoPlaceholderView.clipsToBounds = YES;
        infoPlaceholderView.contentMode = UIViewContentModeScaleAspectFill;
        infoPlaceholderView.image = [UIImage imageNamed:@"red_maple2.png"];
    //    infoPlaceholderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        infoPlaceholderView.hidden = !expanded;
        [self.contentView addSubview:infoPlaceholderView];
    }
    return self;
}

- (void)updateFrames
{
    infoPlaceholderView.hidden = !expanded;
    imageView.frame = CGRectMake(CAROUCELL_PADDING_XY, CAROUCELL_PADDING_XY, CAROUCELL_IMAGE_HEIGHT, CAROUCELL_IMAGE_HEIGHT);
    titleLabel.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + CAROUCELL_IMAGE_TEXT_PADDING, CAROUCELL_PADDING_XY, self.contentView.frame.size.width - (imageView.frame.origin.x + imageView.frame.size.width + CAROUCELL_IMAGE_TEXT_PADDING) - (CAROUCELL_BUTTON_WIDTH + CAROUCELL_PADDING_XY), CAROUCELL_TITLE_LABEL_HEIGHT);
    detailLabel.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + CAROUCELL_IMAGE_TEXT_PADDING, titleLabel.frame.origin.y + titleLabel.frame.size.height, self.contentView.frame.size.width - (imageView.frame.origin.x + imageView.frame.size.width + CAROUCELL_IMAGE_TEXT_PADDING) - (CAROUCELL_BUTTON_WIDTH + CAROUCELL_PADDING_XY), CAROUCELL_DETAIL_LABEL_HEIGHT);
    expandButton.frame = CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width, CAROUCELL_PADDING_XY, CAROUCELL_BUTTON_WIDTH, titleLabel.frame.size.height);
    infoPlaceholderView.frame = CGRectMake(0, 2 * CAROUCELL_PADDING_XY + imageView.frame.size.height, self.contentView.frame.size.width, CAROUCELL_MEDIA_HEIGHT);
    observationView.frame = [self observationViewFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)expandButtonPressed:(UIButton *) sender
{
    [delegate didExpandOrCollapseCell:self];
}

#pragma mark - Getters/Setters
- (void)setTitleImage:(UIImage *) image { imageView.image = image; }

- (void)setTitleText:(NSString *) title
{
    titleLabel.text = title;
    CGSize textViewSize = [titleLabel sizeThatFits:CGSizeMake(self.contentView.frame.size.width - (imageView.frame.origin.x + imageView.frame.size.width + CAROUCELL_IMAGE_TEXT_PADDING) - (CAROUCELL_BUTTON_WIDTH + CAROUCELL_PADDING_XY), CAROUCELL_TITLE_LABEL_HEIGHT)];
    CGRect frame = titleLabel.frame;
    frame.size.height = textViewSize.height;
    titleLabel.frame = frame;
}

- (void)setDetailText:(NSString *) detail
{
    detailLabel.text = detail;
    CGSize textViewSize = [detailLabel sizeThatFits:CGSizeMake(self.contentView.frame.size.width - (imageView.frame.origin.x + imageView.frame.size.width + CAROUCELL_IMAGE_TEXT_PADDING) - (CAROUCELL_BUTTON_WIDTH + CAROUCELL_PADDING_XY), CAROUCELL_DETAIL_LABEL_HEIGHT)];
    CGRect frame = detailLabel.frame;
    frame.origin.y = 24;
    frame.size.height = textViewSize.height;
    detailLabel.frame = frame;
}

- (void)observationView:(ProjectComponent *) component
{
    [observationView removeFromSuperview];
    
    EnumJudgementViewController *enumJudgementViewController = [[EnumJudgementViewController alloc]initWithFrame:[self observationViewFrame]];
    enumJudgementViewController.prevData = nil;
    enumJudgementViewController.projectComponent = component;
    enumJudgementViewController.isOneToOne = NO;
    observationView = enumJudgementViewController.view;
    observationView.clipsToBounds = YES;
    [self.contentView addSubview:observationView];

    //observationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - Frame Helpers
- (CGRect) observationViewFrame
{
    if(expanded)
        return CGRectMake(0, infoPlaceholderView.frame.origin.y + infoPlaceholderView.frame.size.height,
                                          self.contentView.frame.size.width,
                                          self.contentView.frame.size.height - (infoPlaceholderView.frame.origin.y + infoPlaceholderView.frame.size.height));
    return CGRectMake(0, 2 * CAROUCELL_PADDING_XY + imageView.frame.size.height,
                                          self.contentView.frame.size.width,
                                          self.contentView.frame.size.height - (2 * CAROUCELL_PADDING_XY + imageView.frame.size.height));
}

@end