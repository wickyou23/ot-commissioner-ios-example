//
//  ViewController.m
//  TPOpenthreadCommissionerExample
//
//  Created by Thang Phung on 01/11/2022.
//

#import "ViewController.h"
#import "LoadingView.h"
#import <TPOpenthreadCommissioner/TPOpenthreadCommissioner.h>
#import "DetailsViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray* services;

@end

@implementation ViewController {
    TPBorderAgentDiscover* _discover;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _discover = [[TPBorderAgentDiscover alloc] init];
    _services = [NSArray array];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(8, 0, 0, 0)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [LoadingView show];
    __weak typeof(self) weakSelf = self;
    [_discover findBorderRouterServiceWithCompleted:^(NSArray * _Nonnull sevices) {
        typeof(self) strongSelf = weakSelf;
        strongSelf.services = sevices;
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoadingView hide];
            [strongSelf.tableView reloadData];
        });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_services count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (cell == NULL) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyCell"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    TPBorderRouterNetService* service = _services[indexPath.row];
    cell.textLabel.text = service.networkName;
    
    TPIPAddressNetService *ipAddress = service.ipv4.firstObject;
    if (ipAddress == NULL) {
        ipAddress = service.ipv6.firstObject;
    }
    
    if (ipAddress != NULL) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:%ld", ipAddress.ipAddress, ipAddress.port];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TPBorderRouterNetService *service = _services[indexPath.row];
    [self showPassphraseInputWithService:service];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (void)showPassphraseInputWithService:(TPBorderRouterNetService*)service {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Passphrase" message:@"Enter passphrase of border router" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"Passphrase"];
    }];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        typeof(self) strSelf = weakSelf;
        if (strSelf == NULL) {
            return;
        }
        
        UITextField *textField = [alertVC.textFields objectAtIndex:0];
        NSString *passpahrase = textField.text;
        [LoadingView show];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData* pskc = [[TPOTComissionerHelper shared] computePskcWithNetService:service andPassphrase:passpahrase];
            if (!pskc) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LoadingView hide];
                });
                NSLog(@"[ERROR] cannot compute pskc");
                return;
            }

            TPActiveOperationalDataset *dataset = [[TPOTComissionerHelper shared] getActiveOperationalDatasetWithService:service andPSKC:pskc];
            if (dataset == NULL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LoadingView hide];
                });
                NSLog(@"[ERROR] cannot get dataset");
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [LoadingView hide];
                DetailsViewController *detailVC = [DetailsViewController viewControllerWithDataset:dataset];
                [strSelf.navigationController pushViewController:detailVC animated:YES];
            });
        });
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:okAction];
    [alertVC addAction:cancelAction];
    
    [self.navigationController presentViewController:alertVC animated:YES completion:NULL];
}

@end
