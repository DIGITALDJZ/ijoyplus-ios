#import <Foundation/Foundation.h>
#import "MyProfileCell.h"
#import "MNMBottomPullToRefreshManager.h"
#import "UIGenericViewController.h"

/**
 * View controller with the demo table
 */
@interface DramaTableViewController : UIGenericViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *table;

@end