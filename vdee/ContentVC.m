//
//  ContentVCO.m
//  vdee
//
//  Created by Nicholas Rosas on 5/6/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//

#import "ContentVC.h"

@interface ContentVC ()

@end

@implementation ContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pullUpViewController:(ISHPullUpViewController *)pullUpViewController updateEdgeInsets:(UIEdgeInsets)edgeInsets forContentViewController:(UIViewController *)contentVC {
    _rootView.layoutMargins = edgeInsets;
    [_rootView layoutIfNeeded];
}

@end
