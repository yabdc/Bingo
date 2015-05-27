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
    //數據初始化
    _m_iMaxRange=30;
    _m_iLength=3;
    g_bMode=NO;
    g_aryShow=[NSMutableArray new];
    g_Random=[[SRandom alloc] initWithRange:_m_iMaxRange];
    for (int i=0; i<_m_iLength*_m_iLength; i++) {
        [g_aryShow insertObject:g_Random.m_aryRandom[i] atIndex:i];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- BtnAction
- (IBAction)randomNumber:(id)sender {
    g_Random=[[SRandom alloc] initWithRange:_m_iMaxRange];
    for (int i=0; i<_m_iLength*_m_iLength; i++) {
        [g_aryShow removeObjectAtIndex:i];
        [g_aryShow insertObject:g_Random.m_aryRandom[i] atIndex:i];
    }
    [self.m_custCollectionView reloadData];
}

- (IBAction)enterNumber:(id)sender {
    for (int i=0; i<g_aryShow.count; i++) {
        g_aryShow[i]=@"";
    }
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

#pragma mark --Method

-(BOOL)checkNumber:(int)iNumber{
    if (iNumber>=1 && iNumber<=_m_iMaxRange) {
        return YES;
    }else{
        return NO;
    }
}

-(void)showAlertView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Waining"
                                                    message:@"please enter the number between 1 to 30."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];  // 把alert這個物件秀出來
}

- (void)addDoneButton:(UITextField *)TextField{

    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self.view action:@selector(endEditing:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    TextField.inputAccessoryView = keyboardToolbar;
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
    [self addDoneButton:cell.m_numberField];
    if (g_aryShow.count==0) {
        cell.m_numberField.text=@"";
    }else{
        cell.m_numberField.text =g_aryShow[indexPath.row];
    }
     if (g_bMode) {
        cell.m_numberField.enabled=NO;
    }else{
            cell.m_numberField.enabled=YES;
            cell.m_numberField.backgroundColor=[UIColor whiteColor];
    }
    cell.m_numberField.delegate=self;
    // Configure the cell
    cell.m_numberField.keyboardType = UIKeyboardTypeNumberPad;
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
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    SBingoCollectionViewCell *cell = (SBingoCollectionViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [self.m_custCollectionView indexPathForCell:cell];
    if ([self checkNumber:[cell.m_numberField.text intValue]]) {
        if (!([g_aryShow[indexPath.row]isKindOfClass:[NSNull class]])) {
            [g_aryShow removeObjectAtIndex:indexPath.row];
            [g_aryShow insertObject:cell.m_numberField.text atIndex:indexPath.row];
        }else{
            [g_aryShow insertObject:cell.m_numberField.text atIndex:indexPath.row];
        }
        [self.m_custCollectionView reloadData];
        [textField resignFirstResponder];
    }else{
        [self.m_custCollectionView reloadData];
        [textField resignFirstResponder];
        [self showAlertView];
    }
    
}

@end
