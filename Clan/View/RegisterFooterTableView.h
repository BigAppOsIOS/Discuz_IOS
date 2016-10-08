//
//  RegisterFooterTableView.h
//  Clan
//
//  Created by ShiYangtao on 16/9/9.
//  Copyright © 2016年 Youzu. All rights reserved.
//  注册界面TableFooterView
//

#import <UIKit/UIKit.h>

@interface RegisterFooterTableView : UIView

- (instancetype)initWithFrame:(CGRect)frame rulesLabelBlock:(void(^)())rulesLabelBlock registerActionBlock:(void(^)())registerActionBlock;

@end
