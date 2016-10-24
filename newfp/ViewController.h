//
//  ViewController.h
//  FriendPoints
//
//  Created by Austin Vershel on 3/23/15.
//  Copyright (c) 2015 Austin Vershel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (copy, nonatomic) NSMutableArray *people;
@property (strong, nonatomic) UIAlertView *av;
@property (strong, nonatomic) NSUserDefaults* defaults;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (weak, nonatomic) IBOutlet UINavigationBar *bar;
@property (weak, nonatomic) IBOutlet UITableView *tv;


@end

