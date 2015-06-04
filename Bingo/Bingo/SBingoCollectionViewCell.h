//
//  SBingoCollectionViewCell.h
//  Bingo
//
//  Created by 1500244 on 2015/5/25.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBingoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *g_imageView;

@property (weak, nonatomic) IBOutlet UITextField *g_numberField;
@property (assign) int g_iFlag; //是否被選取
@end
