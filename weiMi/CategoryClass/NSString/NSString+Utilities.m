//
//  NSString+Utilities.m
//  Mars
//
//  Created by chris on 4/29/14.
//  Copyright (c) 2014 lifang. All rights reserved.
//

#define kMaxEmailLength 64

#import "NSString+Utilities.h"
#import <CommonCrypto/CommonDigest.h>
#import "WeiMiSystemInfo.h"

@implementation NSString (Utilities)
- (BOOL)contains:(NSString*)string {
    return [self rangeOfString:string].location != NSNotFound;
}

- (BOOL)containsCaseInsensitive:(NSString*)string {
    return [self rangeOfString:string options:NSCaseInsensitiveSearch].location != NSNotFound;
}

- (BOOL) isValidIdentyID
{
    BOOL flag = NO;
    if (self.length <= 0)
    {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    flag = [identityCardPredicate evaluateWithObject:self];
    
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(flag)
    {
        if(self.length==18)
        {
            //将前17位加权因子保存在数组里
            NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
            
            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
            
            //用来保存前17位各自乖以加权因子后的总和
            
            NSInteger idCardWiSum = 0;
            for(int i = 0;i < 17;i++)
            {
                NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
                NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
                
                idCardWiSum+= subStrIndex * idCardWiIndex;
                
            }
            
            //计算出校验码所在数组的位置
            NSInteger idCardMod=idCardWiSum%11;
            
            //得到最后一位身份证号码
            NSString * idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
            
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if(idCardMod==2)
            {
                if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
                {
                    return flag;
                }else
                {
                    flag =  NO;
                    return flag;
                }
            }else
            {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
                {
                    return flag;
                }
                else
                {
                    flag =  NO;
                    return flag;
                }
            }
        }
        else
        {
            flag =  NO;
            return flag;
        }
    }
    else
    {
        return flag;
    }
    
    return flag;
}

- (BOOL)isValidEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL validEmail = [emailTest evaluateWithObject:self];
    if(validEmail && self.length <= kMaxEmailLength)
        return YES;
    return NO;
}

- (BOOL) isValidUserName{
    //Only contains chinese characters, numbers, letters, _
    if ([self isValidEmail]) {
        return YES;
    }
    NSString *userNameRegex = @"^[\u4e00-\u9fa5a-zA-Z0-9_]+$";
    NSPredicate *userNameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userNameRegex];
    BOOL validUserName = [userNameTest evaluateWithObject:self];
    if(validUserName){
        return YES;
    }
    return NO;
}

- (NSArray*) splitBy:(NSString *)splitString{
    return [self componentsSeparatedByString: splitString];
//    return [self componentsSeparatedByCharactersInSet:
//            [NSCharacterSet characterSetWithCharactersInString:splitString]
//            ];
}

- (BOOL) isValidMobile{
    return [self isWildMobile];
//            [self isValidMobile2] ||
//            [self isValidCMMobile] ||
//            [self isValidCUMobile] ||
//            [self isValidCTMobile];
}

- (BOOL) isWildMobile{
    NSString * MOBILE = @"^\\d{11}$";
    NSPredicate *regexTestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regexTestMobile evaluateWithObject:self];
}

- (BOOL) isValidMobile2{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSPredicate *regexTestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regexTestMobile evaluateWithObject:self];
}

- (BOOL) isValidCMMobile{
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     12         */
    NSString * CM = @"^1((34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)|705)\\d{7}$";
    NSPredicate *regexTestCM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    return [regexTestCM evaluateWithObject:self];
}

- (BOOL) isValidCUMobile{
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,1709
     17         */
    NSString * CU = @"^1(((3[0-2]|5[256]|8[56])\\d)|709)\\d{7}$";
    NSPredicate *regexTestCU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    return [regexTestCU evaluateWithObject:self];
}

- (BOOL) isValidCTMobile{
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,1700
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349|700)\\d{7}$";
    NSPredicate *regexTestCT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    return [regexTestCT evaluateWithObject:self];
}

- (BOOL) isValidPHSMobile{
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regexTestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    return [regexTestPHS evaluateWithObject:self];
}

- (NSString*)add:(NSString*)string
{
    if(!string || string.length == 0)
        return self;
    return [self stringByAppendingString:string];
}

- (NSDictionary*)firstAndLastName
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSArray *comps = [self componentsSeparatedByString:@" "];
    if(comps.count > 0) dic[@"firstName"] = comps[0];
    if(comps.count > 1) dic[@"lastName"] = comps[1];
    return dic;
}

- (BOOL)containsOnlyLetters
{
    NSCharacterSet *blockedCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
}

- (BOOL)containsOnlyNumbers
{
    NSCharacterSet *numbers = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbers].location == NSNotFound);
}

- (BOOL)containsOnlyNumbersAndLetters
{
    NSCharacterSet *blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
}

- (NSString*)safeSubstringToIndex:(NSUInteger)index
{
    if(index >= self.length)
        index = self.length - 1;
    return [self substringToIndex:index];
}

- (NSString*)stringByRemovingPrefix:(NSString*)prefix
{
    NSRange range = [self rangeOfString:prefix];
    if(range.location == 0) {
        return [self stringByReplacingCharactersInRange:range withString:@""];
    }
    return self;
}

- (NSString*)stringByRemovingPrefixes:(NSArray*)prefixes
{
    for(NSString *prefix in prefixes) {
        NSRange range = [self rangeOfString:prefix];
        if(range.location == 0) {
            return [self stringByReplacingCharactersInRange:range withString:@""];
        }
    }
    return self;
}

- (BOOL)hasPrefixes:(NSArray*)prefixes
{
    for(NSString *prefix in prefixes) {
        if([self hasPrefix:prefix])
            return YES;
    }
    return NO;
}

- (BOOL) hasSufixes:(NSArray *)sufixes{
    for (NSString *sufix in sufixes) {
        if([self hasSuffix:sufix]){
            return YES;
        }
    }
    return NO;
}

- (BOOL)isEqualToOneOf:(NSArray*)strings
{
    for(NSString *string in strings) {
        if([self isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString*)telephoneWithReformat
{
    if ([self contains:@"-"])
    {
        return [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    if ([self contains:@" "])
    {
        return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if ([self contains:@"("])
    {
        return [self stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    
    if ([self contains:@")"])
    {
        return [self stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    
    return self;
}

- (NSString*) replace:(NSString *)string withString:(NSString *)replace{
    return [self stringByReplacingOccurrencesOfString:string withString:replace];
}

- (NSString*) trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSInteger) getIntegerValue{
    NSString *newString = [[self componentsSeparatedByCharactersInSet:
                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                           componentsJoinedByString:@""];
    return [newString integerValue];
}

- (int) getIntValue{
    return (int)[self getIntegerValue];
}

- (int) getLength{
    int length = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            length++;
        }
        else {
            p++;
        }
        
    }
    return length;
}

- (int) getLength2{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self dataUsingEncoding:enc];
    return (int)[da length];
}

- (NSString*) base64:(BOOL)encoding{
    if([NSString isNullOrEmpty:self]){
        return @"";
    }
    if(encoding){
        NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
        if([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]){
            return [plainData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        }
        else if([plainData respondsToSelector:@selector(base64Encoding)]){
            return [plainData base64Encoding];
        }
    }
    else{
        NSData *decodedData = nil;
        if([[NSData alloc] respondsToSelector:@selector(initWithBase64EncodedString:options:)]){
            decodedData = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];;
        }
        else if([[NSData alloc] respondsToSelector:@selector(initWithBase64Encoding:)]){
            decodedData = [[NSData alloc] initWithBase64Encoding:self];
        }
        NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        return decodedString;
    }
    return self;
}

+ (NSString*) safeString:(NSString*)str{
    return [NSString isNullOrEmpty:str]? @"" : str;
}

+ (NSString*) safeNumString:(NSString*)str{
    return [NSString isNullOrEmpty:str]? @"0" : str;
}

+ (BOOL) isNullOrEmpty:(NSString*)str{
    //return  !str || str==nil || (NSString*)[NSNull null]==str || [str isEqualToString:@""];
    if (!str || str == nil || str == NULL || [str isKindOfClass:[NSNull class]] || str == (NSString*)[NSNull null]) {
        return YES;
    }else if([str isEqualToString:@""] || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 ){//这样安全，判断为@"" 和 判断ledgth=0 在不是null的前提下才不会crash，已试过多次，去掉前面的前提判if (!str || str == nil || str == NULL || [str isKindOfClass:[NSNull class]] || str == (NSString*)[NSNull null]) 遇到str = "<null>" 时会crash
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL) equals:(NSString *)str1 to:(NSString *)str2{
    if([NSString isNullOrEmpty:str1]){
        return [NSString isNullOrEmpty:str2];
    }
    if([NSString isNullOrEmpty:str2]){
        return [NSString isNullOrEmpty:str1];
    }
    return [str1 isEqualToString:str2];
}

char *appendRandom(char *str, char *alphabet, int amount) {
    for (int i = 0; i < amount; i++) {
        int r = arc4random() % strlen(alphabet);
        *str = alphabet[r];
        str++;
    }
    
    return str;
}

+ (NSString*) generateRandomPassword:(int)length{
    
    // Build the password using C strings - for speed
    int capitals = length/4;
    int digits = length/4;
    int symbols = length/4;
    int letters = length-symbols-capitals-digits;
    
    char *cPassword = calloc(length + 1, sizeof(char));
    char *ptr       = cPassword;
    
    cPassword[length - 1] = '\0';
    
    char *lettersAlphabet = "abcdefghijklmnopqrstuvwxyz";
    ptr = appendRandom(ptr, lettersAlphabet, letters);
    
    char *capitalsAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    ptr = appendRandom(ptr, capitalsAlphabet, capitals);
    
    char *digitsAlphabet = "0123456789";
    ptr = appendRandom(ptr, digitsAlphabet, digits);
    
    char *symbolsAlphabet = "!@#$%*[];?()";
    ptr = appendRandom(ptr, symbolsAlphabet, symbols);
    
    // Shuffle the string!
    for (int i = 0; i < length; i++) {
        int  r    = arc4random() % length;
        char temp = cPassword[i];
        cPassword[i] = cPassword[r];
        cPassword[r] = temp;
    }
    
    NSString *password = [NSString stringWithCString:cPassword encoding:NSUTF8StringEncoding];
    
    // Clean up
    free(cPassword);
    
    return password;
}

+ (NSString*) generateRandomString:(int)length{
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    return [self generateRandomString:length fromSource:letters];
}

+ (NSString*) generateRandomString:(int)length fromSource:(NSString *)source {
    if ([NSString isNullOrEmpty:source]) {
        return nil;
    }
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    for (int i=0; i<length; i++) {
        [randomString appendFormat: @"%C", [source characterAtIndex: arc4random() % [source length]]];
    }
    return randomString;
}

- (NSComparisonResult)caseSensitiveCompare:(NSString *)aString {
    return [self compare:aString options:NSLiteralSearch];
}

- (int)countWord {
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

-(CGSize)returnSize:(UIFont *)fnt{
    CGSize size;
    if (IOS7_OR_LATER) {
        size = [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    }else{
        //size=[self sizeWithFont:fnt constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    }
    return size;
}

-(CGSize)returnSize:(UIFont *)fnt MaxWidth:(CGFloat)maxWidth{
    CGSize size;
    if (IOS7_OR_LATER) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:fnt, NSParagraphStyleAttributeName:paragraphStyle.copy};
        size = [self boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }else{
        //size=[self sizeWithFont:fnt constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    }
    return size;
}

- (CGFloat)widthForContentWithFontSize:(UIFont*)font;
{
    if (!font) {
        return 0;
    }
    CGSize textBlockMinSize = CGSizeMake(SCREEN_WIDTH-10*2, CGFLOAT_MAX);
    CGSize size;
    if (IOS6_OR_LATER) {
        //size = [self sizeWithFont:font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
    }else{
        size = [self boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:font} context:nil].size;
    }
    
    return size.width;
}

- (NSString *)confusedMobileNumber{

    if ([self isValidMobile]) {
        return    [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else{
        return self;
    }
}
@end
