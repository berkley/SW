//
//  PRService.m
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#define FACEBOOK_APP_ID @"109690299158213"
#define FACEBOOK_SECRET @"bc24a392813f84fce1a0607db65739c8"

#define NOTIFICATION_AUTHORIZE_FACEBOOK @"authFacebook"
#define NOTIFICATION_FACEBOOK_LOGOUT @"facebookLogout"
#define NOTIFICATION_REFRESH_SERVICE_LIST @"refreshServiceList"
#define NOTIFICATION_UPDATE_STATUS_TEXT @"updateStatusText"
#define NOTIFICATION_LOCATION_CHANGED @"locationChanged"

#define VALID_LOCATION_COUNT 5
#define MIN_LOCATION_ACCURACY 50
#define PUBLISHING_INTERVAL 60