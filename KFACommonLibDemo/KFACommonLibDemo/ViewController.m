//
//  ViewController.m
//  KFACommonLibDemo
//
//  Created by KFAaron on 2019/2/13.
//  Copyright © 2019 KFAaron. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+KFASafe.h"

@interface ViewController ()

@property (nonatomic, copy) NSArray *datasource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UITableViewDelegate and UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = [self.datasource kfa_objectAtIndex:indexPath.row];
    NSString *title = dic[@"title"];
    cell.textLabel.text = title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 12;
    }
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.datasource kfa_objectAtIndex:indexPath.row];
    NSString *className = dic[@"vc"];
    NSString *title = dic[@"title"];
    Class vcClass = NSClassFromString(className);
    UIViewController *vc = [[vcClass alloc] init];
    vc.title = title;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Properties

- (NSArray *)datasource {
    if (!_datasource) {
        _datasource = @[@{@"title":@"KFAAttributeLabel",@"vc":@"KFAAttributeLabelController"}];
    }
    return _datasource;
}

@end
