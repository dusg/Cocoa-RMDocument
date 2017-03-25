//
//  Document.h
//  RaiseMan
//
//  Created by 杜... on 2017/2/22.
//  Copyright © 2017年 杜... All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Person;

@interface RMDocument : NSDocument
{
    NSMutableArray* employees;
    IBOutlet NSTableView* tableView;
    IBOutlet NSArrayController* employeeController;
}
-(IBAction)createEmployee:(id)sender;
-(void)setEmployees:(NSMutableArray*)a;
-(void)insertObject:(Person*)p inEmployeesAtIndex:(NSUInteger)index;
-(void)removeObjectFromEmployeesAtIndex:(NSUInteger)index;
@end

