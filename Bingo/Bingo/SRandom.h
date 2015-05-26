//
//  SRandom.h
//  Bingo
//
//  Created by 1500244 on 2015/5/25.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRandom : NSObject
@property (nonatomic,strong)NSMutableArray *m_aryRandom;

-(id)initWithRange:(int)iRange;
@end
