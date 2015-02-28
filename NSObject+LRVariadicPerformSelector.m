// NSObject+LRVariadicPerformSelector.m
//
// Copyright (c) 2015 Luis Recuenco
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSObject+LRVariadicPerformSelector.h"

#import <objc/message.h>

static NSUInteger const kSelfAndCmdMagicConstant = 2; // 2 = self + _cmd

@implementation NSObject (LRVariadicSelector)

- (void)lr_performSelector:(SEL)selector withObjects:(id)firstObject, ...
{
    va_list objects;
    va_start(objects, firstObject);
    [self lr_performSelector:selector
               dispatchQueue:nil
              operationQueue:nil
                 firstObject:firstObject
                     objects:objects];
    va_end(objects);
}

- (void)lr_performSelector:(SEL)selector withObject:(id)object dispatchQueue:(dispatch_queue_t)dispatchQueue
{
    [self lr_performSelector:selector dispatchQueue:dispatchQueue withObjects:object, nil];
}

- (void)lr_performSelector:(SEL)selector dispatchQueue:(dispatch_queue_t)dispatchQueue withObjects:(id)firstObject, ...
{
    va_list objects;
    va_start(objects, firstObject);
    [self lr_performSelector:selector
               dispatchQueue:dispatchQueue
              operationQueue:nil
                 firstObject:firstObject
                     objects:objects];
    va_end(objects);
}

- (void)lr_performSelector:(SEL)selector withObject:(id)object operationQueue:(NSOperationQueue *)operationQueue
{
    [self lr_performSelector:selector operationQueue:operationQueue withObjects:object, nil];
}

- (void)lr_performSelector:(SEL)selector operationQueue:(NSOperationQueue *)operationQueue withObjects:(id)firstObject, ...
{
    va_list objects;
    va_start(objects, firstObject);
    [self lr_performSelector:selector
               dispatchQueue:nil
              operationQueue:operationQueue
                 firstObject:firstObject
                     objects:objects];
    va_end(objects);
}

- (void)lr_performSelector:(SEL)selector
             dispatchQueue:(dispatch_queue_t)dispatchQueue
            operationQueue:(NSOperationQueue *)operationQueue
               firstObject:(id)firstObject
                   objects:(va_list)objects
{
    NSParameterAssert(!operationQueue || !dispatchQueue);
    
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    
    NSInteger index = kSelfAndCmdMagicConstant;
    
    for (id object = firstObject; object != nil; object = va_arg(objects, id))
    {
        [invocation setArgument:&object atIndex:index++];
    }
    
    NSParameterAssert(index - kSelfAndCmdMagicConstant == LRSelectorArgumentCount(self, selector));
    
    [self executeInvocation:invocation dispatchQueue:dispatchQueue operationQueue:operationQueue];
}

- (void)executeInvocation:(NSInvocation *)invocation
            dispatchQueue:(dispatch_queue_t)dispatchQueue
           operationQueue:(NSOperationQueue *)operationQueue
{
    void (^invocationBlock)(void) = ^{ [invocation invoke]; };
    
    if (operationQueue)
    {
        if ([NSThread isMainThread] && operationQueue == [NSOperationQueue mainQueue])
        {
            invocationBlock();
        }
        else
        {
            [operationQueue addOperationWithBlock:invocationBlock];
        }
    }
    else if (dispatchQueue)
    {
        if ([NSThread isMainThread] && dispatchQueue == dispatch_get_main_queue())
        {
            invocationBlock();
        }
        else
        {
            dispatch_async(dispatchQueue, invocationBlock);
        }
    }
    else
    {
        invocationBlock();
    }
}

#pragma mark - Helper Selector Argument Count

NS_INLINE NSUInteger LRSelectorArgumentCount(id target, SEL selector)
{
    Method method = class_getInstanceMethod([target class], selector);
    NSInteger arguments = method_getNumberOfArguments(method);
    
    NSCAssert(arguments >= kSelfAndCmdMagicConstant, @"Oops, wrong arguments");
    
    return arguments - 2;
}

@end
