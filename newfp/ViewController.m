//
//  ViewController.m
//  FriendPoints
//
//  Created by Austin Vershel on 3/23/15.
//  Copyright (c) 2015 Austin Vershel. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import "CustomCell.h"
@interface ViewController ()

@end

@implementation ViewController

static NSString *CellIdentifier = @"CellTableIdentifier";
@synthesize av,defaults,editButton, bar, tv;

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    //[bar setTintColor:[UIColor colorWithRed:39.0/255.0 green:171.0/255.0 blue:255.0/255.0 alpha:1.0]];
    if (!_people) {
        _people = [[defaults objectForKey:@"myArray"] mutableCopy];
    }
    
    
    av = [[UIAlertView alloc]initWithTitle:@"Enter your Friends Name!" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    tv.dataSource = self;
    tv.delegate = self;
    tv.contentInset = UIEdgeInsetsMake(25, 0, 0, 0);
    
    //[tableView registerClass:[CustomCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.people count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    
    NSDictionary *rowData = self.people[indexPath.row];
    
    CGRect nameValueRectangle = CGRectMake(50, 15, 250, 30);
    UILabel* _nameValue = [[UILabel alloc] initWithFrame:nameValueRectangle];
    _nameValue.text = rowData[@"Name"];
    _nameValue.font = [UIFont systemFontOfSize:20];
    [cell.contentView addSubview:_nameValue];
    
    CGRect rowrect = CGRectMake(20, 15, 250, 30);
    UILabel* row = [[UILabel alloc] initWithFrame:rowrect];
    row.text = [NSString stringWithFormat:@"%li",(long)indexPath.row + 1];
    row.font = [UIFont systemFontOfSize:20];
    [cell.contentView addSubview:row];
    
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    CGRect scoreRect = CGRectMake((screenWidth - 85), 15, 45, 30);
    UILabel* scoreLabel = [[UILabel alloc] initWithFrame:scoreRect];
    scoreLabel.textAlignment = NSTextAlignmentRight;
    scoreLabel.text = rowData[@"Score"];
    scoreLabel.font = [UIFont boldSystemFontOfSize:25];
    [cell addSubview:scoreLabel];
    
    UIButton*  downButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[downButton setTitle:@"Down" forState:UIControlStateNormal];
    [downButton setImage:[UIImage imageNamed:@"downarrow1.png"] forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(downPressed:) forControlEvents:UIControlEventTouchUpInside];
    downButton.titleLabel.font = [UIFont systemFontOfSize:20];
    downButton.frame = CGRectMake((screenWidth - 100), 15, 30, 20);
    //downButton.frame = CGRectMake(255, 15, 20, 30);
    
    
    [cell addSubview:downButton];
    
    UIButton* upButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[upButton setTitle:@"Up" forState:UIControlStateNormal];
    [upButton setImage:[UIImage imageNamed:@"uparrow1.png"] forState:UIControlStateNormal];
    [upButton addTarget:self action:@selector(upPressed:) forControlEvents:UIControlEventTouchUpInside];
    upButton.titleLabel.font = [UIFont systemFontOfSize:20];
    upButton.frame = CGRectMake((screenWidth - 35), 15, 30, 20);
    //upButton.frame = CGRectMake(330, 15, 20, 30);
    
    
    [cell addSubview:upButton];
    //[cell.downButton addTarget:self action:@selector(customDownPressed:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}


-(void)upPressed:(UIButton*)sender
{
    UITableViewCell *owningCell = (UITableViewCell*)[sender superview];
    UITableView *tableView = (id)[self.view viewWithTag:1];
    
    NSIndexPath *pathToCell = [tableView indexPathForCell:owningCell            ];
    NSDictionary *rowData = self.people[pathToCell.row];
    NSString *tempname = rowData[@"Name"];
    NSLog(@"%@", tempname);
    NSInteger scoreInt = [rowData[@"Score"] integerValue];
    if (scoreInt <99)
    {
        
        scoreInt +=1;
        [_people removeObjectAtIndex:pathToCell.row];
        
        //[tableView deleteRowsAtIndexPaths:@[pathToCell] withRowAnimation:UITableViewRowAnimationFade];
        
        [_people addObject:@{@"Name": tempname, @"Score": [NSString stringWithFormat:@"%li", (long)scoreInt]}];
        NSArray *aSortedArray = [_people sortedArrayUsingComparator:^(NSMutableDictionary *obj1, NSMutableDictionary *obj2)
                                 {
                                     NSString *num1 = [obj1 objectForKey:@"Score"];
                                     NSString *num2 = [obj2 objectForKey:@"Score"];
                                     return (NSComparisonResult) [num2 compare:num1];
                                 }];
        _people = [aSortedArray mutableCopy];
        //UITableView *tableView = (id)[self.view viewWithTag:1];
        [tableView reloadData];
        [defaults setObject:_people forKey:@"myArray"];
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}


#pragma mark - up&down

-(void)downPressed:(UIButton*)sender
{
    UITableViewCell *owningCell = (UITableViewCell*)[sender superview];
    UITableView *tableView = (id)[self.view viewWithTag:1];
    
    NSIndexPath *pathToCell = [tableView indexPathForCell:owningCell            ];
    NSDictionary *rowData = self.people[pathToCell.row];
    
    NSInteger scoreInt = [rowData[@"Score"] integerValue];
    NSString *tempname = rowData[@"Name"];
    NSLog(@"%@", tempname);
    
    if (scoreInt >1)
    {
        
        scoreInt -=1;
        [_people removeObjectAtIndex:pathToCell.row];
        [_people addObject:@{@"Name": tempname, @"Score": [NSString stringWithFormat:@"%li", (long)scoreInt]}];
        NSArray *aSortedArray = [_people sortedArrayUsingComparator:^(NSMutableDictionary *obj1, NSMutableDictionary *obj2)
                                 {
                                     NSString *num1 = [obj1 objectForKey:@"Score"];
                                     NSString *num2 = [obj2 objectForKey:@"Score"];
                                     return (NSComparisonResult) [num2 compare:num1];
                                 }];
        _people = [aSortedArray mutableCopy];
        //UITableView *tableView = (id)[self.view viewWithTag:1];
        [tableView reloadData];
        [defaults setObject:_people forKey:@"myArray"];
        
    }
    
}


#pragma mark - Adding

- (IBAction)addPressed:(id)sender {
    if (!_people) {
        _people = [[NSMutableArray alloc] init];
    }
    
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].delegate = (id)self;
    [av show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1)
    {
        if ([[[av textFieldAtIndex:0] text] length] > 0) {
            
            
            [_people addObject:@{@"Name": [[[av textFieldAtIndex:0] text] capitalizedString], @"Score": @"50"}];
            NSArray *aSortedArray = [_people sortedArrayUsingComparator:^(NSMutableDictionary *obj1, NSMutableDictionary *obj2)
                                     {
                                         NSString *num1 = [obj1 objectForKey:@"Score"];
                                         NSString *num2 = [obj2 objectForKey:@"Score"];
                                         return (NSComparisonResult) [num2 compare:num1];
                                     }];
            _people = [aSortedArray mutableCopy];
            UITableView *tableView = (id)[self.view viewWithTag:1];
            [tableView reloadData];
            [defaults setObject:_people forKey:@"myArray"];
        }
    }
    
}


#pragma mark - Editing

- (IBAction)editPressed:(id)sender {
    UITableView *tableView = (id)[self.view viewWithTag:1];
    
    if ([editButton.title  isEqual: @"Edit"]) {
        [tableView setEditing:YES animated:YES];
        [editButton setTitle:@"Done"];
        
    } else {
        [editButton setTitle:@"Edit"];
        [tableView setEditing:NO animated:YES];
    }
    [defaults setObject:_people forKey:@"myArray"];
    
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_people removeObjectAtIndex:indexPath.row];
        UITableView *tableView1 = (id)[self.view viewWithTag:1];
        
        [tableView1 deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if ([_people count] < 1) {
            [editButton setTitle:@"Edit"];
            [tableView1 setEditing:NO animated:YES];
        }
        NSArray *aSortedArray = [_people sortedArrayUsingComparator:^(NSMutableDictionary *obj1, NSMutableDictionary *obj2)
                                 {
                                     NSString *num1 = [obj1 objectForKey:@"Score"];
                                     NSString *num2 = [obj2 objectForKey:@"Score"];
                                     return (NSComparisonResult) [num2 compare:num1];
                                 }];
        _people = [aSortedArray mutableCopy];
        UITableView *tableView = (id)[self.view viewWithTag:1];
        [tableView reloadData];
        [defaults setObject:_people forKey:@"myArray"];
        
        //[defaults setObject:_people forKey:@"myArray"];
        
        
        
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
