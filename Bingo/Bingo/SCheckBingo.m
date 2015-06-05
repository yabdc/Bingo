//
//  SCheckBingo.m
//  Bingo
//
//  Created by 1500244 on 2015/6/5.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import "SCheckBingo.h"

@interface SCheckBingo ()

@end

@implementation SCheckBingo
{
    int m_iBingoCount;
    int m_iLength;
    NSArray *m_aryBingo;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        m_iBingoCount=0;
        m_aryBingo=[NSArray new];
    }
    return self;
}
-(int)checkBingo:(NSArray *)aryBingo iLength:(int)iLength{
    m_iBingoCount=0;
    m_iLength=iLength;
    m_aryBingo=aryBingo;
    //檢查橫列
    [self checkBingoRow];
    //檢查直行
    [self checkBingoStraight];
    //檢查反斜線
    [self checkBingoBackSlash];
    //檢查斜線
    [self checkBingoSlash];
    return m_iBingoCount;
}

-(void)checkBingoRow{
    int iRowCount=0;
    NSString *str=nil;
    for (int i=0; i<m_iLength; i++) {
        iRowCount=0;
        for (int j=0;j<m_iLength; j++) {
            str=m_aryBingo[i*m_iLength+j];
            iRowCount += [str intValue];
            if (m_iLength==iRowCount) {
                m_iBingoCount++;
            }
        }
    }
}

-(void)checkBingoStraight{
    int iStraightCount=0;
    NSString *str=nil;
    for (int i=0; i<m_iLength; i++) {
        iStraightCount=0;
        for (int j=0;j<m_iLength; j++) {
            str=m_aryBingo[i+j*m_iLength];
            iStraightCount += [str intValue];
            if (m_iLength==iStraightCount) {
                m_iBingoCount++;
            }
        }
    }
}

-(void)checkBingoBackSlash{
    int iBackSlash=0;
    NSString *str=nil;
    for (int i=0; i<m_iLength; i++) {
        for (int j=0;j<m_iLength; j++) {
            if (i==j) {
                str=m_aryBingo[(i*m_iLength+i)];
                iBackSlash += [str intValue];
                if (m_iLength==iBackSlash) {
                    m_iBingoCount++;
                }
                
            }
        }
    }
}

-(void)checkBingoSlash{
    int iSlash=0;
    NSString *str=nil;
    for (int i=0; i<m_iLength; i++) {
        for (int j=0;j<m_iLength; j++) {
            if ((i+1)*(m_iLength-1)==i*m_iLength+j) {
                str=m_aryBingo[(i*m_iLength+j)];
                iSlash += [str intValue];
                if (m_iLength==iSlash) {
                    m_iBingoCount++;
                }
            }
        }
    }
}

@end
