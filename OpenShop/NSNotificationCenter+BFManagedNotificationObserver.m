//
//  NSNotificationCenter+BFManagedNotificationObserver.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

@import ObjectiveC.runtime;

#import "NSNotificationCenter+BFManagedNotificationObserver.h"
#import "NSObject+BFRuntimeAdditions.h"

/**
 * Notification block type.
 */
typedef void (^BFNotificationBlock)(NSNotification *note);
/**
 * Managed notification observer association key identifying associated observers.
 */
static char *const BFManagedNotificationObserverObserversAssociationKey = "BFManagedNotificationObserver_observers";

/**
 * `BFManagedNotificationObserver` represents notification observer encapsulating original
 * observer and notification information to maintain automatic observer removal.
 */
@interface BFManagedNotificationObserver : NSObject

/**
 * Original object registering as an observer.
 */
@property (nonatomic, weak) id observer;
/**
 * The object whose notifications the observer wants to receive.
 */
@property (nonatomic, weak) NSObject *object;
/**
 * The name of the notification for which to register the observer
 */
@property (nonatomic, copy) NSString *name;
/**
 * The notification center where the notification is scheduled.
 */
@property (nonatomic, weak) NSNotificationCenter *center;
/**
 * Selector signature that specifies the message the receiver sends
 * observer to notify it of the notification posting.
 */
@property (nonatomic, copy) NSString *selectorSignature;
/**
 * The block to be executed when the notification is received.
 */
@property (nonatomic, copy) BFNotificationBlock block;
/**
 * The operation queue to which block should be added.
 */
@property (nonatomic, weak) NSOperationQueue *queue;

@end


#pragma mark - BFManagedNotificationObserver Life Cycle

@implementation BFManagedNotificationObserver

- (void)managedObserverAction:(NSNotification *)note {
    __strong id strongObserver = self.observer;
    SEL selector = NSSelectorFromString(_selectorSignature);
    
    // execute notification selector when observer is still active
    if (strongObserver && selector && [strongObserver respondsToSelector:selector])
    {
        NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature:[strongObserver methodSignatureForSelector:selector]];
        myInvocation.target = strongObserver;
        myInvocation.selector = selector;

        // set notification as argument if the method signature implies it
        if(myInvocation.methodSignature.numberOfArguments > kMinNumberOfMethodArguments) {
            [myInvocation setArgument:&note atIndex:myInvocation.methodSignature.numberOfArguments-1];
        }
        [myInvocation invoke];
    }
}

- (void)managedObserverBlock:(NSNotification *)note {
    __strong id strongObserver = self.observer;
    __strong id strongQueue = self.queue;
    // execute notification block when observer is still active
    if (self.block && strongObserver)
    {
        if (strongQueue && [NSOperationQueue currentQueue] != strongQueue)
        {
            [strongQueue addOperationWithBlock:^{
                self.block(note);
            }];
            self.block(note);
        }
        else {
            // execution on current queue
            self.block(note);
        }
    }
}

- (void)dealloc {
    // observer removed on dealloc
    __strong NSNotificationCenter *strongCenter = _center;
    if(strongCenter) {
        [strongCenter removeObserver:self];
    }
}

@end



@implementation NSNotificationCenter (BFManagedNotificationObserver)


#pragma mark - NSNotificationCenter Observer Methods Exchange

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // default observer management methods implementations are exchanged
        [self BFN_exchangeInstanceMethod:@selector(removeObserver:name:object:) withReplacement:@selector(BFN_removeObserver:name:object:)];
        [self BFN_exchangeInstanceMethod:@selector(removeObserver:) withReplacement:@selector(BFN_removeObserver:)];
        [self BFN_exchangeInstanceMethod:@selector(addObserver:selector:name:object:) withReplacement:@selector(BFN_addObserver:selector:name:object:)];
        [self BFN_exchangeInstanceMethod:@selector(addObserverForName:object:queue:usingBlock:) withReplacement:@selector(BFN_addObserverForName:object:queue:usingBlock:)];
    });
}


#pragma mark - NSNotification Observer Removal

- (void)BFN_removeObserver:(id)observer name:(NSString *)aName object:(id)anObject {
    if ([observer isKindOfClass:[BFManagedNotificationObserver class]]) {
        BFManagedNotificationObserver *managedObserver = observer;
        __strong NSObject *strongObserver = managedObserver.observer;
        // remove associated managed observer
        if(strongObserver) {
            [strongObserver BFN_removeAssociatedObject:managedObserver withKey:BFManagedNotificationObserverObserversAssociationKey];
        }
    }
    else {
        // find managed observers of an original observer
        for (BFManagedNotificationObserver *managedObserver in [[observer BFN_getAssociatedObjectForKey:BFManagedNotificationObserverObserversAssociationKey]reverseObjectEnumerator]) {
            __strong id strongObject = managedObserver.object;
            BOOL nameMatches = !managedObserver.name || !aName || [managedObserver.name isEqualToString:aName];
            BOOL objectMatches = !strongObject || !anObject || strongObject == anObject;
            
            if (managedObserver.center == self && nameMatches && objectMatches) {
                [observer BFN_removeAssociatedObject:managedObserver withKey:BFManagedNotificationObserverObserversAssociationKey];
            }
        }
    }

    // call default method implementation
    [self BFN_removeObserver:observer name:aName object:anObject];
}

- (void)BFN_removeObserver:(id)observer {
    [self removeObserver:observer name:nil object:nil];
}


#pragma mark - NSNotification Observer Addition

- (void)BFN_addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject {
    // save notification observer and its information
    BFManagedNotificationObserver *managedObserver = [[BFManagedNotificationObserver alloc] init];
    // check if object allows weak reference
    if([anObject allowsWeakReference]) {
        managedObserver.object = anObject;
    }
    managedObserver.observer = observer;
    managedObserver.name = aName;
    managedObserver.center = self;
    managedObserver.selectorSignature = NSStringFromSelector(aSelector);

    [observer BFN_addAssociatedObject:managedObserver forKey:BFManagedNotificationObserverObserversAssociationKey];
    // call default method implementation
    [self BFN_addObserver:managedObserver selector:@selector(managedObserverAction:) name:aName object:anObject];
}

- (id <NSObject>)BFN_addObserverForName:(nullable NSString *)name object:(nullable id)obj queue:(nullable NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block {
    BFManagedNotificationObserver *managedObserver = [[BFManagedNotificationObserver alloc] init];
    // check if object allows weak reference
    if([obj allowsWeakReference]) {
        managedObserver.object = obj;
    }
    managedObserver.name = name;
    managedObserver.center = self;
    managedObserver.block = block;
    managedObserver.queue = queue;
    
    // call default method implementation
    id observer = [self BFN_addObserverForName:name object:obj queue:queue usingBlock:block];
    // save returned observer
    managedObserver.observer = observer;
    [observer BFN_addAssociatedObject:managedObserver forKey:BFManagedNotificationObserverObserversAssociationKey];
    
    return observer;
}


@end
