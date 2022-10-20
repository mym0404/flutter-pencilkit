#import "PencilKitPlugin.h"
#if __has_include(<pencil_kit/pencil_kit-Swift.h>)
#import <pencil_kit/pencil_kit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "pencil_kit-Swift.h"
#endif

@implementation PencilKitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPencilKitPlugin registerWithRegistrar:registrar];
}
@end
