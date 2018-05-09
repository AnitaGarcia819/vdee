//
//  VersesTableViewController.m
//  vdee
//
//  Created by Brittany Arnold on 5/6/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//
#define kBgQueue3 dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "VersesTableViewController.h"

@interface VersesTableViewController ()

@end

@implementation VersesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url = [NSString stringWithFormat:@"https://9lb6aGt8hUcJtJJr9QSB5RNoG2blucYhgahrgLGi:@bibles.org/v2/chapters/%@/verses.js", self.bookId];
    _versesURL = [NSURL URLWithString: url];
    dispatch_async(kBgQueue3, ^{
        NSData* data = [NSData dataWithContentsOfURL: _versesURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchedData:(NSData *)responseData {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    //Loop through JSON response to create array of verse objects
    if([json isKindOfClass:[NSDictionary class]]) {
        _verses = [[NSMutableArray alloc] init];
        NSDictionary *responseDict = json[@"response"];
        if([responseDict isKindOfClass:[NSDictionary class]]){
            NSArray *versesArr = responseDict[@"verses"];
            for(NSDictionary *dict in versesArr) {
                VersesItem *verse = [[VersesItem alloc] init];
                verse.id =[dict objectForKey:@"id"];
                verse.auditid = [dict objectForKey:@"auditid"];
                verse.verse = [dict objectForKey:@"verse"];
                verse.lastverse = [dict objectForKey:@"lastverse"];
                verse.osis_end = [dict objectForKey:@"osis_end"];
                verse.label = [dict objectForKey:@"label"];
                verse.reference = [dict objectForKey:@"reference"];
                verse.parent = [dict objectForKey:@"parent"];
                verse.text= [self stringByStrippingHTML:[dict objectForKey:@"text"]];
                verse.prev_osis_id = [dict objectForKey:@"prev_osis_id"];
                verse.next_osis_id = [dict objectForKey:@"next_osis_id"];
                verse.next = [dict objectForKey:@"next"];
                verse.previous = [dict objectForKey:@"previous"];
                verse.copyright = [dict objectForKey:@"copyright"];
                [_verses addObject:verse];
            }
        }
        [self.tableView reloadData];
    }
}

//This method is used to parse HTML from JSON text response
-(NSString *)stringByStrippingHTML:(NSString*)str {
    NSRange rng;
    while((rng = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        str = [str stringByReplacingCharactersInRange:rng withString:@" "];
    }
    return str;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_verses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"VerseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.numberOfLines = 0;
    VersesItem *verse = (self.verses)[indexPath.row];
    cell.textLabel.text = verse.text;
    return cell;
}

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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
