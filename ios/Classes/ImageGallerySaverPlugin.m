#import "ImageGallerySaverPlugin.h"
@interface ImageGallerySaverPlugin()
@property(nonatomic,copy)FlutterResult result;
@end
@implementation ImageGallerySaverPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"image_gallery_saver"
            binaryMessenger:[registrar messenger]];
  ImageGallerySaverPlugin* instance = [[ImageGallerySaverPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    self.result = result;
  if ([@"saveImageToGallery" isEqualToString:call.method]) {
      NSData *imageData = ((FlutterStandardTypedData *)call.arguments).data;
      UIImage *image = [UIImage imageWithData:imageData];
      UIImageWriteToSavedPhotosAlbum(image, self, @selector(didFinishSavingImage:error:contextInfo:), nil);
  }else if ([@"saveFileToGallery" isEqualToString:call.method]){
      NSString *path = call.arguments;
      if ([self isImageFile:path]) {
          UIImage *image = [UIImage imageWithContentsOfFile:path];
          if (image) {
              UIImageWriteToSavedPhotosAlbum(image, self, @selector(didFinishSavingImage:error:contextInfo:), nil);
          }
      }else{
          if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
              UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(didFinishSavingVideo:error:contextInfo:), nil);
          }
      }
  } else {
    result(FlutterMethodNotImplemented);
  }
}
-(void)didFinishSavingImage:(UIImage *)image error:(NSError *)error contextInfo:(id)contextInfo{
    NSLog(@"wan");
    self.result(@(error == nil));
}
-(void)didFinishSavingVideo:(NSString *)videoPath error:(NSError *)error contextInfo:(id)contextInfo{
    NSLog(@"wan单");
    self.result(@(error == nil));

}
-(BOOL)isImageFile:(NSString *)fileName{
    return [fileName hasSuffix:@".jpg"]||[fileName hasSuffix:@".png"]||[fileName hasSuffix:@".JPEG"]||[fileName hasSuffix:@".JPG"]||[fileName hasSuffix:@".PNG"];
}
@end
