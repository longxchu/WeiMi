//
//  WeiMiUpdateImgRequest.m
//  weiMi
//
//  Created by 梁宪松 on 2016/10/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiUpdateImgRequest.h"
#import "AFURLRequestSerialization.h"

@implementation WeiMiUpdateImgRequest{
    UIImage *_image;
}

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/UploadPictures.html";
}

-(YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeHTTP;
}

- (AFConstructingBlock)constructingBodyBlock {
    
    return ^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(_image, 0.9);
        NSString *name = @"imgFile";
        NSString *fileName = @"jpg";
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:type];
    };
}

//- (id)jsonValidator {
//    return @{ @"imageId": [NSString class] };
//}


- (NSString *)responseImagePath {
    
    NSString *string = self.responseString;
    if (string) {

        NSString *str = [string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        return str;
    }
    return nil;
}

@end
