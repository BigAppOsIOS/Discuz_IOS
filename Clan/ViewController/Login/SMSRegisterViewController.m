//
//  SMSRegisterViewController.m
//  Clan
//
//  Created by ZRFlower on 16/9/8.
//  Copyright © 2016年 Youzu. All rights reserved.
//  短信注册
//

#import "SMSRegisterViewController.h"
#import "RulesViewController.h"
#import "SMSRegisterCell.h"
#import "LoginViewModel.h"
#import "RegisterFooterTableView.h"

@interface SMSRegisterViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LoginViewModel *loginViewModel;

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *confirmPassword;
@property (nonatomic, strong) NSString *smsCode;

@end

@implementation SMSRegisterViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.title = @"注册";
    self.view.backgroundColor = kCOLOR_BG_GRAY;
    self.loginViewModel = [[LoginViewModel alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 31, ScreenWidth, ScreenBoundsHeight - 31) style:UITableViewStylePlain];
    _tableView.backgroundColor = kCOLOR_BG_GRAY;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    WEAKSELF;
    RegisterFooterTableView *tableFooterView = [[RegisterFooterTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 92) rulesLabelBlock:^{
        [weakSelf labelAction];
    } registerActionBlock:^{
        [weakSelf requestRegister];
    }];
    self.tableView.tableFooterView = tableFooterView;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
}

- (void)dealloc {

    _loginViewModel = nil;
    DLog(@"SMSRegisterViewController dealloc");
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SMSCellType cellType;
    if (indexPath.row == 0) {
        cellType = SMSCellTypeMobile;
    }else if (indexPath.row == 1) {
        cellType = SMSCellTypeUserName;
    }else if (indexPath.row == 2) {
        cellType = SMSCellTypeEmail;
    }else if (indexPath.row == 3) {
        cellType = SMSCellTypePassword;
    }else if (indexPath.row == 4) {
        cellType = SMSCellTypeConfirmPassword;
    }else {
        cellType = SMSCellTypeSMSCode;
    }
    
    WEAKSELF;
    SMSRegisterCell *cell = [SMSRegisterCell smsRegisterCellWithTableView:tableView cellType:cellType textFieldChangedBlock:^(NSString *text) {
        [weakSelf handleTextFieldWithText:text cellType:cellType];
    }];
    if (cellType == SMSCellTypeSMSCode) {
        cell.requestSMSCodeBlock = ^{
            [weakSelf requestSMSCode];
        };
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 45.0f;
}

#pragma mark - Private Methods
/// 获取验证码
- (void)requestSMSCode {

    [self.view endEditing:YES];
    [_loginViewModel request_Register_SMSCodeWithMobile:self.mobile zone:@"86" customIdentifier:nil completeBlock:^(NSError *error) {
        
    }];
}

///验证验证吗是否正确
- (void)requestRegister {

    [self.view endEditing:YES];
    WEAKSELF;
    [_loginViewModel request_VerifySMSCodeWithsmsCode:self.smsCode mobile:self.mobile zone:@"86" completeBlock:^(NSError *error) {
        if (!error) {
            __weak typeof(_loginViewModel) weakLoginViewModel = _loginViewModel;
            STRONGSELF;
            [weakLoginViewModel request_Register_WithUserName:strongSelf.userName andPassWord:strongSelf.password andPassword2:strongSelf.confirmPassword andEmail:strongSelf.email andFid:@""];
            [weakLoginViewModel setBlockWithReturnBlock:^(id returnValue) {
                [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            } WithErrorBlock:nil];
        }
    }];    
}

/// 获取相应的textField的值
- (void)handleTextFieldWithText:(NSString *)text cellType:(SMSCellType)cellType {
    
    if (cellType == SMSCellTypeMobile) {
        self.mobile = text;
    }else if (cellType == SMSCellTypeUserName) {
        self.userName = text;
    }else if (cellType == SMSCellTypeEmail) {
        self.email = text;
    }else if (cellType == SMSCellTypePassword) {
        self.password = text;
    }else if (cellType == SMSCellTypeConfirmPassword) {
        self.confirmPassword = text;
    }else if (cellType == SMSCellTypeSMSCode) {
        self.smsCode = text;
    }
}

#pragma mark - Action Methods
/// 条款隐私政策
- (void)labelAction{
    RulesViewController *rulesVC = [[RulesViewController alloc]init];
    [self.navigationController pushViewController:rulesVC animated:YES];
}

@end
