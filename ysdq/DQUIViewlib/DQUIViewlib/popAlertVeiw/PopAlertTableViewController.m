//
//  PopAlertTableViewController.m
//  DQUIViewlib
//
//  Created by lxw on 2019/1/22.
//  Copyright © 2019 lxw. All rights reserved.
//

#import "PopAlertTableViewController.h"
#import "PopAlertManager.h"
#import "CustomerPopAlertViewController.h"
#import "MessageInputAlertView.h"
#import "BasePopView.h"

typedef NS_ENUM(NSUInteger, PopAlertType) {
    PopAlertTypeSystemSureChoose = 1,
    PopAlertTypeSystemTextInput,
    PopAlertTypeCustomVC,
    PopAlertTypeMessageInput,
    PopAlertTypeDecision,
    PopAlertTypeDeviceSet,
    PopAlertTypeNotificationSet
};

@interface PopAlertTableViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) PopAlertManager  *alertMan;
@end

@implementation PopAlertTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray
    = @[
        @{@(PopAlertTypeSystemSureChoose) : @"sysytemAlert-SureChoose"},
        @{@(PopAlertTypeSystemTextInput) : @"systemALert_TextInput"},
        @{@(PopAlertTypeCustomVC) : @"customAlert_VC"},
        @{@(PopAlertTypeMessageInput) : @"customInputPopView"},
        @{@(PopAlertTypeDecision) : @"customAlert_Decision"},
        @{@(PopAlertTypeDeviceSet) : @"PopAlertTypeDeviceSet"},
        @{@(PopAlertTypeNotificationSet) : @"PopAlertTypeNotificationSet"},
        ];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listCell"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    NSDictionary *menuDict = self.dataArray[indexPath.row];
    cell.textLabel.text = [menuDict objectForKey:menuDict.allKeys.firstObject];
        // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *menuDict = self.dataArray[indexPath.row];
    PopAlertType type = [[menuDict allKeys].firstObject integerValue];
    switch (type) {
        case PopAlertTypeSystemSureChoose:
            [self systemAlertSureChoose];
            break;
        case PopAlertTypeSystemTextInput:
            [self systemAlertTextInput];
            break;
            case PopAlertTypeCustomVC:
            [self customerAlertViewController];
            break;
            case PopAlertTypeMessageInput:
            [self customerAlertMessageIputView];
            break;
            case PopAlertTypeDecision:
            [self customerAlertDecision];
            break;
            case PopAlertTypeDeviceSet:
            [self popToDeviceSetPage];
            break;
            case PopAlertTypeNotificationSet:
            [self popToNotificationSetPage];
        default:
            break;
    }
}

- (void)systemAlertSureChoose {
    PopAlertAction *cancelAlertAct = [[PopAlertAction alloc] init];
    cancelAlertAct.title = @"取消";
    cancelAlertAct.style = UIAlertActionStyleDefault;
    PopAlertAction *allowAlertAct = [[PopAlertAction alloc] init];
    allowAlertAct.title = @"清空";
    allowAlertAct.style = UIAlertActionStyleDefault;
    __weak __typeof(self)weakSelf = self;
    allowAlertAct.block = ^(id sender) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf action:sender];
    };
    self.alertMan = [[PopAlertManager alloc] init];
    NSString *msg = @"您确定要清空所有搜索记录吗？";
    [self.alertMan alertMessage:msg title:@"清空" actions:@[cancelAlertAct, allowAlertAct] presentViewController:self];
}

- (void)systemAlertTextInput {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"我是标题" message:@"显示x信息内容" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
        [self action:action];
    }];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Default" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Default");
        [self action:action];
    }];
    UIAlertAction *destructionAction = [UIAlertAction actionWithTitle:@"Destructive" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Destructive");
        [self action:action];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:defaultAction];
    [alertController addAction:destructionAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入什么内容吧";
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)customerAlertViewController {
    CustomerPopAlertViewController *cuctomPAVC = [CustomerPopAlertViewController new];
    
    [self presentViewController:cuctomPAVC animated:YES completion:nil];
}

- (void)customerAlertMessageIputView {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat alertW = 290;
    CGFloat alertH = 280;
    CGRect alertRect =  CGRectMake((screenW - alertW)/2, (screenH - alertH)/2,alertW, alertH);
    BasePopView *popView = [[BasePopView alloc] initWithFrame:alertRect];
    popView.type = BasePopTypeFade;
    
    MessageInputAlertView *msgInputAlert = [[MessageInputAlertView alloc] initWithFrame:alertRect];
    [msgInputAlert setAlertAction:^(MessageInputAlertView *alertView, MSGInputAlertEvent event) {
        if (event == MSGInputAlertEventClose) {
            [popView cancel];
        }else if (event == MSGInputAlertEventSubmit) {
            NSLog(@"submit");
        }
    }];
    popView.popContentView = [[UIView alloc] initWithFrame:alertRect];
    [popView.popContentView addSubview:msgInputAlert];
    [msgInputAlert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(popView.popContentView);
    }];
    [popView.popContentView setBackgroundColor:[UIColor blueColor]];
    [popView show];
}

- (void)customerAlertDecision {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat alertW = 272;
    CGFloat alertH = 180;
    CGRect alertRect =  CGRectMake((screenW - alertW)/2, (screenH - alertH)/2,alertW, alertH);
    BasePopView *popView = [[BasePopView alloc] initWithFrame:alertRect];
    popView.type = BasePopTypeFade;
    popView.center = self.view.center;
    DecisionAlertView *alertView = [[DecisionAlertView alloc] initWithFrame:alertRect title:@"清空" desc:@"确定清空搜索记录吗？" decision:^(BOOL confirm) {
        [popView cancel];
        if (confirm) {
            NSLog(@"decision confirm");
        }else{
            NSLog(@"decision concel");
        }
    }];
    popView.popContentView = [[UIView alloc] initWithFrame:alertRect];
    [popView.popContentView addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(popView.popContentView);
    }];
    [popView.popContentView setBackgroundColor:[UIColor blueColor]];
    [popView show];
}
- (void)popToDeviceSetPage {
    if (UIApplicationOpenSettingsURLString != NULL) {
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [application openURL:URL options:@{} completionHandler:nil];
            } else {
                    // Fallback on earlier versions
            }
        } else {
            [application openURL:URL];
        }
    }
}

- (void)popToNotificationSetPage {
    if (UIApplicationOpenSettingsURLString != NULL) {
        UIApplication *application = [UIApplication sharedApplication];
    /*!
     在项目中的info中添加 URL types
     添加 URL Schemes 为 prefs的url
     */
//        NSURL *URL = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID&path=fmy.DQUIViewlib"];
        NSURL *URL = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                    NSLog(@"");
                }];
            } else {
                    // Fallback on earlier versions
            }
        } else {
            [application openURL:URL];
        }
    }
}

- (void)action:(id)sender {
    
}

@end
