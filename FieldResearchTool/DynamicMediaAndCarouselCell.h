//
//  DynamicMediaAndCarouselCell.h
//  FieldResearchTool
//
//  Created by Jacob Hanshaw on 10/14/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#define CAROUCELL_PADDING_XY            2
#define CAROUCELL_IMAGE_TEXT_PADDING   10
#define CAROUCELL_TITLE_LABEL_HEIGHT   22
#define CAROUCELL_DETAIL_LABEL_HEIGHT  18
#define CAROUCELL_BUTTON_WIDTH         20
#define CAROUCELL_CAROUSEL_HEIGHT      40
#define CAROUCELL_MEDIA_HEIGHT         40

#define CAROUCELL_IMAGE_HEIGHT         (CAROUCELL_TITLE_LABEL_HEIGHT + CAROUCELL_DETAIL_LABEL_HEIGHT)
#define CAROUCELL_DEFAULT_CELL_HEIGHT  (CAROUCELL_IMAGE_HEIGHT + 2 * CAROUCELL_PADDING_XY + CAROUCELL_CAROUSEL_HEIGHT)
#define CAROUCELL_EXPANDED_CELL_HEIGHT (CAROUCELL_DEFAULT_CELL_HEIGHT + CAROUCELL_MEDIA_HEIGHT)

@interface DynamicMediaAndCarouselCell : UITableViewCell

-(void) updateFrames;

-(BOOL) expanded;
-(void) setTitleImage:(UIImage *) image;
-(void) setTitleText:(NSString *) title;
-(void) setDetailText:(NSString *) detail;

@end