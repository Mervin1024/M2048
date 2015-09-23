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
@property (weak, nonatomic) IBOutlet UIImageView *stepNumberImage;
@property (weak, nonatomic) IBOutlet UILabel *stepNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currentScoreImage;
@property (weak, nonatomic) IBOutlet UILabel *currentScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *maximumScoreImage;
@property (weak, nonatomic) IBOutlet UILabel *maximumScoreLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    gameViewController = [[GameViewController alloc] init];
    [self addChildViewController:gameViewController];
    [self.view addSubview:gameViewController.view];
    
    [self.stepNumberImage.layer setMasksToBounds:YES];
    [self.stepNumberImage.layer setCornerRadius:8.0];
    [self.currentScoreImage.layer setMasksToBounds:YES];
    [self.currentScoreImage.layer setCornerRadius:8.0];
    [self.maximumScoreImage.layer setMasksToBounds:YES];
    [self.maximumScoreImage.layer setCornerRadius:8.0];
    
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"maximumScore"];
    if (!num) {
        self.maximumScoreLabel.text = [NSString stringWithFormat:@"%ld",(long)[num integerValue]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

@end
