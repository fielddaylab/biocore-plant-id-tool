//
//  EnumJudgementViewController.m
//  FieldResearchTool
//
//  Created by Justin Moeller on 7/25/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import "EnumJudgementViewController.h"

#import "iCarousel.h"
#import "ProjectComponentPossibility.h"
#import "AppModel.h"
#import "SaveObservationAndJudgementDelegate.h"
#import "MediaManager.h"
#import "UserObservationComponentData.h"
#import <QuartzCore/QuartzCore.h>

@interface EnumJudgementViewController () <iCarouselDataSource, iCarouselDelegate, UIActionSheetDelegate, SaveJudgementDelegate>
{
    BOOL wrap;
    UILabel *descriptionLabel;
    iCarousel *carousel;
    NSMutableArray *possibilities;
    ProjectComponentPossibility *chosenPossibility;
    CGRect initRect;
    float singleViewWidth;
}

@end

@implementation EnumJudgementViewController

@synthesize prevData;
@synthesize projectComponent;
@synthesize isOneToOne;

-(id)initWithFrame:(CGRect)frame
{
    self = [super init];
    initRect = frame;
    wrap = NO;
    return self;
}

- (void)dealloc
{
	//carousel.delegate = nil;
	//carousel.dataSource = nil;
}

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:initRect];

 /*   if (!isOneToOne)
        [self.view addSubview:[[UIImageView alloc] initWithImage:[[MediaManager sharedMediaManager] getImageNamed:@"carouselBackground"]]];
    else */
        self.view.backgroundColor = [UIColor lightGrayColor];
    
    descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height * .04, self.view.bounds.size.width, 22)];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.font = [descriptionLabel.font fontWithSize:16];
    descriptionLabel.tag = 2;
    [self.view addSubview:descriptionLabel];
    
    //create carousel
    if (!isOneToOne)
        carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];//44 navbar height.
    else
        carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, self.view.bounds.size.height)];//44 navbar height.

   // carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    carousel.type = iCarouselTypeLinear;
    carousel.delegate = self;
    carousel.dataSource = self;
    carousel.clipsToBounds = YES;

    //add carousel to view
    [self.view addSubview:carousel];
    chosenPossibility = nil;
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:projectComponent.title forKey:@"projectComponent.title"];
    [[AppModel sharedAppModel] getProjectComponentPossibilitiesWithAttributes:attributes withHandler:@selector(handlePossibilityResponse:) target:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([projectComponent.prompt isEqualToString:@""])
        descriptionLabel.text = @"Choose the best match.";
    else
        descriptionLabel.text = projectComponent.prompt;
    
    if(prevData)
    {
        if([prevData.wasJudged boolValue])
        {
            NSArray *judgementSet = [prevData.userObservationComponentDataJudgement allObjects];
            if(!judgementSet || judgementSet.count < 1)
                NSLog(@"ERROR: Judgement set was nil or had 0 data members");
            
            UserObservationComponentDataJudgement *judgement = [judgementSet objectAtIndex:0];
            
            if(!judgement)
                NSLog(@"ERROR: judgement was nil");
            
            ProjectComponentPossibility *prevPossibility = judgement.projectComponentPossibility;
            chosenPossibility = prevPossibility;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [possibilities count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        if (!isOneToOne)
        {
            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width * .45, self.view.bounds.size.height * .65)];
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, view.bounds.size.height * .65, self.view.bounds.size.width * .45, self.view.bounds.size.height * .65)];
        }
        else
        {
            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width * .25, self.view.bounds.size.height * .35)];
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width * .25, self.view.bounds.size.height * .35)];
            view.backgroundColor = [UIColor whiteColor];
        }
        
        singleViewWidth = view.frame.size.width;
        
        view.contentMode = UIViewContentModeBottom;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:16];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
        label.textColor = [UIColor blackColor];
        [view.layer setBorderWidth:0.0f];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    ProjectComponentPossibility *componentPossibility = [possibilities objectAtIndex:index];
    label.text = componentPossibility.enumValue;
    NSLog(@"label.text: %@", label.text);
    
    //Probably should make a class that handles all of these
    //This parses component
    NSString *projectComponentTitleString = projectComponent.title;
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@" "];
    projectComponentTitleString = [[projectComponentTitleString componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"_"];
    
    ProjectComponentPossibility *pos = possibilities[index];
    
    //This parses enumValue
    NSString *enumValueTitleString = pos.enumValue;
    enumValueTitleString = [[enumValueTitleString componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"_"];
    
    projectComponentTitleString = [projectComponentTitleString stringByAppendingFormat:@"-%@", enumValueTitleString];
    
    ((UIImageView *)view).image = [[MediaManager sharedMediaManager] imageWithImage:[[MediaManager sharedMediaManager] getImageNamed:projectComponentTitleString] scaledToSize:CGRectMake(0, 0, self.view.bounds.size.height *.6, self.view.bounds.size.height *.6).size];
    
    
    if(chosenPossibility)
    {
        if([componentPossibility.enumValue isEqualToString:chosenPossibility.enumValue])
        {
            label.textColor = [UIColor whiteColor];
            [view.layer setBorderColor: [[UIColor blackColor] CGColor]];
            [view.layer setBorderWidth: 2.0];
        }
    }
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
        return value * 1.1f;
    
    return value;
}

#pragma mark - iCarousel taps

- (void)carousel:(iCarousel *)aCarousel didSelectItemAtIndex:(NSInteger)index
{
    ProjectComponentPossibility *poss = [possibilities objectAtIndex:index];
    if ([chosenPossibility isEqual:poss])
        chosenPossibility = nil;
    else
        chosenPossibility = [possibilities objectAtIndex:index];
    
    [aCarousel reloadData];
}

#pragma mark handle possibility response
-(void)handlePossibilityResponse:(NSArray *)componentPossibilities
{
    //remove the nil value if it has one
    possibilities = [[NSMutableArray alloc] init];
    for (int i = 0; i < componentPossibilities.count; i++) {
        ProjectComponentPossibility *possibility = [componentPossibilities objectAtIndex:i];
        //NSLog(@"Component: %@ Possibility: %@ at index: %i", projectComponent.title, possibility.enumValue, i);
        if (![possibility.enumValue isEqualToString:@""]) {
            [possibilities addObject:possibility];
        }
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"enumValue" ascending:YES];
    [possibilities sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    [carousel reloadData];
    
    if(!chosenPossibility)
        [carousel scrollToItemAtIndex:[possibilities count]/2 animated:NO];
}

#pragma mark save observation and judgement delegates

-(UserObservationComponentDataJudgement *)saveJudgementData:(UserObservationComponentData *)userData
{
    if(!userData)
    {
        NSLog(@"ERROR: Observation data passed in was nil");
        return nil;
    }
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    [attributes setObject:[NSDate date] forKey:@"created"];
    [attributes setObject:[NSDate date] forKey:@"updated"];
    
    if(chosenPossibility)
    {
        [attributes setObject:chosenPossibility.enumValue forKey:@"enumValue"];
        UserObservationComponentDataJudgement *judgement = [[AppModel sharedAppModel] createNewJudgementWithData:userData withProjectComponentPossibility:chosenPossibility withAttributes:attributes];
        return judgement;
    }
    
    NSLog(@"No Possibility was chosen. No Judgement was made.");
    return nil;
}

-(UserObservationComponentData *)saveUserDataAndJudgement
{
    NSLog(@"ERROR: Enum cannot be a one to one. Returning nil");
    return nil;
}

@end