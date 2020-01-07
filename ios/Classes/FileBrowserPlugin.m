#import "FileBrowserPlugin.h"
#import <file_browser/file_browser-Swift.h>

@implementation FileBrowserPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFileBrowserPlugin registerWithRegistrar:registrar];
}
@end
