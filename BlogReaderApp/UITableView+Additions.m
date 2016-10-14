//
//  UITableView+Additions.m
//  Momentum
//
//  Created by James Rochabrun on 10/14/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "UITableView+Additions.h"

@implementation UITableView (Additions)

- (void)fadeTopAndBottomCellsOnTableViewScroll:(UITableView *)tableView withModifier:(CGFloat)modifier {
    
    NSArray *visibleCells = [tableView visibleCells];
    
    if (visibleCells != nil  &&  [visibleCells count] != 0) {       // Don't do anything for empty table view
        
        /* Get top and bottom cells */
        UITableViewCell *topCell = [visibleCells objectAtIndex:0];
        UITableViewCell *bottomCell = [visibleCells lastObject];
        
        /* Make sure other cells stay opaque */
        // Avoids issues with skipped method calls during rapid scrolling
        for (UITableViewCell *cell in visibleCells) {
            cell.contentView.alpha = 1.0;
        }
        
        /* Set necessary constants */
        NSInteger cellHeight = topCell.frame.size.height - 1;   // -1 To allow for typical separator line height
        NSInteger tableViewTopPosition = tableView.frame.origin.y;
        NSInteger tableViewBottomPosition = tableView.frame.origin.y + tableView.frame.size.height;
        
        /* Get content offset to set opacity */
        CGRect topCellPositionInTableView = [tableView rectForRowAtIndexPath:[tableView indexPathForCell:topCell]];
        CGRect bottomCellPositionInTableView = [tableView rectForRowAtIndexPath:[tableView indexPathForCell:bottomCell]];
        CGFloat topCellPosition = [tableView convertRect:topCellPositionInTableView toView:[tableView superview]].origin.y;
        CGFloat bottomCellPosition = ([tableView convertRect:bottomCellPositionInTableView toView:[tableView superview]].origin.y + cellHeight);
        
        /* Set opacity based on amount of cell that is outside of view */
        //CGFloat modifier = 1.0;     /* Increases the speed of fading (1.0 for fully transparent when the cell is entirely off the screen,
        // 2.0 for fully transparent when the cell is half off the screen, etc) */
        CGFloat topCellOpacity = (1.0f - ((tableViewTopPosition - topCellPosition) / cellHeight) * modifier);
        CGFloat bottomCellOpacity = (1.0f - ((bottomCellPosition - tableViewBottomPosition) / cellHeight) * modifier);
        
        /* Set cell opacity */
        if (topCell) {
            topCell.contentView.alpha = topCellOpacity;
        }
        if (bottomCell) {
            bottomCell.contentView.alpha = bottomCellOpacity;
        }
    }
}

@end
