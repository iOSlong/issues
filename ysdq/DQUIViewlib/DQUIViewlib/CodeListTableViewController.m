//
//  CodeListTableViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2019/1/18.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "CodeListTableViewController.h"
#import "PopAlertTableViewController.h"
#import "PresentVCMode/PresentRouterControlViewController.h"
#import "APIControlViewController.h"

@interface CodeListTableViewController ()
@property (nonatomic, strong) NSArray *listItems;
@end

@implementation CodeListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"CodeListItem";
    
    self.listItems = @[@[@"CollectionViewListController",@"PopAlertTableViewController",@"PresentRouterControlViewController",@"STMAssembleViewController"],
  @[@"PresentRouterControlViewController"],
                       @[@"ViewTypeEdgeBorderView",@"SwitchControlView"]];
    
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Present-vc";
    }else if(section == 0){
        return @"Navigation-push";
    }else if (section == 2) {
        return @"Custom-Views";
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listItems[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    NSString *vcName = self.listItems[indexPath.section][indexPath.row];
    cell.textLabel.text = vcName;
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *vcName = self.listItems[indexPath.section][indexPath.row];
    UIViewController *desVc = [NSClassFromString(vcName) new];
    if ([desVc isKindOfClass:[UIViewController class]]) {
        desVc.title = vcName;
        if (indexPath.section == 1) {
            [self presentViewController:desVc animated:YES completion:nil];
        }else {
            [self.navigationController pushViewController:desVc animated:YES];
        }
    } else {
        APIControlViewController *apiControlVC = [APIControlViewController new];
        if ([vcName isEqualToString:@"ViewTypeEdgeBorderView"]) {
            apiControlVC.viewType = ViewTypeEdgeBorderView;
        }else if ([vcName isEqualToString:@"SwitchControlView"]) {
            apiControlVC.viewType = ViewTypeSwitchControlView;
        }
        [self.navigationController pushViewController:apiControlVC animated:YES];
    }
}


@end
