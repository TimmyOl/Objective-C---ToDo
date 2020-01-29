//
//  TODOTableViewController.m
//  ToDo-List
//
//  Created by Timmy Olsson on 2020-01-28.
//  Copyright © 2020 Timmy Olsson. All rights reserved.
//

#import "TODOTableViewController.h"

@interface TODOTableViewController () <UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *items;

@end

@implementation TODOTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load items from NSUserDeafaults if not nil and set default if nil
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Items"] == nil) {
        self.items = @[@{@"name" : @"Click the + to make a ToDo"}].mutableCopy;
    }
    else {
        self.items = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Items"] mutableCopy];
    }
    
    // Edit Button to the right in the navigation bar
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Add Button to the left in the navigation bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
}

// Method to add items
- (void) addNewItem:(UIBarButtonItem *)sender {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Add a new ToDo" message:@"Write your todo in the box below" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) { textField.placeholder = @"Your ToDo"; textField.textColor = [UIColor blackColor]; textField.clearButtonMode = UITextFieldViewModeWhileEditing; textField.borderStyle = UITextBorderStyleRoundedRect;}];
    
    // Add Save button
    [alertView addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Add the new item to the array
        NSArray *textFields = alertView.textFields;
        UITextField *itemNameField = textFields[0];
        NSString *itemName = itemNameField.text;
        NSDictionary *item = @{@"name" : itemName};
        [self.items addObject:item];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.items.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self saveItemsToDefaults:self.items];
    }]];
    // Add cancel button
    [alertView addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (NSInteger)tableViewSections:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TodoItemRow";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *item = self.items[indexPath.row];
    
    cell.textLabel.text = item[@"name"];
    
    // Check if item is checked as completed
    if ([item[@"completed"] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

// Method to check the todo item as completed
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self itemIndexForIndexPath:indexPath];
    
    NSMutableDictionary *item = [self.items[index] mutableCopy];
    BOOL completed = [item[@"completed"] boolValue];
    item[@"completed"] = @(!completed);
    
    self.items[index] = item;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = ([item[@"completed"] boolValue]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Method to select sertain row
- (NSDictionary *)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = self.items[indexPath.row];
    
    return item;
}

// Method to select the index of the selected item
- (NSInteger)itemIndexForIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [self itemAtIndexPath:indexPath];
    NSInteger index = [self.items indexOfObjectIdenticalTo:item];
    
    return index;
}

// Method to remove selected item
- (void)removeItemsAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self itemIndexForIndexPath:indexPath];
    [self.items removeObjectAtIndex:index];
}

// Method to add remove icons and init the removal on click
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// Make the rows editable
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Add the editingstyle to the edit
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeItemsAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveItemsToDefaults:self.items];
    }
}

// Write to NSUserDefaults
- (void)saveItemsToDefaults:(NSArray *)items {
    [[NSUserDefaults standardUserDefaults] setObject:items forKey:@"Items"];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSInteger index = [self itemIndexForIndexPath:indexPath];
        [self.items removeObjectAtIndex:index];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/
 
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
