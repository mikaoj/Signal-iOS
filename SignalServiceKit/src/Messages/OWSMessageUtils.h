//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@class OWSQuotedReplyModel;
@class TSMessage;
@class TSThread;
@class YapDatabaseReadTransaction;

@interface OWSMessageUtils : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)sharedManager;

- (NSUInteger)unreadMessagesCount;
- (NSUInteger)unreadMessagesCountExcept:(TSThread *)thread;
- (NSUInteger)unreadMessagesInThread:(TSThread *)thread;

- (void)updateApplicationBadgeCount;

+ (nullable OWSQuotedReplyModel *)quotedReplyDraftForMessage:(TSMessage *)message
                                                 transaction:(YapDatabaseReadTransaction *)transaction;

@end

NS_ASSUME_NONNULL_END
