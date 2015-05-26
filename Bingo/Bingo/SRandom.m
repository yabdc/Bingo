//
//  SRandom.m
//  Bingo
//
//  Created by 1500244 on 2015/5/25.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import "SRandom.h"

@implementation SRandom
{
    int g_iArray[100];
}
-(id)initWithRange:(int)iRange{
    [self resetRandom:iRange];
    _m_aryRandom= [[NSMutableArray alloc] initWithCapacity: iRange];
    if(_m_aryRandom)
    {
        int iCount = 0;
        while( iCount < iRange )
        {
            [_m_aryRandom addObject: [NSString stringWithFormat: @"%d", g_iArray[iCount]]];
            iCount++;
        }
    }
    return self;
    
}

-(void)resetRandom:(int)iRange{
    for (int i=1; i<=iRange; i++) {
        g_iArray[i-1]=i;
    }
    int ino=iRange-1;
    int itemp=0;
    while (ino>=0) {
        int iswap=arc4random()%(iRange-1);
        itemp=g_iArray[ino];
        g_iArray[ino]=g_iArray[iswap];
        g_iArray[iswap]=itemp;
        ino--;
    }
}

@end
