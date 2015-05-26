//
//  ViewController.m
//  Bingo
//
//  Created by 1500244 on 2015/5/25.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import "SBingoViewController.h"
#import "SBingoCollectionViewCell.h"
#import "SRandom.h"
@interface SBingoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *m_custCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *m_randomButton;
@property (weak, nonatomic) IBOutlet UIButton *m_customButton;
@property (weak, nonatomic) IBOutlet UISwitch *m_modeSwitch;

@property (assign) int m_iLength;
@property (assign) int m_iMaxRange;
@end

@implementation SBingoViewController
{
    SRandom *g_Random;
    BOOL g_bMode;
    NSMutableArray *g_aryShow;
}
static NSString * const s_reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _m_iMaxRange=30;
    _m_iLength=3;
    g_bMode=NO;
    g_aryShow=[NSMutableArray new];
    g_Random=[[SRandom alloc] initWithRange:_m_iMaxRange];
    for (int i=0; i<_m_iLength*_m_iLength; i++) {
        [g_aryShow addObject:g_Random.m_aryRandom];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- btnAction
- (IBAction)randomNumber:(id)sender {
    g_Random=[[SRandom alloc] initWithRange:_m_iMaxRange];
    [self.m_custCollectionView reloadData];
}
- (IBAction)enterNumber:(id)sender {
    [g_Random.m_aryRandom removeAllObjects];
    [self.m_custCollectionView reloadData];
}
- (IBAction)changeMode:(id)sender {
    //bMode=YES,this is game mode.   bMode=NO,this is edit mode.
    g_bMode=[_m_modeSwitch isOn];
    if (g_bMode) {
        _m_customButton.enabled=NO;
        _m_randomButton.enabled=NO;
        
        [self.m_custCollectionView reloadData];
    }else{
        _m_customButton.enabled=YES;
        _m_randomButton.enabled=YES;
        [self.m_custCollectionView reloadData];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _m_iLength*_m_iLength;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SBingoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:s_reuseIdentifier forIndexPath:indexPath];
    
    if (g_Random.m_aryRandom.count==0) {
        cell.m_numberField.text=@"";
    }else{
        cell.m_numberField.text =g_Random.m_aryRandom[indexPath.row];
    }
     if (g_bMode) {
        cell.m_numberField.enabled=NO;
    }else{
        cell.m_numberField.enabled=YES;
        cell.m_numberField.backgroundColor=[UIColor whiteColor];
    }
    cell.m_numberField.delegate=self;
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SBingoCollectionViewCell *cell = (SBingoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (1==cell.m_iFlag) {
        cell.m_iFlag=0;
        cell.m_numberField.backgroundColor = [UIColor whiteColor];
    }else{
        cell.m_iFlag=1;
        cell.m_numberField.backgroundColor = [UIColor colorWithRed:0.333 green:0.996 blue:0.408 alpha:1.000];

    }
}

#pragma mark <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //UITextFiled透過text屬性取得使用者輸入的資料,
    //而後設定於UILabel上顯示。
//    [self.label setText:textField.text];
    
    //textField透過resignFirstResponder方法
    //釋放第⼀一主控權,如此使用者輸入的鍵盤就會消失
    [textField resignFirstResponder];
    return YES;
}


/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */


//  Uncomment this method to specify if the specified item should be selected
// - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
// return YES;
// }


/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */


@end
