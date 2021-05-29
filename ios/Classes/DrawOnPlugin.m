#import "DrawOnPlugin.h"
#if __has_include(<draw_on/draw_on-Swift.h>)
#import <draw_on/draw_on-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "draw_on-Swift.h"
#endif

@implementation DrawOnPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDrawOnPlugin registerWithRegistrar:registrar];
}
@end
