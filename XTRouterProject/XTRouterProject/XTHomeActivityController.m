//
//  XTHomeActivityController.m
//  XTRouterProject
//
//  Created by 丁璞玉 on 2017/11/29.
//  Copyright © 2017年 xiaotei. All rights reserved.
//

#import "XTHomeActivityController.h"
#import "UIColor+Hex.h"

@interface XTHomeActivityController ()

@property (nonatomic,weak)UILabel* colorLabel;

@end

@implementation XTHomeActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
}

- (void)initUI{
    _pageTitle.length>0?(self.title = _pageTitle):(self.title = @"默认标题");
    _backColor.length > 0?(self.view.backgroundColor = [UIColor colorWithHexString:_backColor]):(self.view.backgroundColor = [UIColor whiteColor]);
}

- (void)initData{
    self.colorLabel.text = _backColor;
}

- (UILabel *)colorLabel{
    if (!_colorLabel) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 55)];
        [self.view addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:22];
        _colorLabel = label;
    }
    return _colorLabel;
}

@end
