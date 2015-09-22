//
//  ViewController.m
//  M2048
//
//  Created by sh219 on 15/9/21.
//  Copyright (c) 2015年 sh219. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"

@interface ViewController (){
    GameViewController *gameViewController;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    gameViewController = [[GameViewController alloc] init];
    [self addChildViewController:gameViewController];
    [self.view addSubview:gameViewController.view];
//    [item addCombineAnimation];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NumberItem *item = [[NumberItem alloc] initWithFrame:CGRectMake(100, 100, 80, 80) power:2];
//    [self.view addSubview:item];
//    [item addAppearAnimation];
}

@end
