//
//  DoctorDetailViewController.m
//  Samahope
//
//  Created by Sarat Tallamraju on 3/4/15.
//  Copyright (c) 2015 Samahope Org. All rights reserved.
//

#import "DoctorDetailViewController.h"
#import "BannerView.h"
#import "FundView.h"
#import "DoctorFocusView.h"
#import "DonateViewController.h"
#import "FundCell.h"
#import "DoctorFocusCell.h"
#import "PatientCell.h"
#import "DescriptionCell.h"
#import "BannerCell.h"

@interface DoctorDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (strong, nonatomic) IBOutlet UITableView *detailTableView;
@property (nonatomic, assign) CGFloat transitionDuration;
@property (nonatomic, assign) BOOL isPresenting;

- (IBAction)onXButtonTapped:(id)sender;
- (IBAction)onDonateButtonTapped:(id)sender;

@end

@implementation DoctorDetailViewController

#pragma mark View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transitionDuration = 0.4;
    
    // Set up table stuff
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    NSArray *cellNames = @[@"FundCell", @"DoctorFocusCell", @"PatientCell", @"DescriptionCell", @"BannerCell"];
    for (NSString *cellName in cellNames) {
        UINib *cellNib = [UINib nibWithNibName: cellName bundle:nil];
        [self.detailTableView registerNib:cellNib forCellReuseIdentifier: cellName];
    }
    self.detailTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.detailTableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.detailTableView.bounds.size.width, 100)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.detailTableView reloadData];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation: UIStatusBarAnimationFade];
}

- (IBAction)didSelectShare:(UIButton *)sender {
    NSString *textToShare = [NSString stringWithFormat:@"%@ is doing an awesome job helping out people in %@.  Donate some money to help their cause!", self.doctor.name, self.doctor.humanReadableLocation];
    
    NSMutableArray *itemsToShare = [[NSMutableArray alloc] initWithObjects: textToShare, nil];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    
    [activityVC setValue:@"Support this doctor" forKey:@"subject"];

    activityVC.excludedActivityTypes= @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeAirDrop];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)setHideBannerCell:(BOOL)hideBannerCell {
    _hideBannerCell = hideBannerCell;
    [self.detailTableView reloadData];
}

#pragma mark UI Animated Transitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    
    if (self.isPresenting) {
        [containerView addSubview: toViewController.view];
        toViewController.view.alpha = 0.0;
        
        [UIView animateWithDuration: self.transitionDuration animations:^{
            toViewController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition: YES];
        }];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation: UIStatusBarAnimationFade];
        [UIView animateWithDuration: self.transitionDuration animations:^{
            fromViewController.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition: YES];
            [fromViewController.view removeFromSuperview];
        }];
    }
}

#pragma mark UI Transition Delegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresenting = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresenting = NO;
    return self;
}

// - (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    
// }

// - (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    
// }

#pragma mark Table Listeners

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BannerCell *cell = [self.detailTableView dequeueReusableCellWithIdentifier: @"BannerCell" forIndexPath:indexPath];
        cell.maskAlpha = 0.0;
        cell.hidden = self.hideBannerCell;
        cell.doctor = self.doctor;
        return cell;
    } else if (indexPath.row == 1) {
        FundCell *cell = [self.detailTableView dequeueReusableCellWithIdentifier: @"FundCell" forIndexPath:indexPath];
        cell.fund = self.doctor.fund;
        return cell;
    } else if (indexPath.row == 2) {
        DoctorFocusCell *cell = [self.detailTableView dequeueReusableCellWithIdentifier: @"DoctorFocusCell" forIndexPath:indexPath];
        cell.doctor = self.doctor;
        return cell;
    } else if (indexPath.row == 3) {
        DescriptionCell *cell = [self.detailTableView dequeueReusableCellWithIdentifier: @"DescriptionCell" forIndexPath:indexPath];
        cell.doctor = self.doctor;
        return cell;
    } else {
        Patient *patient = self.doctor.patients[indexPath.row - 4];
        PatientCell *cell = [self.detailTableView dequeueReusableCellWithIdentifier: @"PatientCell" forIndexPath:indexPath];
        cell.patient = patient;
        return cell;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4 + [self.doctor.patients count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected row %ld in section %ld", (long)indexPath.row, (long)indexPath.section);
}

#pragma mark Nav Bar Customization

- (void) customizeNavBar: (UINavigationController *)nvc {
    // Make nav bar transparent
    [nvc.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    nvc.navigationBar.shadowImage = [UIImage new];
    nvc.navigationBar.translucent = YES;
    nvc.view.backgroundColor = [UIColor clearColor];
    nvc.navigationBar.backgroundColor = [UIColor clearColor];
    nvc.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark User Actions

- (IBAction)onXButtonTapped:(id)sender {
    NSLog(@"on X button tapped");
    [self dismissViewControllerAnimated: YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation: UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
}

- (IBAction)onDonateButtonTapped:(id)sender {
    NSLog(@"DetailVC: Donate button tapped");
    DonateViewController *vc = [[DonateViewController alloc] init];
    vc.doctor = self.doctor;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController: vc];
    nvc.modalPresentationStyle = UIModalPresentationCustom;
    nvc.transitioningDelegate = self;
    
    [self customizeNavBar: nvc];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation: UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    
    [self presentViewController: nvc animated:YES completion:nil];
    // [self.navigationController pushViewController: vc animated:YES];
}
@end
