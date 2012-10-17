/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"
#import "ComTiCalendarItemProxy.h"

@interface ComTiCalendarModule : TiModule {
}

-(ComTiCalendarItemProxy*)findEvent:(id)args;
-(BOOL)checkIsDeviceVersionHigherThanRequiredVersion:(NSString *)requiredVersion;
-(BOOL)requestPermission:(id)args;
//-(void)removeAllEvents:(id)args;

@end
