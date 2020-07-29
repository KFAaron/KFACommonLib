//
//  KFAAttributeLabelController.m
//  KFACommonLibDemo
//
//  Created by KFAaron on 2019/2/14.
//  Copyright © 2019 KFAaron. All rights reserved.
//

#import "KFAAttributeLabelController.h"
#import "KFABasicMacro.h"
#import "UIView+KFAAdditions.h"
#import "KFAAttributeLabel.h"
#import "UITextField+KFAPlaceholder.h"

@interface KFAAttributeLabelController ()
{
//    UILabel *_numLbl;
    UIButton *_addBtn;
    UIButton *_minusBtn;
    UITextField *_numLbl;
    
    KFAAttributeLabel *_demoLbl;
}

@end

@implementation KFAAttributeLabelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)prepareUI {
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-70)/2, 80, 70, 30)];
    titleLbl.text = @"行数：";
    titleLbl.textColor = [UIColor orangeColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLbl];
//    UILabel *numLbl = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-50)/2, 120, 50, 30)];
//    numLbl.text = @"0";
//    numLbl.textColor = [UIColor redColor];
//    numLbl.textAlignment = NSTextAlignmentCenter;
    UITextField *numLbl = [[UITextField alloc] initWithFrame:CGRectMake((kScreenWidth-50)/2, 120, 50, 30)];
    numLbl.borderStyle = UITextBorderStyleRoundedRect;
//    numLbl.text = @"0";
    numLbl.textColor = [UIColor redColor];
    numLbl.textAlignment = NSTextAlignmentCenter;
    
    numLbl.placeholder = @"请输入行数";
    numLbl.placeholderColor = [UIColor greenColor];
    numLbl.placeholderFont = [UIFont systemFontOfSize:30];
    
    
    [self.view addSubview:numLbl];
    _numLbl = numLbl;
    
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minusBtn.frame = CGRectMake(numLbl.kfa_left-30-30, 120, 30, 30);
    [minusBtn setTitle:@"减" forState:UIControlStateNormal];
    [minusBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [minusBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
    [minusBtn addTarget:self action:@selector(minusLine:) forControlEvents:UIControlEventTouchUpInside];
    minusBtn.enabled = NO;
    [self.view addSubview:minusBtn];
    _minusBtn = minusBtn;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(numLbl.kfa_right+30, 120, 30, 30);
    [addBtn setTitle:@"加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
    [addBtn addTarget:self action:@selector(addLine:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    _addBtn = addBtn;
    
    KFAAttributeLabel *demoLbl = [[KFAAttributeLabel alloc] initWithFrame:CGRectMake(28, numLbl.kfa_bottom+100, kScreenWidth-56, kScreenHeight-numLbl.kfa_bottom-100-100)];
    demoLbl.backgroundColor = [UIColor clearColor];
    demoLbl.textColor = [UIColor blackColor];
    demoLbl.font = [UIFont systemFontOfSize:14];
    demoLbl.textAlignment = kCTTextAlignmentLeft;
    demoLbl.numberOfLines = 0;
    [self.view addSubview:demoLbl];
    _demoLbl = demoLbl;
    
    UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, 41, 16)];
    tagView.backgroundColor = [UIColor redColor];
    tagView.alpha = 0.5;
    [_demoLbl setText:@"中国北京天津上海重庆广东江苏浙江山东湖南湖北江西福建广西云南西藏新疆内蒙古黑龙江吉林辽宁河北河南山西陕西宁夏甘肃四川安徽贵州海南"];
    [_demoLbl appendView:tagView margin:UIEdgeInsetsMake(0, 4, 0, 0) alignment:KFAAttributeAlignmentCenter];
}

#pragma mark - Actions

- (void)addLine:(id)sender {
    
    NSInteger num = _numLbl.text.integerValue + 1;
    _numLbl.text = @(num).stringValue;
    
    _minusBtn.enabled = num > 0;
    
    _demoLbl.numberOfLines = num;
    _demoLbl.kfa_height = [self heightForOneLine]*num;
    [_demoLbl resetTextFrame];
}

- (void)minusLine:(id)sender {
    
    NSInteger num = _numLbl.text.integerValue - 1;
    _numLbl.text = num==0?nil:@(num).stringValue;
    
    _minusBtn.enabled = num > 0;
    
    _demoLbl.numberOfLines = num;
    if (num > 0) {
        _demoLbl.kfa_height = [self heightForOneLine]*num;
    } else {
        _demoLbl.kfa_height = kScreenHeight-_numLbl.kfa_bottom-100-100;
    }
    [_demoLbl resetTextFrame];
}

- (CGFloat)heightForOneLine {
    
    CGRect rect = [@"一行" boundingRectWithSize:CGSizeMake(kScreenWidth-56, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return ceilf(rect.size.height);
}

@end
