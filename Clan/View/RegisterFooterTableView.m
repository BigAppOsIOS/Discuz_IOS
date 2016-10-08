//
//  RegisterFooterTableView.m
//  Clan
//
//  Created by ShiYangtao on 16/9/9.
//  Copyright © 2016年 Youzu. All rights reserved.
//  注册界面TableFooterView
//

#import "RegisterFooterTableView.h"

@interface RegisterFooterTableView ()

@property (nonatomic, strong) UIButton *rulesButton;
@property (nonatomic, strong) UILabel *rulesLabel;
@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, copy) void(^rulesLabelBlock)();
@property (nonatomic, copy) void(^registerActionBlock)();

@end

@implementation RegisterFooterTableView

- (instancetype)initWithFrame:(CGRect)frame rulesLabelBlock:(void(^)())rulesLabelBlock registerActionBlock:(void(^)())registerActionBlock {

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kCOLOR_BG_GRAY;
        [self buildRegisterFooterTableView];
        self.rulesLabelBlock = rulesLabelBlock;
        self.registerActionBlock = registerActionBlock;
    }
    return self;
}

- (void)buildRegisterFooterTableView {

    //条款按钮
    UIView *rulesView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 31)];
    rulesView.backgroundColor = [UIColor clearColor];
    _rulesButton = [[UIButton alloc]initWithFrame:CGRectMake(12, rulesView.height/2 - 10 , 20, 20)];
    [_rulesButton setImage:kIMG(@"gouxuan_acton") forState:UIControlStateNormal];
    [_rulesButton setImage:kIMG(@"gouxuan_unAction") forState:UIControlStateSelected];
    [_rulesButton addTarget:self action:@selector(rulesAction:) forControlEvents:UIControlEventTouchUpInside];
    [rulesView addSubview:_rulesButton];
    //条款label
    _rulesLabel = [[UILabel alloc]initWithFrame:CGRectMake(_rulesButton.right + 3, 0, 200, rulesView.height)];
    _rulesLabel.userInteractionEnabled = YES;
    _rulesLabel.font = [UIFont systemFontOfSize:12.0f];
    _rulesLabel.textColor = UIColorFromRGB(0xff4c4c);
    _rulesLabel.text = @"我同意使用条款隐私政策";
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:_rulesLabel.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x424242) range:NSMakeRange(0, 3)];
    _rulesLabel.attributedText = attributedString;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelAction)];
    [_rulesLabel addGestureRecognizer:tap];
    [rulesView addSubview:_rulesLabel];
    [self addSubview:rulesView];
    //注册按钮
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.frame = CGRectMake(40, kVIEW_BY(rulesView)+16, kSCREEN_WIDTH-80, 45);
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 5, 0, 5);
    UIImage *image = kIMG(@"anniu");
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [_registerButton setBackgroundImage:image forState:UIControlStateNormal];
    [_registerButton setTitleColor:K_COLOR_DARK forState:UIControlStateNormal];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_registerButton];
}

/// 同意条款按钮
- (void)rulesAction:(UIButton *)button {

    _rulesButton.selected = !_rulesButton.selected;
    _registerButton.enabled = !_rulesButton.selected;
}

/// 条款隐私政策
- (void)labelAction {

    self.rulesLabelBlock();
}

/// 注册
- (void)registerAction {

    self.registerActionBlock();
}

@end
