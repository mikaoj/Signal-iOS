//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@class OWSSignalServiceProtosAttachmentPointer;
@class OWSSignalServiceProtosDataMessage;
@class OWSSignalServiceProtosSyncMessageSent;
@class TSQuotedMessage;
@class TSThread;
@class YapDatabaseReadWriteTransaction;

/**
 * Represents notification of a message sent on our behalf from another device.
 * E.g. When we send a message from Signal-Desktop we want to see it in our conversation on iPhone.
 */
@interface OWSIncomingSentMessageTranscript : NSObject

- (instancetype)initWithProto:(OWSSignalServiceProtosSyncMessageSent *)sentProto
                        relay:(nullable NSString *)relay
                  transaction:(YapDatabaseReadWriteTransaction *)transaction;

@property (nonatomic, readonly) NSString *relay;
@property (nonatomic, readonly) OWSSignalServiceProtosDataMessage *dataMessage;
@property (nonatomic, readonly) NSString *recipientId;
@property (nonatomic, readonly) uint64_t timestamp;
@property (nonatomic, readonly) uint64_t expirationStartedAt;
@property (nonatomic, readonly) uint32_t expirationDuration;
@property (nonatomic, readonly) BOOL isGroupUpdate;
@property (nonatomic, readonly) BOOL isExpirationTimerUpdate;
@property (nonatomic, readonly) BOOL isEndSessionMessage;
@property (nullable, nonatomic, readonly) NSData *groupId;
@property (nonatomic, readonly) NSString *body;
@property (nonatomic, readonly) NSArray<OWSSignalServiceProtosAttachmentPointer *> *attachmentPointerProtos;
@property (nonatomic, readonly) TSThread *thread;
@property (nonatomic, readonly) TSQuotedMessage *quotedMessage;

@end

NS_ASSUME_NONNULL_END
