//
//  S.m
//  Bingo
//
//  Created by 1500244 on 2015/6/4.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import "SKeyBoardToolBar.h"
#import "SBingoViewController.h"
@interface SKeyBoardToolBar ()
@property (strong, nonatomic) IBOutlet UIView *xibView;

@end
@implementation SKeyBoardToolBar

- (instancetype)initWithWidth:(CGFloat)Width{
    self = [super initWithFrame:CGRectMake(0, 0, Width, 44)];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    NSString *nibName = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    [self.xibView setFrame:self.frame];
    [self addSubview:self.xibView];
}


- (IBAction)doneAction:(UIBarButtonItem *)UIBarButtonItem {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchDoneBarButton" object:nil];
}

- (IBAction)cancelAction:(UIBarButtonItem *)UIBarButtonItem {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"endEditing" object:nil];
}

@end
