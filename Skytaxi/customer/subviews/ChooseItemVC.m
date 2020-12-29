//
//  ChooseItemVC.m
//  Skytaxi
//
//  Created by meixiang wu on 2018/4/3.
//  Copyright © 2018 meixiang wu. All rights reserved.
//

#import "ChooseItemVC.h"
#import <DXPopover.h>
#import "AppDelegate.h"

@interface ChooseItemVC ()<UITableViewDelegate, UITableViewDataSource>{
}
@property (nonatomic) DXPopover *popover;
@end

@implementation ChooseItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ShowPopover:(UIViewController*)parent ShowAtPoint:(CGPoint)point DismissHandler:(void (^)())block
{
    CGSize size = parent.view.frame.size;
    NSInteger height = 36 * self.data.count + 3;
    if(height > 240){
        height = 240;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width * 2/4, height)];
    [parent addChildViewController:self];
    [view addSubview:self.view];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *views = @{@"contentview":self.view};
    [view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentview]|" options:0 metrics:nil views:views]];
    [view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentview]|" options:0 metrics:nil views:views]];
    self.popover = [DXPopover popover];
    DXPopoverPosition directposition = DXPopoverPositionDown;
    if(self.direction == 1) directposition = DXPopoverPositionUp;
    [self.popover showAtPoint:point popoverPostion:directposition withContentView:view inView:parent.view];
    self.popover.didDismissHandler = block;
    [self.mTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell;
    cell = [self.mTableView dequeueReusableCellWithIdentifier:@"RID_ChooseItemCell" forIndexPath:indexPath];
    UILabel* itemLabel = [cell viewWithTag:1];
    itemLabel.text = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    g_nChoose = indexPath.row;
    [self.popover dismiss];
}

@end
