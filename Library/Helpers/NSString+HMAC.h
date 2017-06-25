//
//  NSString+HMAC.h
//  Created by Andreas Katzian on 1/10/12.
//

@interface NSString (HMAC)

- (NSString*) HMACWithSecret:(NSString*) secret;

@end
