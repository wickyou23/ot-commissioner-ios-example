//
//  DetailsViewController.h
//  TPOpenthreadCommissionerExample
//
//  Created by Thang Phung on 11/11/2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TPOpenthreadCommissioner/TPOpenthreadCommissioner.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIStackView* stackView;

@property (nonatomic, strong) TPActiveOperationalDataset* dataset;

+ (instancetype)viewControllerWithDataset:(TPActiveOperationalDataset*)dataset;

@end

NS_ASSUME_NONNULL_END
