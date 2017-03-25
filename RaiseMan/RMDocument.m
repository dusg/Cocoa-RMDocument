//
//  Document.m
//  RaiseMan
//
//  Created by 杜... on 2017/2/22.
//  Copyright © 2017年 杜... All rights reserved.
//

#import "RMDocument.h"
#import "Person.h"

@interface RMDocument ()
-(void)startObservingPerson:(Person*)person;
-(void)stopObservingPerson:(Person*)person;
-(void)changeKeyPath:(NSString*)keyPath ofObject:(id)obj otValue:(id)newValue;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context;
@end

@implementation RMDocument

static void* DocumentKVOContext;

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        employees = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)startObservingPerson:(Person*)person
{
    [person addObserver:self forKeyPath:@"personName" options:NSKeyValueObservingOptionOld context:&DocumentKVOContext];
    
    [person addObserver:self forKeyPath:@"expectedRaise" options:NSKeyValueObservingOptionOld context:&DocumentKVOContext];
    return;
}

-(void)stopObservingPerson:(Person*)person
{
    [person removeObserver:self forKeyPath:@"personName"];
    [person removeObserver:self forKeyPath:@"expectedRaise"];
    return;
}

-(void)changeKeyPath:(NSString*)keyPath ofObject:(id)obj otValue:(id)newValue
{
    [obj setValue:newValue forKeyPath:keyPath];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context != &DocumentKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    NSUndoManager* undo = [self undoManager];
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldValue == [NSNull null]) {
        oldValue = nil;
    }
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object otValue:oldValue];
    [undo setActionName:@"Edit"];
}
-(void)createEmployee:(id)sender
{
    NSWindow* w = [tableView window];
    BOOL editingEnded = [w makeFirstResponder:w];
    if (!editingEnded) {
        return;
    }
    NSUndoManager* undo = [self undoManager];
    if ([undo groupingLevel] > 0) {
        [undo endUndoGrouping];
        [undo beginUndoGrouping];
    }
    
    Person* person = [employeeController newObject];
    [employeeController addObject:person];
    [employeeController rearrangeObjects];
    
    NSArray* a = [employeeController arrangedObjects];
    NSUInteger row = [a indexOfObjectIdenticalTo:person];
    [tableView editColumn:0 row:row withEvent:nil select:YES];
}

-(void)insertObject:(Person *)p inEmployeesAtIndex:(NSUInteger)index
{
    NSUndoManager* undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self] removeObjectFromEmployeesAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Add Person"];
    }
    [self startObservingPerson:p];
    [employees insertObject:p atIndex:index];
}

-(void)removeObjectFromEmployeesAtIndex:(NSUInteger)index
{
    Person* p = [employees objectAtIndex:index];
    NSUndoManager* undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self] insertObject:p inEmployeesAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Remove Person"];
    }
    [self stopObservingPerson:p];
    [employees removeObjectAtIndex:index];
}

-(void)setEmployees:(NSMutableArray *)a
{
    if(employees == a) {
        return;
    }
    
    for (Person* person in employees) {
        [self stopObservingPerson:person];
    }
    
    employees = a;
    
    for (Person* person in employees) {
        [self stopObservingPerson:person];
    }
}
+ (BOOL)autosavesInPlace {
    return YES;
}


- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"RMDocument";
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    
//    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    //结束编辑
    [[tableView window] endEditingFor:nil];
    
    //保存employees数据,要先转换成nsdata类型
    return nil;
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return YES;
}


@end
