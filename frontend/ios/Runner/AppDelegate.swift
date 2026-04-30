import Flutter
import UIKit
import WidgetKit

private enum CalendarWidgetBridgeContract {
  static let channelName = "todos_riverpod/calendar_widget_bridge"
  static let appGroup = "group.com.dodo.todoapps.calendarwidget"
  static let snapshotKey = "calendar_widget_snapshot_v1"
  static let schemaVersionKey = "calendar_widget_snapshot_schema_version"
  static let updatedAtMillisKey = "calendar_widget_snapshot_updated_at_millis"
}

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: CalendarWidgetBridgeContract.channelName,
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { call, result in
        switch call.method {
        case "saveCalendarWidgetSnapshot":
          guard
            let args = call.arguments as? [String: Any],
            let snapshotJson = args["snapshotJson"] as? String
          else {
            result(
              FlutterError(
                code: "invalid-args",
                message: "Missing calendar widget snapshot payload.",
                details: nil
              )
            )
            return
          }

          let defaults = UserDefaults(suiteName: CalendarWidgetBridgeContract.appGroup)
          defaults?.set(snapshotJson, forKey: CalendarWidgetBridgeContract.snapshotKey)
          let schemaVersion = (args["schemaVersion"] as? NSNumber)?.intValue ?? 1
          let updatedAtMillis =
            (args["updatedAtMillis"] as? NSNumber)?.int64Value
            ?? Int64(Date().timeIntervalSince1970 * 1000)
          defaults?.set(
            schemaVersion,
            forKey: CalendarWidgetBridgeContract.schemaVersionKey
          )
          defaults?.set(
            updatedAtMillis,
            forKey: CalendarWidgetBridgeContract.updatedAtMillisKey
          )

          if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
          }

          result(nil)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
