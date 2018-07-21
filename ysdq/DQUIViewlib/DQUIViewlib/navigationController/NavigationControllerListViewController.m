//
//  NavigationControllerListViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2018/7/18.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "NavigationControllerListViewController.h"
#import "NavigationSubViewController.h"
#import "DQNavigationController.h"

@interface NavigationControllerListViewController ()

@end

@implementation NavigationControllerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.title = @"导航标题";
//    self.navigationItem.prompt = @"";
    
    [(DQNavigationController *)self.navigationController navBar];
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"NewTitle"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(description)]];
     
 }

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"dismiss";
    }else{
        return @"push subVC";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NavigationSubViewController *subVC = [[NavigationSubViewController alloc] init];
            [self.navigationController pushViewController:subVC animated:YES];
        } else if (indexPath.row == 1) {
            NavigationSubViewController *subVC = [[NavigationSubViewController alloc] init];
            [self.navigationController pushViewController:subVC animated:YES];
        } else {
            NavigationSubViewController *subVC = [[NavigationSubViewController alloc] init];
            [self.navigationController pushViewController:subVC animated:YES];
        }
    }else {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}



@end
