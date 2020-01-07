import Flutter
import UIKit

public class SwiftFileBrowserPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "file_browser", binaryMessenger: registrar.messenger())
    let instance = SwiftFileBrowserPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

    let delegate = SwiftFlutterDocumentPickerDelegate()


public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
    case "pickDocument":
        let params = parseArgs(call, result: result)

        delegate.pickDocument(params, result: result)
    default:
        result(FlutterMethodNotImplemented)
    }
}

private func parseArgs(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> FileBrowserPickerParams? {
    guard let args = call.arguments as? [String: Any?] else {
        return nil
    }

    return FileBrowserPickerParams(
            allowedUtiTypes:args[FileBrowserPickerParams.ALLOWED_UTI_TYPES]  as? [String],
            allowedFileExtensions: args[FileBrowserPickerParams.ALLOWED_FILE_EXTENSIONS]  as? [String],
        invalidFileNameSymbols:           args[FileBrowserPickerParams.INVALID_FILENAME_SYMBOLS]  as? [String]
    )
}
}

struct FileBrowserPickerParams {
       static let ALLOWED_UTI_TYPES = "allowedUtiTypes"
       static let ALLOWED_FILE_EXTENSIONS = "allowedFileExtensions"
       static let INVALID_FILENAME_SYMBOLS = "invalidFileNameSymbols"
       let allowedUtiTypes: [String]?
       let allowedFileExtensions: [String]?
       let invalidFileNameSymbols: [String]?
}
