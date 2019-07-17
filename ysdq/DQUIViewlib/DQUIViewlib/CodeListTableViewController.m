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
                       @[@"ViewTypeEdgeBorderView",@"SwitchControlView",@"ViewHitTestEvent",@"ViewTypeStackView",
                         @"ViewTypeCustomFont"],
                       @[@"NSMutableArray-changeDo"],
                       @[@"NS_FORMAT_FUNCTION"]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Present-vc";
    } else if(section == 0){
        return @"Navigation-push";
    } else if (section == 2) {
        return @"Custom-Views";
    } else if (section == 3) {
        return @"Data_Structure";
    } else if (section == 4) {
        return @"function_args_Format";
    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listItems count];
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
    NSString *itemName = self.listItems[indexPath.section][indexPath.row];
    UIViewController *desVc = [NSClassFromString(itemName) new];
    if ([desVc isKindOfClass:[UIViewController class]]) {
        desVc.title = itemName;
        if (indexPath.section == 1) {
            [self presentViewController:desVc animated:YES completion:nil];
        }else {
            [self.navigationController pushViewController:desVc animated:YES];
        }
    } else {
        APIControlViewController *apiControlVC = [APIControlViewController new];
        if ([itemName isEqualToString:@"ViewTypeEdgeBorderView"]) {
            apiControlVC.viewType = ViewTypeEdgeBorderView;
        }else if ([itemName isEqualToString:@"SwitchControlView"]) {
            apiControlVC.viewType = ViewTypeSwitchControlView;
        }else if ([itemName isEqualToString:@"ViewHitTestEvent"]) {
            apiControlVC.viewType = ViewTypeViewHitTestEvent;
        }else if ([itemName isEqualToString:@"ViewTypeStackView"]){
            apiControlVC.viewType = ViewTypeViewStackView;
        } else if ([itemName isEqualToString:@"ViewTypeCustomFont"]){
            apiControlVC.viewType = ViewTypeCustomFont;
        }
        
        else if ([itemName isEqualToString:@"NSMutableArray-changeDo"]) {
            apiControlVC.viewType = ViewTypeSystemNSMutableArray;
        }else if ([itemName isEqualToString:@"NS_FORMAT_FUNCTION"]) {
            apiControlVC.viewType = ViewTypeNS_FORMAT_FUNCTION;
        }
        [self.navigationController pushViewController:apiControlVC animated:YES];
    }
}


@end
