//
//  UITableView+Helper.m
//  SampleProject
//
//  Created by Zeeshan Haider on 12/11/2015.
//  Copyright © 2015 DevBatch. All rights reserved.
//

#import "UITableView+Helper.h"

@implementation UITableView (Helper)

- (void)registerClasses:(NSArray *)classes {
    for (Class aClass in classes) {
        NSString *className = NSStringFromClass(aClass);
        [self registerClass:aClass forCellReuseIdentifier:className];
    }
}

- (void)registerCellsWithClasses:(NSArray *)classes {
    for (Class aClass in classes) {
        NSString *className = NSStringFromClass(aClass);
        
        NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
        if (nibPath) {
            UINib *nib = [UINib nibWithNibName:className bundle:nil];
            [self registerNib:nib forCellReuseIdentifier:className];
        } else {
            [self registerClass:aClass forCellReuseIdentifier:className];
        }
    }
}
- (void)removeCellSeparatorOffset
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)])
        [self setSeparatorInset:UIEdgeInsetsZero];
    
    if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        [self setPreservesSuperviewLayoutMargins:NO];
    
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)])
        [self setLayoutMargins:UIEdgeInsetsZero];
}
- (void)removeSeperateIndicatorsForEmptyCells
{
    [self setTableFooterView:[UIView new]];
}

// 1 section, x rows
- (void)setNumberOfRows:(NSInteger)rows {
    NSArray *rowsArray = @[ @(rows) ];
    objc_setAssociatedObject(self, &RowsKey, rowsArray, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setDataSource:self];
    [self setDelegate:self];
}

// sectionRows is array of row counts in each section
// Ex: 3 sections, 2 rows in each = @[@2,@2,@2]
- (void)setNumberOfRowsInSections:(NSArray *)rows {
    objc_setAssociatedObject(self, &RowsKey, rows, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setDataSource:self];
    [self setDelegate:self];
}

- (void)handleCellCreationWithBlock:(CreateTableCellBlock)block {
    objc_setAssociatedObject(self, &CreateCellKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setDataSource:self];
    [self setDelegate:self];
}

- (void)handleCellSelectionWithBlock:(SelectTableCellBlock)block {
    objc_setAssociatedObject(self, &SelectCellKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setDelegate:self];
}



#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *ary = (NSArray *)objc_getAssociatedObject(self, &RowsKey);
    return ( [ary count] || 0 );
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *ary = (NSArray *)objc_getAssociatedObject(self, &RowsKey);
    return ( ary[section] || 0 );
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateTableCellBlock block = (CreateTableCellBlock)objc_getAssociatedObject(self, &CreateCellKey);
    if (block) return block(tableView, indexPath);
    else return [tableView dequeueReusableCellWithIdentifier:@""];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectTableCellBlock block = (SelectTableCellBlock)objc_getAssociatedObject(self, &SelectCellKey);
    if (block) block(tableView, indexPath);
}

@end
