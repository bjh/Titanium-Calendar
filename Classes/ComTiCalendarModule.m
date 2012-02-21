/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComTiCalendarModule.h"
#import "ComTiCalendarItemProxy.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import <EventKit/EventKit.h>


@implementation ComTiCalendarModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"86953d9f-08f1-44d6-8f40-857de82a8403";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.ti.calendar";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma Public APIs

-(ComTiCalendarItemProxy*)findEvent:(id)args {
  ENSURE_SINGLE_ARG(args,NSString);
  EKEventStore *store = [[[EKEventStore alloc] init] autorelease];
  EKEvent *event = [store eventWithIdentifier:args];
  
  if (event) {
    ComTiCalendarItemProxy *event_proxy = [[[ComTiCalendarItemProxy alloc] initWithEvent: event] autorelease];
    return event_proxy;
  }

  return nil;
}

//-(void)removeAllEvents:(id)args {
//  NSLog(@"<CALENDAR MODULE> removeAllEvents");
//  NSDate *start = [NSDate distantPast];
//  NSDate *finish = [NSDate distantFuture];
//  
//  NSLog(@"<CALENDAR MODULE> start: %@", start);
//  NSLog(@"<CALENDAR MODULE> finish: %@", finish);
//  
//  // use Dictionary for remove duplicates produced by events covered more one year segment
//  NSMutableDictionary *eventsDict = [NSMutableDictionary dictionaryWithCapacity:1024];
//  NSDate* currentStart = [NSDate dateWithTimeInterval:0 sinceDate:start];
//  EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
//  int seconds_in_year = 60*60*24*365;
//  
//  while ([currentStart compare:finish] == NSOrderedAscending) {
//    NSDate* currentFinish = [NSDate dateWithTimeInterval:seconds_in_year sinceDate:currentStart];
//    
//    if ([currentFinish compare:finish] == NSOrderedDescending) {
//      currentFinish = [NSDate dateWithTimeInterval:0 sinceDate:finish];
//    }    
//    
//    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:currentStart endDate:currentFinish calendars:nil];
//    [eventStore enumerateEventsMatchingPredicate:predicate
//                                      usingBlock:^(EKEvent *event, BOOL *stop) {                                        
//                                        if (event) {
//                                          [eventsDict setObject:event forKey:event.eventIdentifier];
//                                        }                                        
//                                      }];       
//    currentStart = [NSDate dateWithTimeInterval:(seconds_in_year + 1) sinceDate:currentStart];
//  }
//  
////  NSArray *events = [eventsDict allValues];
//	// not setting this causes all SORTS of explosions when you try to call localizedDescription later
////	NSError *err = nil;
////	if (event != nil) {
////		[eventStore removeEvent:event span:EKSpanThisEvent error:&err];
////	}
//  
//  for (id event in [eventsDict allValues]) {
////    NSLog(@"is event? %@", [event isKindOfClass:[EKEvent class]]);
//    NSLog(@"<CALENDAR MODULE> event: %@", event);
//  }
//}


@end
