//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
//

#import "OWSOperation.h"
#import "NSError+MessageSending.h"
#import "OWSBackgroundTask.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const OWSOperationKeyIsExecuting = @"isExecuting";
NSString *const OWSOperationKeyIsFinished = @"isFinished";

@interface OWSOperation ()

@property (nonatomic) OWSOperationState operationState;
@property (nonatomic) OWSBackgroundTask *backgroundTask;

@end

@implementation OWSOperation

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return self;
    }

    _operationState = OWSOperationStateNew;
    _backgroundTask = [OWSBackgroundTask backgroundTaskWithLabel:self.logTag];
    
    // Operations are not retryable by default.
    _remainingRetries = 0;

    return self;
}

- (void)dealloc
{
    DDLogDebug(@"%@ in dealloc", self.logTag);
}

#pragma mark - Subclass Overrides

// Called one time only
- (nullable NSError *)checkForPreconditionError
{
    // no-op
    // Override in subclass if necessary
    return nil;
}

// Called every retry, this is where the bulk of the operation's work should go.
- (void)run
{
    OWSFail(@"%@ Abstract method", self.logTag);
}

// Called at most one time.
- (void)didSucceed
{
    // no-op
    // Override in subclass if necessary
}

// Called at most one time, once retry is no longer possible.
- (void)didFailWithError:(NSError *)error
{
    // no-op
    // Override in subclass if necessary
}

#pragma mark - NSOperation overrides

// Do not override this method in a subclass instead, override `run`
- (void)main
{
    DDLogDebug(@"%@ started.", self.logTag);
    NSError *_Nullable preconditionError = [self checkForPreconditionError];
    if (preconditionError) {
        [self failOperationWithError:preconditionError];
        return;
    }

    [self run];
}

#pragma mark - Public Methods

// These methods are not intended to be subclassed
- (void)reportSuccess
{
    DDLogDebug(@"%@ succeeded.", self.logTag);
    [self didSucceed];
    [self markAsComplete];
}

- (void)reportError:(NSError *)error
{
    DDLogDebug(@"%@ reportError: %@, fatal?: %d, retryable?: %d, remainingRetries: %d",
        self.logTag,
        error,
        error.isFatal,
        error.isRetryable,
        self.remainingRetries);

    if (error.isFatal) {
        [self failOperationWithError:error];
        return;
    }

    if (!error.isRetryable) {
        [self failOperationWithError:error];
        return;
    }

    if (self.remainingRetries == 0) {
        [self failOperationWithError:error];
        return;
    }

    self.remainingRetries--;

    // TODO Do we want some kind of exponential backoff?
    // I'm not sure that there is a one-size-fits all backoff approach
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self run];
    });
}

#pragma mark - Life Cycle

- (void)failOperationWithError:(NSError *)error
{
    DDLogDebug(@"%@ failed terminally.", self.logTag);
    self.failingError = error;

    [self didFailWithError:error];
    [self markAsComplete];
}

- (BOOL)isExecuting
{
    return self.operationState == OWSOperationStateExecuting;
}

- (BOOL)isFinished
{
    return self.operationState == OWSOperationStateFinished;
}

- (void)start
{
    [self willChangeValueForKey:OWSOperationKeyIsExecuting];
    self.operationState = OWSOperationStateExecuting;
    [self didChangeValueForKey:OWSOperationKeyIsExecuting];

    [self main];
}

- (void)markAsComplete
{
    [self willChangeValueForKey:OWSOperationKeyIsExecuting];
    [self willChangeValueForKey:OWSOperationKeyIsFinished];

    // Ensure we call the success or failure handler exactly once.
    @synchronized(self)
    {
        OWSAssert(self.operationState != OWSOperationStateFinished);

        self.operationState = OWSOperationStateFinished;
    }

    [self didChangeValueForKey:OWSOperationKeyIsExecuting];
    [self didChangeValueForKey:OWSOperationKeyIsFinished];
}

@end

NS_ASSUME_NONNULL_END
