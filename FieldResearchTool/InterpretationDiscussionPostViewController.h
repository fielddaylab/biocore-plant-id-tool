//
//  InterpretationDiscussionPostViewController.h
//  FieldResearchTool
//
//  Created by Justin Moeller on 8/6/13.
//  Copyright (c) 2013 UW Mobile Learning Incubator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectIdentificationDiscussionPost.h"

@protocol TextViewControlDelegate <NSObject>

-(void)cancelled;
-(void)textChosen:(NSString *)text;
-(void)updateText:(NSString *)text prevPost:(ProjectIdentificationDiscussionPost *)prevPost;

@end

@interface InterpretationDiscussionPostViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *textBox;
@property (strong, nonatomic) id<TextViewControlDelegate> delegate;
@property (strong, nonatomic) ProjectIdentificationDiscussionPost *prevPost;

@end
