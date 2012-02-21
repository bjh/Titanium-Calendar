/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "ComTiCalendarItemProxy.h"
#import "TiUtils.h"
#import "TiBase.h"
#import <EventKit/EventKit.h>
#import <Foundation/NSFormatter.h>

@implementation ComTiCalendarItemProxy

-(id)initWithEvent: (EKEvent *)event
{
	if (self=[super init])
	{
		[self setTitle:event.title];
		[self setStartDate:event.startDate];
		[self setEndDate:event.endDate];
		[self setLocation:event.location];
    [self setNotes:event.notes];
		[self replaceValue:event.eventIdentifier forKey:@"eventIdentifier" notification:NO];
	}
//  NSLog(@"<CALENDAR MODULE> init self: %@", self);
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	[super didReceiveMemoryWarning:notification];
}

#pragma mark -
#pragma mark HereAreTheSettersAndGetters

-(id)title
{	
//  NSLog(@"title: %@", [self valueForUndefinedKey:@"title"]);
	return [self valueForUndefinedKey:@"title"];
}

-(void)setTitle:(id)value
{
	ENSURE_TYPE_OR_NIL(value,NSString);
	// make sure to store the value into dynprops as well, this
	// normally is set during the createFooBar({title:"blah"}); 
	[self replaceValue:value forKey:@"title" notification:NO];
//  NSLog(@"setTitle: %@ : %@", value, [self valueForUndefinedKey:@"title"]);
}

-(id)location
{	
//  NSLog(@"location: %@", [self valueForUndefinedKey:@"location"]);
	return [self valueForUndefinedKey:@"location"];
}

-(void)setLocation:(id)value
{
	ENSURE_TYPE_OR_NIL(value,NSString);
	[self replaceValue:value forKey:@"location" notification:NO];
//  NSLog(@"setLocation: %@", value);
}


-(id)notes
{	
//  NSLog(@"location: %@", [self valueForUndefinedKey:@"notes"]);
	return [self valueForUndefinedKey:@"notes"];
}

-(void)setNotes:(id)value
{
	ENSURE_TYPE_OR_NIL(value,NSString);
	[self replaceValue:value forKey:@"notes" notification:NO];
//  NSLog(@"setNotes: %@", value);
}

-(id)startDate
{
	// grab the value from the dynprops first of all
	NSDate *tmpSdate = [self valueForUndefinedKey:@"startDate"];
	// if it's a sane value, then let's format it out
	if (tmpSdate != nil) {
		return [NSDateFormatter localizedStringFromDate:tmpSdate
                                          dateStyle:NSDateFormatterMediumStyle
                                          timeStyle:NSDateFormatterShortStyle];
	}		
	return @"";
}

-(void)setStartDate:(id)value
{
	ENSURE_TYPE_OR_NIL(value,NSDate);
//  NSLog(@"<CALENDAR MODULE> setStartDate: %@", value);
	// make sure to store the value into dynprops as well, this
	// normally is set during the createFooBar({title:"blah"}); 
	[self replaceValue:value forKey:@"startDate" notification:NO];
}

-(id)endDate
{
	// grab the value from the dynprops first of all
	NSDate *tmpEdate = [self valueForUndefinedKey:@"endDate"];
	// if it's a sane value, then let's format it out
	if (tmpEdate != nil) {
		return [NSDateFormatter localizedStringFromDate:tmpEdate
                                          dateStyle:NSDateFormatterMediumStyle
                                          timeStyle:NSDateFormatterShortStyle];
	}		
	return @"";
}

-(void)setEndDate:(id)value
{
	ENSURE_TYPE_OR_NIL(value,NSDate);
//  NSLog(@"<CALENDAR MODULE> setEndDate: %@", value);
	[self replaceValue:value forKey:@"endDate" notification:NO];
}

-(ComTiCalendarItemProxy *)save:(id)obj {
  EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
  EKEvent *_event = [eventStore eventWithIdentifier: [self valueForUndefinedKey:@"eventIdentifier"]];
	
  if (!_event) {
    _event = [EKEvent eventWithEventStore:eventStore];
  }
  
  _event.title = [self valueForUndefinedKey:@"title"];
	_event.location = [self valueForUndefinedKey:@"location"];	
  _event.notes = [self valueForUndefinedKey:@"notes"];
	_event.startDate = [self valueForUndefinedKey:@"startDate"];	
	_event.endDate = [[[NSDate alloc] initWithTimeInterval:1200 sinceDate:_event.startDate] autorelease];
  
//  NSLog(@"<CALENDAR MODULE> event: %@", _event);
	
  [_event setCalendar:[eventStore defaultCalendarForNewEvents]];
  NSError *err = nil;
  [eventStore saveEvent:_event span:EKSpanThisEvent error:&err];   
	BOOL status = (err == nil) ? TRUE : FALSE;
  
  if (status) {
    [self replaceValue:_event.eventIdentifier forKey:@"eventIdentifier" notification:NO];
    return self;
  }
  
//  NSLog(@"<CALENDAR MODULE> ERROR: %@", [err localizedDescription]);
  return nil;
}

-(NSDictionary *)remove:(id)value
{
	EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
	EKEvent *event = [eventStore eventWithIdentifier: [self valueForUndefinedKey:@"eventIdentifier"]];
	// not setting this causes all SORTS of explosions when you try to call localizedDescription later
	NSError *err = nil;
	if (event != nil) {
		[eventStore removeEvent:event span:EKSpanThisEvent error:&err];
	}
	BOOL status = (err == nil) ? TRUE : FALSE;
	NSString *errStr = (err != nil) ? [err localizedDescription] : @"none";	
	NSDictionary *tmp = [[[NSDictionary alloc] initWithObjectsAndKeys: errStr, @"error", 
                        NUMBOOL(status), @"status",
                        nil] autorelease];
	return tmp;
}

@end
