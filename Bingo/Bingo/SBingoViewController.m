//
//  ViewController.m
//  Bingo
//
//  Created by 1500244 on 2015/5/25.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#define BingoCount 3            //賓果要達成的線條數
#define iphone4sHeight 480.0f

#import "SBingoViewController.h"
#import "SBingoCollectionViewCell.h"
#import "SRandom.h"
@interface SBingoViewController ()<UITextFieldDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *m_custCollectionView;
@property (weak, nonatomic) IBOutlet UIView *m_custView;
@property (weak, nonatomic) IBOutlet UIButton *m_randomButton;
@property (weak, nonatomic) IBOutlet UIButton *m_customButton;
@property (weak, nonatomic) IBOutlet UISwitch *m_modeSwitch;

@property (assign) int m_iLength;           //邊長
@property (assign) int m_iMaxRange;         //最大值
@property (assign) int m_iTextFeildValue;   //檢查文字暫存值
@property (assign) int m_iCellNumber;       //現在所選的cell
@property (assign) int m_iBingoCount;       //現在賓果的線條數


@end

@implementation SBingoViewController
{
    SRandom *g_Random;  //亂數物件
    NSMutableArray *g_aryShow;  //數字陣列
    NSMutableArray *g_aryBingo; //賓果陣列
    NSMutableArray *g_aryCell;  //CollectionViewCell陣列
    BOOL g_bMode;   //模式
    BOOL g_bBingo;  //賓果
    CGSize kbSize;  //鍵盤size
    CGRect oldframe;//暫存CollectionView移動前的位置
    
}

static NSString * const s_reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    //數據初始化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _m_iMaxRange=30;
    _m_iLength=3;
    _m_iTextFeildValue=0;
    _m_iCellNumber=0;
    _m_iBingoCount=0;
    g_bMode=NO;
    g_bBingo=NO;
    g_aryShow=[NSMutableArray new];
    g_aryBingo=[NSMutableArray new];
    g_aryCell=[NSMutableArray new];
    kbSize=CGSizeZero;
    for (int i=0; i<_m_iLength*_m_iLength; i++) {
        g_aryBingo[i]=@"0";
        g_aryCell[i]=@"0";
    }
    
    g_Random=[[SRandom alloc] initWithRange:_m_iMaxRange];
    for (int i=0; i<_m_iLength*_m_iLength; i++) {
        [g_aryShow insertObject:g_Random.m_aryRandom[i] atIndex:i];
    }
  
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //設定colloctionView
    CGRect newframe=_m_custCollectionView.frame;
    newframe.size.height=[[UIScreen mainScreen] bounds].size.width;
    [_m_custCollectionView setFrame:newframe];
    
    //設定View
    if (iphone4sHeight==[[UIScreen mainScreen] bounds].size.height) {
        CGRect newframe=_m_custCollectionView.frame;
        CGRect newframe2=_m_custView.frame;
        newframe2.size.height =[[UIScreen mainScreen] bounds].size.width;
        newframe2.origin.y=newframe.size.height+newframe.origin.y-20;
        [_m_custView setFrame:newframe2];
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
        g_bBingo=NO;
        _m_iBingoCount=0;
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

-(BOOL)checkSameNumber:(int)iNumber{
    NSString *strNumber=[NSString stringWithFormat:@"%d",iNumber];
    for (int i=0; i<g_aryShow.count; i++) {
        if (_m_iCellNumber==i) {
            
        }else{
            if (![strNumber isEqualToString:g_aryShow[i]]) {
                //不相同就什麼都不做
            }else{
            [self showAlertView2];
            return NO;
            }
        }
    }
    if ([self checkNumber:iNumber]) {
        return YES;
    }else{
        [self showAlertView];
    }
    return NO;
}


-(void)showAlertView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Waining"
                                                    message:@"please enter the number between 1 to 30."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

-(void)showAlertView2{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Waining"
                                                    message:@"Can't enter the same number"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)addDoneButton:(UITextField *)TextField{

    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                      target:self.view action:@selector(endEditing:)];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(endEditTextField)];
    keyboardToolbar.items = @[cancelBarButton,flexBarButton, doneBarButton];
    TextField.inputAccessoryView = keyboardToolbar;
}

-(void)endEditTextField{
    SBingoCollectionViewCell *testCell=g_aryCell[_m_iCellNumber];
    if ([self checkSameNumber:[testCell.m_numberField.text intValue]]) {
        if (!([g_aryShow[_m_iCellNumber]isKindOfClass:[NSNull class]])) {
            [g_aryShow removeObjectAtIndex:_m_iCellNumber];
            [g_aryShow insertObject:testCell.m_numberField.text atIndex:_m_iCellNumber];
        }else{
            [g_aryShow insertObject:testCell.m_numberField.text atIndex:_m_iCellNumber];
        }
        [self.m_custCollectionView reloadData];
        [testCell.m_numberField resignFirstResponder];
        [self.view endEditing:YES];
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
    
    //加結束鍵
    [self addDoneButton:cell.m_numberField];
    //判斷是否沒資料
    if (g_aryShow.count==0) {
        cell.m_numberField.text=@"";
    }else{
        cell.m_numberField.text =g_aryShow[indexPath.row];
    }
    //是否為遊戲模式
     if (g_bMode) {
        cell.m_numberField.enabled=NO;
    }else{
            cell.m_numberField.enabled=YES;
            cell.m_numberField.backgroundColor=[UIColor whiteColor];
    }
    
    cell.m_numberField.delegate=self;
    // Configure the cell
    
    [g_aryCell removeObjectAtIndex:indexPath.row];
    [g_aryCell insertObject:cell atIndex:indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (g_bMode) {
        [g_aryBingo removeObjectAtIndex:indexPath.row];
        SBingoCollectionViewCell *cell = (SBingoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        //flag=1,selected.   flag=0,false
        if (1==cell.m_iFlag) {
            [g_aryBingo insertObject:@"0" atIndex:indexPath.row];
            cell.m_iFlag=0;
            cell.m_numberField.backgroundColor = [UIColor whiteColor];
        }else{
            [g_aryBingo insertObject:@"1" atIndex:indexPath.row];
            cell.m_iFlag=1;
            cell.m_numberField.backgroundColor = [UIColor colorWithRed:0.333 green:0.996 blue:0.408 alpha:1.000];
        }
        NSLog(@"%@",g_aryBingo);
        [self checkBingo:g_aryBingo];
    }
    
}

-(void)checkBingo:(NSMutableArray *)aryTestBingo
{
    _m_iBingoCount=0;
    int iRowCount;
    int iSlash=0;
    int iBackSlash=0;
    //檢查橫列
    for (int i=0; i<_m_iLength; i++) {
            iRowCount=0;
        for (int j=0;j<_m_iLength; j++) {
            NSString *str=aryTestBingo[i*_m_iLength+j];
            iRowCount += [str intValue];
            if (_m_iLength==iRowCount) {
                _m_iBingoCount++;
            }
        }
    }
    //檢查直行
    for (int i=0; i<_m_iLength; i++) {
        iRowCount=0;
        for (int j=0;j<_m_iLength; j++) {
            NSString *str=aryTestBingo[i+j*_m_iLength];
            iRowCount += [str intValue];
            if (_m_iLength==iRowCount) {
                _m_iBingoCount++;
            }
        }
    }
    //檢查反斜線
    for (int i=0; i<_m_iLength; i++) {
        for (int j=0;j<_m_iLength; j++) {
            if (i==j) {
                NSString *str=aryTestBingo[(i*_m_iLength+i)];
                iBackSlash += [str intValue];
                if (_m_iLength==iBackSlash) {
                    _m_iBingoCount++;
                }

            }
        }
    }
    //檢查斜線
    for (int i=0; i<_m_iLength; i++) {
        for (int j=0;j<_m_iLength; j++) {
            if ((i+1)*(_m_iLength-1)==i*_m_iLength+j) {
                NSString *str=aryTestBingo[(i*_m_iLength+j)];
                iSlash += [str intValue];
                if (_m_iLength==iSlash) {
                    _m_iBingoCount++;
                }
                
            }
        }
    }
    if (_m_iBingoCount==BingoCount) {
        g_bBingo=YES;
    }
    
    
    NSLog(@"%d",_m_iBingoCount);
    
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat cellWidth=(screenWidth)/_m_iLength;
    return CGSizeMake(cellWidth , cellWidth);
}
#pragma mark <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    SBingoCollectionViewCell *cell = (SBingoCollectionViewCell *)textField.superview.superview;
    _m_iCellNumber=(int)[self.m_custCollectionView indexPathForCell:cell].row;
    SBingoCollectionViewCell *testCell=nil;
    for (int i=0; i<_m_iLength*_m_iLength; i++) {
        testCell=g_aryCell[i];
        if (i==_m_iCellNumber) {
            testCell.m_numberField.enabled=YES;
        }else{
            testCell.m_numberField.enabled=NO;
        }
    }
    _m_iTextFeildValue=[cell.m_numberField.text intValue];
    _m_randomButton.enabled=NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    SBingoCollectionViewCell *cell = (SBingoCollectionViewCell *)textField.superview.superview;
    _m_iCellNumber=(int)[self.m_custCollectionView indexPathForCell:cell].row;
    _m_iTextFeildValue=[toBeString intValue];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    SBingoCollectionViewCell *cell = (SBingoCollectionViewCell *)textField.superview.superview;
    _m_randomButton.enabled=YES;
    _m_iCellNumber=(int)[self.m_custCollectionView indexPathForCell:cell].row;
    _m_iTextFeildValue=[cell.m_numberField.text intValue];
   
    SBingoCollectionViewCell *testCell=nil;
    for (int i=0; i<_m_iLength*_m_iLength; i++) {
        testCell=g_aryCell[i];
        testCell.m_numberField.enabled=YES;
    }
    [self.m_custCollectionView reloadData];
    

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark --keyboard method
-(void)keyboardWillShow:(NSNotification*)aNotification
{
    NSLog(@"Show");
    kbSize=[[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
     NSLog(@"Hide");
    kbSize=CGSizeZero;
}

-(void)moveCollectionView:(CGSize)keyboardSize
{
    
}

@end
