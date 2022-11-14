//
//  DetailsViewController.m
//  TPOpenthreadCommissionerExample
//
//  Created by Thang Phung on 11/11/2022.
//

#import "DetailsViewController.h"

@implementation NSData (NSData_Conversion)

- (NSString *)hexadecimalString {
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

@end

@implementation DetailsViewController

+ (instancetype)viewControllerWithDataset:(TPActiveOperationalDataset*)dataset {
    UIStoryboard* board = [UIStoryboard storyboardWithName:@"Main" bundle:NULL];
    DetailsViewController* vc = [board instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    vc.dataset = dataset;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_dataset.networkName != NULL) {
        [self buildInformationViewWithTitle:@"Network Name:" andValue:_dataset.networkName];
    }
    
    [self buildInformationViewWithTitle:@"Channel:" andValue:[@(_dataset.channel) stringValue]];
    
    [self buildInformationViewWithTitle:@"PanId:" andValue:[@(_dataset.panId) stringValue]];
    
    if (_dataset.xpanId != NULL) {
        [self buildInformationViewWithTitle:@"Exteneded PanId:" andValue:_dataset.xpanId];
    }
    
    if (_dataset.networkMasterKey != NULL) {
        [self buildInformationViewWithTitle:@"MasterKey:" andValue:[_dataset.networkMasterKey hexadecimalString]];
    }
    
    UIView *spaceView = [[UIView alloc] init];
    [spaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [spaceView.heightAnchor constraintGreaterThanOrEqualToConstant:30.0f].active = YES;
    [_stackView addArrangedSubview:spaceView];
}

- (void)buildInformationViewWithTitle:(NSString*)title andValue:(NSString*)value {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    titleLabel.text = title;
    
    UILabel *valueLabel = [[UILabel alloc] init];
    [valueLabel setFont:[UIFont systemFontOfSize:17.0f]];
    valueLabel.text = value;
    
    UIStackView *subStackView = [[UIStackView alloc] initWithArrangedSubviews:@[titleLabel, valueLabel]];
    [subStackView setAxis:UILayoutConstraintAxisVertical];
    [subStackView setSpacing:4];
    
    [_stackView addArrangedSubview:subStackView];
}

@end
