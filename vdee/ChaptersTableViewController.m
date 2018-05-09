//
//  ChaptersTableViewController.m
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//
#define kBgQueue2 dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "ChaptersTableViewController.h"
#import "BookTableViewController.h"
#import "VersesTableViewController.h"
#import "ChaptersItem.h"
#import "BooksItem.h"
#import "VersesItem.h"

@interface ChaptersTableViewController ()

@end

@implementation ChaptersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url = [NSString stringWithFormat:@"https://9lb6aGt8hUcJtJJr9QSB5RNoG2blucYhgahrgLGi:@bibles.org/v2/books/%@/chapters.js", self.bookId];
    _chaptersURL = [NSURL URLWithString: url];
    dispatch_async(kBgQueue2, ^{
        NSData* data = [NSData dataWithContentsOfURL: _chaptersURL];
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
    //Loop through JSON response to create array of chapter objects
    if([json isKindOfClass:[NSDictionary class]]) {
        _chapters = [[NSMutableArray alloc] init];
        NSDictionary *responseDict = json[@"response"];
        if([responseDict isKindOfClass:[NSDictionary class]]){
            NSArray *chaptersArr = responseDict[@"chapters"];
            for(NSDictionary *dict in chaptersArr) {
                ChaptersItem *chapter = [[ChaptersItem alloc] init];
                chapter.id =[dict objectForKey:@"id"];
                chapter.auditid = [dict objectForKey:@"auditid"];
                chapter.label = [dict objectForKey:@"label"];
                chapter.chapter = [dict objectForKey:@"chapter"];
                chapter.osis_end = [dict objectForKey:@"osis_end"];
                chapter.parent = [dict objectForKey:@"parent"];
                chapter.next = [dict objectForKey:@"next"];
                chapter.previous = [dict objectForKey:@"previous"];
                chapter.copyright = [dict objectForKey:@"copyright"];
                [_chapters addObject:chapter];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [_chapters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ChapterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    ChaptersItem *chapter = (self.chapters)[indexPath.row];
    cell.textLabel.text = chapter.chapter;
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

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"segueToVerses"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    VersesTableViewController *destViewController = segue.destinationViewController;
    ChaptersItem *chapter = (self.chapters)[indexPath.row];
    destViewController.bookId = chapter.id;
    destViewController.chapterNumber = chapter.chapter;
    destViewController.title = chapter.chapter;
    }
}

@end
