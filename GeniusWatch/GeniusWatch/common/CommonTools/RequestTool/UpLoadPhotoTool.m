//
//  UpdateLoadPhotoTool.m
//  SmallPig
//
//  Created by clei on 15/3/4.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "UpLoadPhotoTool.h"
#import "AFNetworking.h"


@interface UpLoadPhotoTool()
{
    AFHTTPRequestOperation *requestOperation;
}
@property(nonatomic, strong) NSString *upLoadUrl;
@property(nonatomic, strong) NSArray *photoArray;
@property(nonatomic, assign) int type;
@end

@implementation UpLoadPhotoTool

- (instancetype) initWithPhotoArray:(NSArray *)array upLoadUrl:(NSString *)url  upLoadType:(int)type
{
    self = [super init];
    
    if (self)
    {
        self.currentIndex = 0;
        self.photoArray = array;
        url = (url) ? url : @"";
        self.upLoadUrl = url;
        self.type = type;
        [self upLoadPhotos];
    }
    return self;
}


- (void)upLoadPhotos
{
    if (!self.photoArray || [self.photoArray count] == 0)
        return;
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
        ^{
            for (int i = 0; i < [self.photoArray count]; i++)
            {
                self.currentIndex = i;
                [self upLoadPhotoWithImage:self.photoArray[i] upLoadType:self.type];
            }
        });
    }
}


- (void)upLoadPhotoWithImage:(UIImage *)image upLoadType:(int)type
{
    //上传图片
    __block typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"category":@(type)};
    requestDic = (type == 0) ? @{} : requestDic;
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.requestSerializer = [AFHTTPRequestSerializer  serializer];
    //manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",@"text/plain",nil];
    requestOperation =  [manager POST:weakSelf.upLoadUrl parameters:requestDic
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        if (image)
        {
            NSData *data = UIImageJPEGRepresentation(image, .1);
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
            [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"%.0f%d.png",time,self.currentIndex] mimeType:@"image/png"];
        }
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        weakSelf.responseDic = responseObject;
        NSDictionary *dic = (NSDictionary *)responseObject;
        int sucess = [dic[@"responseMessage"][@"success"] intValue];
        if (sucess == 1)
        {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadPhotoSucessed:)])
            {
                [weakSelf.delegate uploadPhotoSucessed:self];
            }
        }
        if (sucess == 0)
        {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadPhotoFailed:)])
            {
                [weakSelf.delegate uploadPhotoFailed:weakSelf];
            }
        }
        NSLog(@"operationresponseObject===%@",operation.responseString);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadPhotoFailed:)])
        {
            [weakSelf.delegate uploadPhotoFailed:weakSelf];
        }
         NSLog(@"error===%@",error);
    }];
    //添加进度
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         NSLog(@"totalBytesWritten===%lld====totalBytesExpectedToWrite====%lld",totalBytesWritten,totalBytesExpectedToWrite);
         if (totalBytesWritten <= totalBytesExpectedToWrite)
         {
             if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadPhoto:isUploadedPhotoProcess:)])
             {
                 [weakSelf.delegate uploadPhoto:weakSelf isUploadedPhotoProcess:totalBytesWritten * 1.0/totalBytesExpectedToWrite];
             }
         }
     }];
    [requestOperation waitUntilFinished];
    
}

@end
