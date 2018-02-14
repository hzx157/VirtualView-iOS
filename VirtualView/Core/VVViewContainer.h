//
//  VVViewContainer.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVBaseNode.h"

@protocol VirtualViewDelegate <NSObject>

@optional

- (void)subViewClicked:(NSString *)action andValue:(NSString *)value;
- (void)subView:(VVBaseNode *)view clicked:(NSString *)action andValue:(NSString *)value;
- (void)subViewLongPressed:(NSString *)action andValue:(NSString *)value gesture:(UIGestureRecognizer *)gesture;

@end

@interface VVViewContainer : UIView

@property (nonatomic, strong, readonly) VVBaseNode *rootNode;
@property (nonatomic, weak) id<VirtualViewDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL alwaysRefresh;

+ (VVViewContainer *)viewContainerWithTemplateType:(NSString *)type;
+ (VVViewContainer *)viewContainerWithTemplateType:(NSString *)type alwaysRefresh:(BOOL)alwaysRefresh;
- (id)initWithRootNode:(VVBaseNode *)rootNode;
- (id)initWithRootNode:(VVBaseNode *)rootNode alwaysRefresh:(BOOL)alwaysRefresh;

- (CGSize)calculateSize:(CGSize)maxSize; // maybe will cost a lot of CPU resource

- (void)update:(id)data;

- (VVBaseNode *)nodeWithID:(NSInteger)nodeID;

+ (NSArray *)nodesWithExpression:(VVBaseNode *)rootNode;

@end
