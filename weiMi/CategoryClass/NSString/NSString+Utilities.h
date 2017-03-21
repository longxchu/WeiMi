//
//  NSString+Utilities.h
//  Mars
//
//  Created by chris on 4/29/14.
//  Copyright (c) 2014 lifang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utilities)
- (BOOL) contains:(NSString*)string;
- (BOOL)containsCaseInsensitive:(NSString*)string;
- (NSString*) replace:(NSString*) string withString:(NSString*) replace;
- (NSString*) add:(NSString*)string;
- (NSDictionary*) firstAndLastName;
- (BOOL) isValidIdentyID;
- (BOOL) isValidEmail;
- (BOOL) isValidMobile;
- (BOOL) isValidUserName;
- (BOOL) containsOnlyLetters;
- (BOOL) containsOnlyNumbers;
- (BOOL) containsOnlyNumbersAndLetters;
- (NSString*) safeSubstringToIndex:(NSUInteger)index;
- (NSString*) stringByRemovingPrefix:(NSString*)prefix;
- (NSString*) stringByRemovingPrefixes:(NSArray*)prefixes;
- (BOOL) hasPrefixes:(NSArray*)prefixes;
- (BOOL) hasSufixes:(NSArray*)sufixes;
- (BOOL) isEqualToOneOf:(NSArray*)strings;
- (NSString*) md5;
- (NSString*) telephoneWithReformat;
- (NSString*) trim;
- (NSArray*) splitBy:(NSString*) splitString;
- (NSInteger) getIntegerValue;
- (int) getIntValue;
- (int) getLength;
- (int) getLength2;
- (NSString*) base64:(BOOL) encoding;
+ (NSString*) safeString:(NSString*)str;
+ (NSString*) safeNumString:(NSString*)str;
+ (BOOL) isNullOrEmpty:(NSString*)str;
+ (BOOL) equals:(NSString*) str1 to:(NSString*) str2;
+ (NSString*) generateRandomString:(int) length;
+ (NSString*) generateRandomString:(int) length fromSource:(NSString*) source;
+ (NSString*) generateRandomPassword:(int) length;
- (NSComparisonResult)caseSensitiveCompare:(NSString *)aString;
- (int)countWord;
- (CGSize)returnSize:(UIFont *)fnt;
- (CGSize)returnSize:(UIFont *)fnt MaxWidth:(CGFloat)maxWidth;
- (CGFloat)widthForContentWithFontSize:(UIFont*)font;
- (NSString*)confusedMobileNumber;
@end
