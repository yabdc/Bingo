//
//  ViewController.m
//  Bingo
//
//  Created by 1500244 on 2015/5/25.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#define BingoCount          3         //賓果要達成的線條數
#define Toolbarheight       44.0f     //toolbar的高
#define MaxValue            50        //可輸入的最大數值
#define BingoLength         3         //賓果的邊長
#define CellNotSelect       0         //cell未選取
#define CellSelected        1         //cell被選取
#define KeyBoardMoveTime    0.25      //鍵盤移動時間
#define BingoNotSelect      @"0"      //尚未選取（陣列用的）
#define BingoSelected       @"1"      //已選取（陣列用的）
#define CellName            @"Cell"   //cell名稱
#define NoNumber            @""       //格子中沒數字


#import "SBingoViewController.h"

#import "SBingoCollectionViewCell.h"
#import "SBingo.h"

#import "UIColor+Extra.h"

@interface SBingoViewController ()<UITextFieldDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *m_custCollectionView;
@property (weak, nonatomic) IBOutlet UIView *m_custView;
@property (weak, nonatomic) IBOutlet UIButton *m_randomButton;
@property (weak, nonatomic) IBOutlet UIButton *m_customButton;
@property (weak, nonatomic) IBOutlet UISwitch *m_modeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *m_promptLabel;


@property (assign) int m_iLength;           //邊長
@property (assign) int m_iMaxRange;         //最大值
@end

@implementation SBingoViewController
{
    SKeyBoardToolBar *m_KeyBoardToolBar;    //鍵盤toolbar
    SCheckBingo *m_CheckBingo;              //檢查賓果物件
    SRandom *m_Random;                      //亂數物件
    NSMutableArray *m_aryShow;              //數字陣列
    NSMutableArray *m_aryBingo;             //賓果陣列
    NSMutableArray *m_aryCell;              //CollectionViewCell陣列
    BOOL m_bMode;                           //模式
    BOOL m_bBingo;                          //賓果
    CGSize m_kbSize;                        //鍵盤size
    CGRect m_oldFrameOfColloctionView;      //暫存CollectionView移動前的位置
    int m_iTextFeildValue;                  //檢查文字暫存值
    int m_iBingoCount;                      //現在賓果的線條數
    int m_iCellNumber;                      //現在所選的cell
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    //註冊鍵盤監聽
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(keyboardWillShow:)
                                          name:UIKeyboardWillShowNotification
                                          object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(keyboardWillHide:)
                                          name:UIKeyboardWillHideNotification
                                          object:nil];
    
    //數據初始化
    self.m_iMaxRange=MaxValue;
    self.m_iLength=BingoLength;
    m_iTextFeildValue=0;
    m_iCellNumber=0;
    m_iBingoCount=0;
    m_bMode=NO;
    m_bBingo=NO;
    m_aryShow=[NSMutableArray new];
    m_aryBingo=[NSMutableArray new];
    m_aryCell=[NSMutableArray new];
    m_kbSize=CGSizeZero;
    m_oldFrameOfColloctionView=CGRectZero;
    m_KeyBoardToolBar=[[SKeyBoardToolBar alloc] initWithWidth:[[UIScreen mainScreen] bounds].size.width];
    for (int i=0; i<_m_iLength*_m_iLength; i++) {
        m_aryBingo[i]=BingoNotSelect;
    }
    m_Random=[[SRandom alloc] initWithRange:_m_iMaxRange];
    m_CheckBingo=[[SCheckBingo alloc] init];
    for (int i=0; i<_m_iLength*_m_iLength; i++) {
        [m_aryShow insertObject:m_Random.g_aryRandom[i] atIndex:i];
    }
    self.m_promptLabel.text=[NSString stringWithFormat:@"%@ %d"
                             ,NSLocalizedString(@"Range", nil),_m_iMaxRange];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    m_oldFrameOfColloctionView=_m_custCollectionView.frame;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    m_oldFrameOfColloctionView=_m_custCollectionView.frame;
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear");
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                         name:UIKeyboardWillShowNotification
                                         object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                         name:UIKeyboardWillHideNotification
                                         object:nil];
}



#pragma mark -- BtnAction
- (IBAction)randomNumber:(id)sender {
    
    m_Random=[[SRandom alloc] initWithRange:_m_iMaxRange];
    for (int i=0; i<_m_iLength*_m_iLength; i++) {
        [m_aryShow removeObjectAtIndex:i];
        [m_aryShow insertObject:m_Random.g_aryRandom[i] atIndex:i];
    }

    [self.m_custCollectionView reloadData];
}

- (IBAction)enterNumber:(id)sender {
    for (int i=0; i<m_aryShow.count; i++) {
        m_aryShow[i]=NoNumber;
    }
    [self.m_custCollectionView reloadData];
}

- (IBAction)changeMode:(id)sender {
    //檢查每格是否有數字
    for (int i=0; i<_m_iLength*_m_iLength; i++) {
        if (YES==![m_aryShow[i] isEqualToString:NoNumber]) {
            //不相同就什麼都不做
        }else{
            [self showAlertView:NSLocalizedString(@"Waining", nil) message:NSLocalizedString(@"AllNumber", nil)];
            [self.m_modeSwitch setOn:NO];
            break;
        }
    }
    //bMode=YES,this is game mode.   bMode=NO,this is edit mode.
    m_bMode=[_m_modeSwitch isOn];
    
    if (YES==m_bMode) {
        for (int i=0; i<_m_iLength*_m_iLength; i++) {
            m_aryBingo[i]=BingoNotSelect;
        }
        self.m_customButton.enabled=NO;
        self.m_randomButton.enabled=NO;
        m_iBingoCount=0;
        self.m_promptLabel.text=[NSString stringWithFormat:@"%@ %d",NSLocalizedString(@"BingoLine", nil),m_iBingoCount];
        [self.m_custCollectionView reloadData];
    }else{
        self.m_promptLabel.text=[NSString stringWithFormat:@"%@ %d",NSLocalizedString(@"Range", nil),_m_iMaxRange];
        m_bBingo=NO;
        self.m_customButton.enabled=YES;
        self.m_randomButton.enabled=YES;
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
    for (int i=0; i<m_aryShow.count; i++) {
        if (i==m_iCellNumber) {
            
        }else{
            if (YES==![strNumber isEqualToString:m_aryShow[i]]) {
                //不相同就什麼都不做
            }else{
            [self showAlertView:NSLocalizedString(@"Waining", nil) message:NSLocalizedString(@"SameNumber", nil)];
            return NO;
            }
        }
    }
    if (YES==[self checkNumber:iNumber]) {
        return YES;
    }else{
        [self showAlertView:NSLocalizedString(@"Waining", nil) message:NSLocalizedString(@"OverRange", nil)];
    }
    return NO;
}

-(void)showAlertView:(NSString *)strTitle message:(NSString *)strMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMessage
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles: nil];
    [alert show];
}


#pragma mark -- BingoMethods

-(void)checkBingo:(NSMutableArray *)aryTestBingo
{
    m_iBingoCount=[m_CheckBingo checkBingo:[aryTestBingo copy] iLength:_m_iLength];
    
    self.m_promptLabel.text=[NSString stringWithFormat:@"%@ %d",NSLocalizedString(@"BingoLine", nil),m_iBingoCount];
    if (m_iBingoCount>=BingoCount) {
        m_bBingo=YES;
        [self showAlertView:NSLocalizedString(@"Bingo", nil)
              message:NSLocalizedString(@"Congratulation", nil)];
        _m_promptLabel.text=[NSString stringWithFormat:@"%@"
                             ,NSLocalizedString(@"Bingo", nil)];
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
    SBingoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellName forIndexPath:indexPath];
    UIColor *borderColor = [UIColor whiteColor];
    [cell.g_imageView.layer setBorderColor:borderColor.CGColor];
    [cell.g_imageView.layer setBorderWidth:1.0];
    cell.g_imageView.layer.cornerRadius = cell.g_imageView.frame.size.width / 2;
    //    cell.g_imageView.clipsToBounds = YES;   //不能超過subView
    //加結束鍵
    cell.g_numberField.inputAccessoryView=m_KeyBoardToolBar;
    
    cell.g_numberField.text =m_aryShow[indexPath.row];
    //是否為遊戲模式
     if (YES==m_bMode) {
        cell.g_numberField.enabled=NO;
    }else{
        cell.g_numberField.enabled=YES;
        cell.g_imageView.backgroundColor=[UIColor whiteColor];
        cell.g_iFlag=0;
    }
    
    cell.g_numberField.delegate=self;
    // Configure the cell
    if(((int)m_aryCell.count)-1<(int)indexPath.row){
        [m_aryCell insertObject:cell atIndex:indexPath.row];
    }else{
        [m_aryCell removeObjectAtIndex:indexPath.row];
        [m_aryCell insertObject:cell atIndex:indexPath.row];
    }

    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (YES==m_bBingo) {
        
    }else{
        if (YES==m_bMode) {
            [m_aryBingo removeObjectAtIndex:indexPath.row];
            SBingoCollectionViewCell *cell = (SBingoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            //flag=1,selected.   flag=0,false
            if (CellSelected==cell.g_iFlag) {
                [m_aryBingo insertObject:BingoNotSelect atIndex:indexPath.row];
                cell.g_iFlag=CellNotSelect;
                cell.g_imageView.backgroundColor = [UIColor whiteColor];
            }else{
                [m_aryBingo insertObject:BingoSelected atIndex:indexPath.row];
                cell.g_iFlag=CellSelected;
                cell.g_imageView.backgroundColor = [UIColor lightGreenColor];
            }
            [self checkBingo:m_aryBingo];
        }
    }
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    int cellWidth=(int)(screenWidth)/_m_iLength;
    return CGSizeMake(cellWidth , cellWidth);
}

#pragma mark <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    SBingoCollectionViewCell *cell = (SBingoCollectionViewCell *)textField.superview.superview;
    m_iTextFeildValue=[cell.g_numberField.text intValue];
    m_iCellNumber=(int)[self.m_custCollectionView indexPathForCell:cell].row;
    SBingoCollectionViewCell *testCell=nil;
    //lock other textfield
    for (int i=0; i<_m_iLength*_m_iLength; i++) {
        testCell=m_aryCell[i];
        if (i==m_iCellNumber) {
            testCell.g_numberField.enabled=YES;
        }else{
            testCell.g_numberField.enabled=NO;
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    SBingoCollectionViewCell *cell = (SBingoCollectionViewCell *)textField.superview.superview;
    m_iCellNumber=(int)[self.m_custCollectionView indexPathForCell:cell].row;
    m_iTextFeildValue=[cell.g_numberField.text intValue];
    SBingoCollectionViewCell *testCell=nil;
    for (int i=0; i<_m_iLength*_m_iLength; i++) {
        testCell=m_aryCell[i];
        testCell.g_numberField.enabled=YES;
    }
    [self.m_custCollectionView reloadData];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark --keyboard method
-(void)touchDoneBarButton{
    SBingoCollectionViewCell *testCell=m_aryCell[m_iCellNumber];
    if (YES==[self checkSameNumber:[testCell.g_numberField.text intValue]]) {
        if (YES==!([m_aryShow[m_iCellNumber]isKindOfClass:[NSNull class]])) {
            [m_aryShow removeObjectAtIndex:m_iCellNumber];
            [m_aryShow insertObject:testCell.g_numberField.text
                            atIndex:m_iCellNumber];
        }else{
            [m_aryShow insertObject:testCell.g_numberField.text
                            atIndex:m_iCellNumber];
        }
        [self.m_custCollectionView reloadData];
        [testCell.g_numberField resignFirstResponder];
        [self.view endEditing:YES];
    }
}
//鍵盤將出現
-(void)keyboardWillShow:(NSNotification*)aNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self.view
                                             selector:@selector(endEditing:)
                                                 name:@"endEditing"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(touchDoneBarButton)
                                                 name:@"touchDoneBarButton"
                                               object:nil];
    m_kbSize=[[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self moveCollectionView:m_kbSize];
    }
//鍵盤將消失
- (void)keyboardWillHide:(NSNotification*)aNotification
{
    m_kbSize=CGSizeZero;
    [self moveCollectionView:m_kbSize];
    [[NSNotificationCenter defaultCenter]removeObserver:self.view
                                                   name:@"endEditing"
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"touchDoneBarButton"
                                                 object:nil];
}
//鍵盤是否遮住輸入格
-(void)moveCollectionView:(CGSize)keyboardSize
{
    CGRect newframe=m_oldFrameOfColloctionView;
    CGFloat moveDistance=0;
    CGFloat scrheight=[[UIScreen mainScreen] bounds].size.height;
    SBingoCollectionViewCell *testCell=m_aryCell[m_iCellNumber];
    CGRect cellframe=testCell.frame;
    if (scrheight-keyboardSize.height-Toolbarheight>cellframe.origin.y+cellframe.size.height) {
        [UIView animateWithDuration:KeyBoardMoveTime animations:^{
            [self.m_custCollectionView setFrame:newframe];
        } completion:^(BOOL finished) {
        }];
    }else{
        //移動
        moveDistance=(cellframe.origin.y+cellframe.size.height)-(scrheight-keyboardSize.height-Toolbarheight);
        newframe.origin.y=newframe.origin.y-moveDistance;
        [UIView animateWithDuration:KeyBoardMoveTime animations:^{
            [self.m_custCollectionView setFrame:newframe];
        } completion:^(BOOL finished) {
        }];
    }
}

@end
