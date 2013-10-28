//
//  DynamicMediaAndCarouselCell.m
//  FieldResearchTool
//
//  Created by Jacob Hanshaw on 10/14/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "DynamicMediaAndCarouselCell.h"

#import "ObservationJudgementType.h"
#import "EnumJudgementViewController.h"
#import "BooleanJudgementViewController.h"
#import "LongTextJudgementViewController.h"
#import "TextJudgementViewController.h"
#import "NumberJudgementViewController.h"
#import "LongTextDataViewController.h"

@interface DynamicMediaAndCarouselCell()
{
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *detailLabel;
    UIButton *expandButton;
    
    UIImageView *infoPlaceholderView;
    UIViewController *observationVC;
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
        //BAD CODE
        CGRect properFrame;
        if(self.frame.size.width != 300)
        {
            properFrame = self.frame;
            properFrame.size.width = self.frame.size.width/16.0 * 15.0;
            self.frame = properFrame;
            self.contentView.frame = properFrame;
        }
        self.clipsToBounds = NO;

        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CAROUCELL_PADDING_XY, CAROUCELL_PADDING_XY, CAROUCELL_IMAGE_HEIGHT, CAROUCELL_IMAGE_HEIGHT)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:imageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + CAROUCELL_IMAGE_TEXT_PADDING, CAROUCELL_PADDING_XY, self.contentView.frame.size.width - (imageView.frame.origin.x + imageView.frame.size.width + CAROUCELL_IMAGE_TEXT_PADDING) - (CAROUCELL_BUTTON_WIDTH + CAROUCELL_PADDING_XY), CAROUCELL_TITLE_LABEL_HEIGHT)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:titleLabel];
        
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + CAROUCELL_IMAGE_TEXT_PADDING, titleLabel.frame.origin.y + titleLabel.frame.size.height, self.contentView.frame.size.width - (imageView.frame.origin.x + imageView.frame.size.width + CAROUCELL_IMAGE_TEXT_PADDING) - (CAROUCELL_BUTTON_WIDTH + CAROUCELL_PADDING_XY), CAROUCELL_DETAIL_LABEL_HEIGHT)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:titleLabel.font.pointSize - 4];
        detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        detailLabel.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:detailLabel];
        
        expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        expandButton.frame = CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width, CAROUCELL_PADDING_XY, CAROUCELL_BUTTON_WIDTH, titleLabel.frame.size.height);
        [expandButton addTarget:self action:@selector(expandButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [expandButton setTitle:@"Info" forState:UIControlStateNormal];
        [expandButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        expandButton.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview: expandButton];
        
        infoPlaceholderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2 * CAROUCELL_PADDING_XY + imageView.frame.size.height, self.contentView.frame.size.width, CAROUCELL_MEDIA_HEIGHT)];
        infoPlaceholderView.clipsToBounds = YES;
        infoPlaceholderView.contentMode = UIViewContentModeScaleAspectFill;
        infoPlaceholderView.image = [UIImage imageNamed:@"red_maple2.png"];
        infoPlaceholderView.hidden = !expanded;
        infoPlaceholderView.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
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
    observationVC.view.frame = [self observationViewFrame];
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

- (void)observationViewFromComponent:(ProjectComponent *) projectComponent andPreviousData: (UserObservationComponentData *)prevData
{
    [observationVC.view removeFromSuperview];

    observationVC = [self getComponentViewForComponent:projectComponent andPreviousData:prevData];
    
    [self.contentView addSubview:observationVC.view];
}

- (UIViewController *) getComponentViewForComponent:(ProjectComponent *) projectComponent andPreviousData: (UserObservationComponentData *)prevData
{
    UIViewController *judgementViewControllerToDisplay;
    switch ([projectComponent.observationJudgementType intValue]) {
        case JUDGEMENT_NUMBER:{
            NumberJudgementViewController *numberJudgementViewController = [[NumberJudgementViewController alloc] initWithFrame:[self observationViewFrame]];
            numberJudgementViewController.prevData = prevData;
            numberJudgementViewController.projectComponent = projectComponent;
            numberJudgementViewController.isOneToOne = NO;
            judgementViewControllerToDisplay = numberJudgementViewController;
        }
            break;
        case JUDGEMENT_BOOLEAN:{
            BooleanJudgementViewController *booleanJudgementViewController = [[BooleanJudgementViewController alloc]initWithFrame:[self observationViewFrame]];
            booleanJudgementViewController.prevData = prevData;
            booleanJudgementViewController.projectComponent = projectComponent;
            booleanJudgementViewController.isOneToOne = NO;
            judgementViewControllerToDisplay = booleanJudgementViewController;
        }
            break;
        case JUDGEMENT_TEXT:{
            TextJudgementViewController *textJudgementViewController = [[TextJudgementViewController alloc]initWithFrame:[self observationViewFrame]];
            textJudgementViewController.projectComponent = projectComponent;
            textJudgementViewController.isOneToOne = NO;
            textJudgementViewController.prevData = prevData;
            judgementViewControllerToDisplay = textJudgementViewController;
        }
            break;
        case JUDGEMENT_LONG_TEXT:{
            LongTextJudgementViewController *longTextJudgementViewController = [[LongTextJudgementViewController alloc]initWithFrame:[self observationViewFrame]];
            longTextJudgementViewController.projectComponent = projectComponent;
            longTextJudgementViewController.isOneToOne = NO;
            longTextJudgementViewController.prevData = prevData;
            judgementViewControllerToDisplay = longTextJudgementViewController;
        }
            break;
        case JUDGEMENT_ENUMERATOR:{
            EnumJudgementViewController *enumJudgementViewController = [[EnumJudgementViewController alloc]initWithFrame:[self observationViewFrame]];
            enumJudgementViewController.prevData = prevData;
            enumJudgementViewController.projectComponent = projectComponent;
            enumJudgementViewController.isOneToOne = NO;
            judgementViewControllerToDisplay = enumJudgementViewController;
            
        }
            break;
        default:
            break;
    }
    
   // judgementViewControllerToDisplay.view.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
    return judgementViewControllerToDisplay;
}

#pragma mark - Frame Helpers
- (CGRect) observationViewFrame
{
    if(expanded)
        return CGRectMake(0, infoPlaceholderView.frame.origin.y + infoPlaceholderView.frame.size.height,
                                          self.contentView.frame.size.width,
                                          CAROUCELL_CAROUSEL_HEIGHT);
    return CGRectMake(0, 2 * CAROUCELL_PADDING_XY + imageView.frame.size.height,
                                          self.contentView.frame.size.width,
                                          CAROUCELL_CAROUSEL_HEIGHT);
}

@end