//
//  VWW_GradientImageTableViewController.m
//  ColorBlind
//
//  Created by Zakk Hoyt on 7/29/12.
//
//

#import "VWW_GradientImageTableViewController.h"
#import "VWW_GradientImageTableCell.h"
@interface VWW_GradientImageTableViewController ()
@property (nonatomic, retain) NSArray* data;
-(void)createDataSource;
@end

@implementation VWW_GradientImageTableViewController
@synthesize data = _data;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createDataSource];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!self.data){
        return 0;
    }
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    // We are using a custom table cell. See VWW_ColorTableCell.h
//    VWW_ColorTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VWW_ColorTableCell"];
//    NSMutableDictionary* d = (NSMutableDictionary*)[self.data objectAtIndex:indexPath.section];
//    NSArray* a = [d objectForKey:@"colors"];
//    VWW_Color* color = [a objectAtIndex:indexPath.row];
//    
//    // Safety check
//    if(!color){
//        return cell;
//    }
//    
//    cell.nameLabel.text = color.name;
//    cell.hexLabel.text = [NSString stringWithFormat:@"#%@", color.hex];
//    cell.redLabel.text = [NSString stringWithFormat:@"r:%d", color.red.integerValue];
//    cell.greenLabel.text = [NSString stringWithFormat:@"g:%d", color.green.integerValue];
//    cell.blueLabel.text = [NSString stringWithFormat:@"b:%d", color.blue.integerValue];
//    cell.colorView.backgroundColor = color.color;
//    return cell;
//    
//
    VWW_GradientImageTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VWW_GradientImageTableCell"];
    UIImage* image = nil;
    NSString* label = nil;
    switch(indexPath.row){
        case 0:{
            label = @"gradient_00";
            image = [UIImage imageNamed:@"gradient_00_iPhone.png"];
            break;
        }
        case 1:{
            label = @"gradient_01";
            image = [UIImage imageNamed:@"gradient_01_iPhone.png"];
            break;
        }
        case 2:{
            label = @"gradient_02";
            image = [UIImage imageNamed:@"gradient_02_iPhone.png"];
            break;
        }
        case 3:{
            label = @"gradient_03";
            image = [UIImage imageNamed:@"gradient_03_iPhone.png"];
            break;
        }
        case 4:{
            label = @"gradient_04";
            image = [UIImage imageNamed:@"gradient_04_iPhone.png"];
            break;
        }
        case 5:{
            label = @"gradient_05";
            image = [UIImage imageNamed:@"gradient_05_iPhone.png"];
            break;
        }
        case 6:{
            label = @"gradient_06";
            image = [UIImage imageNamed:@"gradient_06_iPhone.png"];
            break;
        }
        default:
            break;
    }

    cell.lblFileName.text = label;
    cell.imagePreview.image = image;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row){
        case 0:{
            break;
        }
        case 1:{
            break;
        }
        case 2:{
            break;
        }
        case 3:{
            break;
        }
        case 4:{
            break;
        }
        case 5:{
            break;
        }
        case 6:{
            break;
        }
        default:
            break;
            
    }
    
    // Tell our delegate that a file was selected
    if(self.delegate){
        
    }

    // Dismiss this view back to calling view
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Custom methods
-(void)createDataSource{
    self.data = [[NSArray alloc]initWithObjects:@"gradient_00",
                 @"gradient_01",
                 @"gradient_02",
                 @"gradient_03",
                 @"gradient_04",
                 @"gradient_05",
                 @"gradient_06",
                 nil];
    
}

@end
