/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <XCTest/XCTest.h>

#import "FBAlert.h"
#import "FBXCElementSnapshot.h"
#import "XCUIElementDouble.h"

@interface FBAlert (FBAlertTests)
- (nullable id<FBXCElementSnapshot>)alertSnapshot;
@end

@interface FBAlertElementDouble : XCUIElementDouble
@end

@implementation FBAlertElementDouble

- (id)fb_cachedSnapshot
{
  return nil;
}

@end

@interface FBStubbedAlert : FBAlert
@property (nonatomic) FBAlertElementDouble *element;
@property (nonatomic, nullable) id resolvedSnapshot;
@end

@implementation FBStubbedAlert

- (XCUIElement *)alertElementFromApplication:(id<FBXCElementSnapshot> _Nullable *)snapshotOut
{
  *snapshotOut = self.resolvedSnapshot;
  return (XCUIElement *)self.element;
}

@end

@interface FBAlertTests : XCTestCase
@end

@implementation FBAlertTests

// Safari web alerts resolve to the enclosing ScrollView element but report the dialog's own snapshot.
- (void)testAlertSnapshotKeepsSnapshotFromResolution
{
  FBStubbedAlert *alert = FBStubbedAlert.new;
  alert.element = FBAlertElementDouble.new;
  alert.resolvedSnapshot = NSObject.new;
  XCTAssertEqual(alert.alertSnapshot, alert.resolvedSnapshot);
}

- (void)testAlertSnapshotFallsBackToElementSnapshot
{
  FBStubbedAlert *alert = FBStubbedAlert.new;
  alert.element = FBAlertElementDouble.new;
  XCTAssertEqual(alert.alertSnapshot, alert.element.fb_customSnapshot);
}

@end
