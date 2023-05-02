#import "RNCrispyCouscous.h"
#import <React/RCTEventDispatcher.h>

@implementation RNCrispyCouscous

RCT_EXPORT_MODULE(AppIconManager);

RCT_EXPORT_METHOD(callAppIconArrayWithCallBack:(RCTResponseSenderBlock)callBlock){
  
  NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
  NSDictionary *fileDict = dict[@"CFBundleIcons"];
  NSDictionary *iconDictionary = fileDict[@"CFBundleAlternateIcons"];
  NSArray *keysArray = iconDictionary.allKeys;
  NSMutableArray *tempArray = [NSMutableArray array];

  for (int i=0; i < keysArray.count; i++) {
    NSString *itemname = keysArray[i];
    NSDictionary *item = [iconDictionary objectForKey:itemname];
    NSArray *imageArray = item[@"CFBundleIconFiles"];
    if (imageArray.count > 0) {
      [tempArray addObject:@{@"imageName":itemname}];
    }
  }
  callBlock(@[tempArray]);
}

RCT_EXPORT_METHOD(calliOSAction:(NSString *)iconName callBlock:(RCTResponseSenderBlock)callBlock){
    __block NSString *tempIconName =  iconName;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[UIApplication sharedApplication] supportsAlternateIcons]) {
            return;
        }
        if ([tempIconName isEqualToString:@""]) {
            tempIconName = nil;
        }
        [[UIApplication sharedApplication] setAlternateIconName:tempIconName completionHandler:^(NSError * _Nullable error) {
            if (error) {
              callBlock(@[@"AppIcon Changed Fail",@"2"]);
            }else{
              callBlock(@[@"AppIcon Changed Success",@"1"]);
            }
        }];
    });
}


@end
