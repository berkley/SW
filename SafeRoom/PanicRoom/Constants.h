//
//  PRService.m
//  PanicRoom
//
//  Created by Chad Berkley on 2/14/12.
//  Copyright (c) 2012 Stumpware. All rights reserved.
//

#define GOOGLE_PLUS_CLIENT_ID @"775363503173.apps.googleusercontent.com"
#define GOOGLE_PLUS_SECRET @"ApZT1EcY0dEF3r6IWkAFE0yb"
#define GOOGLE_PLUS_API_KEY @"AIzaSyB4xtuagnbyoKXI4AGzAupw6ZNeLXgVkk8"
#define GOOGLE_PLUS_REDIRECT_URI @"urn:ietf:wg:oauth:2.0:oob"

#define FACEBOOK_APP_ID @"109690299158213"
#define FACEBOOK_SECRET @"bc24a392813f84fce1a0607db65739c8"

#define TWILIO_APP_ID @"AP15e951f6bdc44dcfa638bb5ff6ee2c25"
#define TWILIO_ACCOUNT_ID @"AC406c99a250ac4020b55b51d3960e9720"
#define TWILIO_SMS_URL @"api.twilio.com/2010-04-01/Accounts"
#define TWILIO_NUMBER @"9712642010"
#define TWILIO_AUTH_TOKEN @"186232c3a83dfbe244fda8c2fa5b043e"

#define NOTIFICATION_AUTHORIZE_FACEBOOK @"authFacebook"
#define NOTIFICATION_FACEBOOK_LOGOUT @"facebookLogout"
#define NOTIFICATION_REFRESH_SERVICE_LIST @"refreshServiceList"
#define NOTIFICATION_UPDATE_STATUS_TEXT @"updateStatusText"
#define NOTIFICATION_LOCATION_CHANGED @"locationChanged"
#define NOTIFICATION_POST_TO_FACEBOOK @"postToFacebook"
#define NOTIFICATION_SERVICE_NOT_ADDED @"serviceNotAdded"

#define VALID_LOCATION_COUNT 5
#define MIN_LOCATION_ACCURACY 100
#define PUBLISHING_INTERVAL 30
#define LOW_RES_DISTANCE_FILTER 30

#define TWITTER_CONSUMER_KEY @"7nE7iS7DToirQnF7rLeBNg"
#define TWITTER_CONSUMER_SECRET @"wM71oWY7teGlvPi91BRFdrORTfLe0mj445801Z7dYA"
#define TWITTER_ACCESS_TOKEN @"475525447-pHCVsEtTXDvlHOK8FIE5OHCRNkZEPfIVsVoLgHjT"
#define TWITTER_ACCESS_TOKEN_SECRET @"CjDFXS7k5QwGf75DlyVFMRCmzlWrua9iKS2gxeA"
#define TWITTER_REQUEST_URL @"https://api.twitter.com/1/"