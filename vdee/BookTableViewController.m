//
//  BookTableViewController.m
//  vdee
//
//  Created by Brittany Arnold on 5/5/18.
//  Copyright © 2018 Anita Garcia. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define apiURL [NSURL URLWithString: @"https://9lb6aGt8hUcJtJJr9QSB5RNoG2blucYhgahrgLGi:@bibles.org/v2/versions/spa-RVR1960/books.js"]

#import "BookTableViewController.h"
#import "ChaptersTableViewController.h"
#import "BooksItem.h"

@interface BookTableViewController ()

@end

@implementation BookTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: apiURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    self.navigationItem.title = @"Biblia";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchedData:(NSData *)responseData {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    //Loop through JSON response to create array of book objects
    if([json isKindOfClass:[NSDictionary class]]) {
        _books = [[NSMutableArray alloc] init];
        NSDictionary *responseDict = json[@"response"];
        if([responseDict isKindOfClass:[NSDictionary class]]){
            NSArray *booksArr = responseDict[@"books"];
            for(NSDictionary *dict in booksArr) {
                BooksItem *book = [[BooksItem alloc] init];
                book.version_id =[dict objectForKey:@"version_id"];
                book.name = [dict objectForKey:@"name"];
                book.abbr = [dict objectForKey:@"abbr"];
                book.ord = [dict objectForKey:@"ord"];
                book.book_group_id = [dict objectForKey:@"book_group_id"];
                book.testament = [dict objectForKey:@"testament"];
                book.id = [dict objectForKey:@"id"];
                book.osis_end = [dict objectForKey:@"osis_end"];
                book.parent = [dict objectForKey:@"parent"];
                book.next = [dict objectForKey:@"next"];
                book.previous = [dict objectForKey:@"previous"];
                book.copyright = [dict objectForKey:@"copyright"];
                book.chapters = [dict objectForKey:@"chapters"];
                [_books addObject:book];
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
    return [_books count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"BookCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    BooksItem *book = (self.books)[indexPath.row];
    cell.textLabel.text = book.name;
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
    if([segue.identifier isEqualToString:@"segueToChapters"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ChaptersTableViewController *destViewController = segue.destinationViewController;
        BooksItem *book = (self.books)[indexPath.row];
        destViewController.bookId = book.id;
        destViewController.title = book.name;
    }
}

@end
