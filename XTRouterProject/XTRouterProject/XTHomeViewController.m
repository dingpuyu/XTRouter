//
//  XTHomeViewController.m
//  XTRouterProject
//
//  Created by 丁璞玉 on 2017/11/29.
//  Copyright © 2017年 xiaotei. All rights reserved.
//

#import "XTHomeViewController.h"
#import "XTActionTableViewCell.h"
#import "XTWebViewController.h"
#import "XTRouter.h"

#define kDataSourceFile @"datasource.plist"

@interface XTHomeViewController ()

@property (nonatomic,strong)NSDictionary* dataSourceDict;

@end

@implementation XTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //UIStoryboard* mainSB = [UIStoryboard storyboardWithName:@"" bundle:<#(nullable NSBundle *)#>]
    // Do any additional setup after loading the view.
    //[self.tableView registerNib:[UINib nibWithNibName:@"XTActionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XTActionTableViewCell"];
}

- (NSDictionary *)dataSourceDict{
    if (!_dataSourceDict) {
        _dataSourceDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kDataSourceFile ofType:@""]];
    }
    return _dataSourceDict;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceDict.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XTActionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"XTActionTableViewCell" forIndexPath:indexPath];
    NSString* keyStr = [self.dataSourceDict.allKeys objectAtIndex:indexPath.row];
    cell.actionNameLabel.text = keyStr;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* keyStr = [self.dataSourceDict.allKeys objectAtIndex:indexPath.row];
    NSString* schemaString = [self.dataSourceDict objectForKey:keyStr];
    UIViewController* vc = [[XTRouter shareInstance] controllerWithSchema:schemaString];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



@end
