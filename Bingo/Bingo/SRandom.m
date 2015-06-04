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
    int m_iArray[100];
}
-(id)initWithRange:(int)iRange{
    [self resetRandom:iRange];
    _g_aryRandom= [[NSMutableArray alloc] initWithCapacity: iRange];
    if(_g_aryRandom)
    {
        int iCount = 0;
        while( iCount < iRange )
        {
            [_g_aryRandom addObject: [NSString stringWithFormat: @"%d", m_iArray[iCount]]];
            iCount++;
        }
    }
    return self;
    
}

-(void)resetRandom:(int)iRange{
    int iswap;
    for (int i=1; i<=iRange; i++) {
        m_iArray[i-1]=i;
    }
    int ino=iRange-1;
    int itemp=0;
    while (ino>=0) {
        iswap=arc4random()%(iRange-1);
        itemp=m_iArray[ino];
        m_iArray[ino]=m_iArray[iswap];
        m_iArray[iswap]=itemp;
        ino--;
    }
}

@end
