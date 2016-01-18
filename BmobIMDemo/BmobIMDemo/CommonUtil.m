//
//  CommonUtil.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-25.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "CommonUtil.h"
#import "BMapKit.h"

@implementation CommonUtil

#pragma mark ui
+(UILabel*)navigationTitleViewWithTitle:(NSString *)title{
    
    UILabel *titleLabel        = [[UILabel alloc] init];
    titleLabel.frame           = CGRectMake(100, 0, 120, 44);
    titleLabel.font            = [UIFont boldSystemFontOfSize:20];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    titleLabel.text            = title;
    titleLabel.textColor       = [UIColor whiteColor];
    return titleLabel;
}

+(UIFont*)setFontSize:(CGFloat)size{
    return [UIFont systemFontOfSize:size];
}

+(UIColor*)setColorByR:(float)r G:(float)g   B:(float)b{
    
    return [UIColor colorWithRed: r/256.f green:g/256.f blue:b/256.f alpha:1.f];
}

#pragma mark
+(void)needLoginWithViewController:(UIViewController*)viewController animated:(BOOL)animated{
    
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] boolValue]) {
        LoginViewController *lvc = [[LoginViewController alloc] init];
        UINavigationController *lnc= [[UINavigationController alloc] initWithRootViewController:lvc];
        if (IS_iOS7) {
            [lnc.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar"] forBarMetrics:UIBarMetricsDefault];
        }else{
            [lnc.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar1"] forBarMetrics:UIBarMetricsDefault];
        }
        
        lnc.navigationBarHidden = YES;
        
        [viewController presentViewController:lnc animated:animated completion:^{
            
        }];
    }
  
}

+(NSString*)turnStringToEmojiText:(NSString *)string{
    NSRegularExpression *  emojiRegularExpress = [[NSRegularExpression alloc] initWithPattern:@"\\\\ue[a-z0-9A-Z]{3}" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString *description = string;
    NSString *text        = description;
    NSArray   *array      = [emojiRegularExpress matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    
    if ([array count] !=0) {
        for (NSTextCheckingResult *b in array) {
            NSString *string = [description substringWithRange:b.range];
            NSString *newString = [self decodeUnicodeBytes:(char *)[string UTF8String]];
            text = [text stringByReplacingOccurrencesOfString:string withString:newString];
        }
    }
    
    return text;
}


+(NSString *)decodeUnicodeBytes:(char *)stringEncoded {
    unsigned int    unicodeValue;
    char            *p, buff[5];
    NSMutableString *theString;
    NSString        *hexString;
    NSScanner       *pScanner;
    
    theString = [[NSMutableString alloc] init];
    p = stringEncoded;
    
    buff[4] = 0x00;
    while (*p != 0x00) {
        
        if (*p == '\\') {
            p++;
            if (*p == 'u') {
                memmove(buff, ++p, 4);
                
                hexString = [NSString stringWithUTF8String:buff];
                pScanner = [NSScanner scannerWithString: hexString];
                [pScanner scanHexInt: &unicodeValue];
                
                [theString appendFormat:@"%C", (unichar)unicodeValue];
                p += 4;
                continue;
            }
        }
        
        [theString appendFormat:@"%c", *p];
        p++;
    }
    
    return [NSString stringWithString:theString];
}


+(NSString *)turnEmojiStringToString:(NSString*)string{
    NSRegularExpression *  emojiRegularExpress = [[NSRegularExpression alloc] initWithPattern:@"\\\\ue[a-z0-9A-Z]{3}" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString *description = string;
    NSString *text        = description;
    NSArray   *array      = [emojiRegularExpress matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    
    if ([array count] !=0) {
        for (NSTextCheckingResult *b in array) {
            NSString *string = [description substringWithRange:b.range];
            
            NSString *newString = [NSString stringWithFormat:@"\\%@",string];//[self unescapeUnicodeString:string];
            text = [text stringByReplacingOccurrencesOfString:string withString:newString];
        }
    }
    NSLog(@"text%@,array count%d",text,[array count]);
    return text;
}


+(NSString *)filepath{
    NSArray  *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirecotry =[paths objectAtIndex:0];
    return documentDirecotry;
}


+ (NSString*) unescapeUnicodeString:(NSString*)string
{
    // unescape quotes and backwards slash
    NSString* unescapedString = [string stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    unescapedString = [unescapedString stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    
    // tokenize based on unicode escape char
    NSMutableString* tokenizedString = [NSMutableString string];
    NSScanner* scanner = [NSScanner scannerWithString:unescapedString];
    while ([scanner isAtEnd] == NO)
    {
        // read up to the first unicode marker
        // if a string has been scanned, it's a token
        // and should be appended to the tokenized string
        NSString* token = @"";
        [scanner scanUpToString:@"\\u" intoString:&token];
        if (token != nil && token.length > 0)
        {
            [tokenizedString appendString:token];
            continue;
        }
        
        // skip two characters to get past the marker
        // check if the range of unicode characters is
        // beyond the end of the string (could be malformed)
        // and if it is, move the scanner to the end
        // and skip this token
        NSUInteger location = [scanner scanLocation];
        NSInteger extra = scanner.string.length - location - 4 - 2;
        if (extra < 0)
        {
            NSRange range = {location, -extra};
            [tokenizedString appendString:[scanner.string substringWithRange:range]];
            [scanner setScanLocation:location - extra];
            continue;
        }
        
        // move the location pas the unicode marker
        // then read in the next 4 characters
        location += 2;
        NSRange range = {location, 4};
        token = [scanner.string substringWithRange:range];
        unichar codeValue = (unichar) strtol([token UTF8String], NULL, 16);
        [tokenizedString appendString:[NSString stringWithFormat:@"%C", codeValue]];
        
        // move the scanner past the 4 characters
        // then keep scanning
        location += 4;
        [scanner setScanLocation:location];
    }
    
    // done
    return tokenizedString;
}

+ (NSString*) escapeUnicodeString:(NSString*)string
{
    // lastly escaped quotes and back slash
    // note that the backslash has to be escaped before the quote
    // otherwise it will end up with an extra backslash
    NSString* escapedString = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    // convert to encoded unicode
    // do this by getting the data for the string
    // in UTF16 little endian (for network byte order)
    NSData* data = [escapedString dataUsingEncoding:NSUTF16LittleEndianStringEncoding allowLossyConversion:YES];
    size_t bytesRead = 0;
    const char* bytes = data.bytes;
    NSMutableString* encodedString = [NSMutableString string];
    
    // loop through the byte array
    // read two bytes at a time, if the bytes
    // are above a certain value they are unicode
    // otherwise the bytes are ASCII characters
    // the %C format will write the character value of bytes
    while (bytesRead < data.length)
    {
        uint16_t code = *((uint16_t*) &bytes[bytesRead]);
        if (code > 0x007E)
        {
            [encodedString appendFormat:@"\\u%04x", code];
        }
        else
        {
            [encodedString appendFormat:@"%c", code];
        }
        bytesRead += sizeof(uint16_t);
    }
    
    // done
    return encodedString;
}

+(BOOL)saveImage:(UIImage*)image filepath:(NSString *)path{
//    NSFileManager *defaultFileManager = [NSFileManager defaultManager];
    NSData *data = UIImageJPEGRepresentation(image, 0.9f);
    return  [data writeToFile:path atomically:YES ];
}

+(CLLocationCoordinate2D)turnToBaiduCoordinate2DWithGPSCoordinate2D:(CLLocationCoordinate2D)coor{
    CLLocationDegrees longitude     = coor.longitude;
    CLLocationDegrees latitude      = coor.latitude;
    CLLocationCoordinate2D gpsCoor  = CLLocationCoordinate2DMake(latitude, longitude);
    //百度坐标
    CLLocationCoordinate2D bmapCoor = BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(gpsCoor,BMK_COORDTYPE_GPS));
    return bmapCoor;
}

+(CLLocationDistance)distanceBetweenCoordinate2D:(CLLocationCoordinate2D)coor coordinate2D1:(CLLocationCoordinate2D)coor1{
    BMKMapPoint point = BMKMapPointForCoordinate(coor);
    BMKMapPoint point1 = BMKMapPointForCoordinate(coor1);
    
    return BMKMetersBetweenMapPoints(point,point1);
}

@end
