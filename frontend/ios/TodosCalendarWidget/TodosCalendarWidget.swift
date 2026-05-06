import SwiftUI
import UIKit
import WidgetKit

private enum CalendarWidgetBridgeContract {
  static let appGroup = "group.com.dodo.todoapps.calendarwidget"
  static let snapshotKey = "calendar_widget_snapshot_v1"
}

private struct CalendarDaySnapshot: Codable, Identifiable {
  let date: String
  let isToday: Bool
  let isCurrentMonth: Bool
  let tagColor: String?
  let tagLabel: String?
  let tagLabelShort: String?
  let todoDotColors: [String]
  let deepLinkTarget: String

  var id: String { date }
}

private struct CalendarWidgetSnapshotPayload: Codable {
  let schemaVersion: Int
  let year: Int
  let month: Int
  let selectedDate: String
  let defaultDeepLinkTarget: String
  let days: [CalendarDaySnapshot]
}

private struct CalendarWidgetEntry: TimelineEntry {
  let date: Date
  let snapshot: CalendarWidgetSnapshotPayload
}

private struct CalendarWidgetProvider: TimelineProvider {
  func placeholder(in context: Context) -> CalendarWidgetEntry {
    CalendarWidgetEntry(date: Date(), snapshot: .placeholder)
  }

  func getSnapshot(in context: Context, completion: @escaping (CalendarWidgetEntry) -> Void) {
    completion(CalendarWidgetEntry(date: Date(), snapshot: loadSnapshot()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarWidgetEntry>) -> Void) {
    let entry = CalendarWidgetEntry(date: Date(), snapshot: loadSnapshot())
    let nextRefresh = Calendar.current.nextDate(
      after: Date(),
      matching: DateComponents(hour: 0, minute: 5),
      matchingPolicy: .nextTime
    ) ?? Date().addingTimeInterval(6 * 60 * 60)

    completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
  }

  private func loadSnapshot() -> CalendarWidgetSnapshotPayload {
    guard
      let defaults = UserDefaults(suiteName: CalendarWidgetBridgeContract.appGroup),
      let json = defaults.string(forKey: CalendarWidgetBridgeContract.snapshotKey),
      let data = json.data(using: .utf8),
      let snapshot = try? JSONDecoder().decode(CalendarWidgetSnapshotPayload.self, from: data)
    else {
      return .placeholder
    }

    return snapshot
  }
}

private struct TodosCalendarWidgetEntryView: View {
  @Environment(\.widgetFamily) private var widgetFamily

  var entry: CalendarWidgetProvider.Entry

  private var columns: [GridItem] {
    Array(repeating: GridItem(.flexible(), spacing: gridSpacing), count: 7)
  }

  private let weekdayLabels = ["M", "T", "W", "T", "F", "S", "S"]
  private let cardBackground = Color(red: 0.95, green: 0.96, blue: 0.98)

  var body: some View {
    VStack(alignment: .leading, spacing: verticalSpacing) {
      HStack(alignment: .firstTextBaseline) {
        Text(monthTitle)
          .font(.system(size: titleFontSize, weight: .semibold, design: .rounded))
          .foregroundStyle(Color(red: 0.14, green: 0.18, blue: 0.25))

        Spacer()

        Text("Month glance")
          .font(.system(size: subtitleFontSize, weight: .medium, design: .rounded))
          .foregroundStyle(Color(red: 0.42, green: 0.48, blue: 0.57))
      }

      HStack(spacing: weekdaySpacing) {
        ForEach(weekdayLabels, id: \.self) { label in
          Text(label)
            .font(.system(size: weekdayFontSize, weight: .semibold, design: .rounded))
            .foregroundStyle(Color(red: 0.50, green: 0.56, blue: 0.64))
            .frame(maxWidth: .infinity)
        }
      }

      LazyVGrid(columns: columns, spacing: gridSpacing) {
        ForEach(entry.snapshot.days) { day in
          if let url = URL(string: day.deepLinkTarget) {
            Link(destination: url) {
              CalendarDayCell(
                day: day,
                isSelected: day.date == entry.snapshot.selectedDate,
                isLarge: isLargeFamily
              )
            }
            .buttonStyle(.plain)
          } else {
            CalendarDayCell(
              day: day,
              isSelected: day.date == entry.snapshot.selectedDate,
              isLarge: isLargeFamily
            )
          }
        }
      }
    }
    .padding(containerPadding)
    .widgetCardBackground(cardBackground)
    .widgetURL(URL(string: entry.snapshot.defaultDeepLinkTarget))
  }

  private var monthTitle: String {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.dateFormat = "LLLL yyyy"
    return formatter.string(from: DateComponents(
      calendar: Calendar.current,
      year: entry.snapshot.year,
      month: entry.snapshot.month,
      day: 1
    ).date ?? Date())
  }

  private var isLargeFamily: Bool {
    widgetFamily == .systemLarge
  }

  private var containerPadding: CGFloat {
    isLargeFamily ? 20 : 16
  }

  private var verticalSpacing: CGFloat {
    isLargeFamily ? 12 : 10
  }

  private var weekdaySpacing: CGFloat {
    isLargeFamily ? 8 : 6
  }

  private var gridSpacing: CGFloat {
    isLargeFamily ? 8 : 6
  }

  private var titleFontSize: CGFloat {
    isLargeFamily ? 20 : 18
  }

  private var subtitleFontSize: CGFloat {
    isLargeFamily ? 12 : 11
  }

  private var weekdayFontSize: CGFloat {
    isLargeFamily ? 11 : 10
  }
}

private extension View {
  @ViewBuilder
  func widgetCardBackground(_ color: Color) -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      containerBackground(for: .widget) {
        color
      }
    } else {
      background(color)
    }
  }
}

private struct CalendarDayCell: View {
  let day: CalendarDaySnapshot
  let isSelected: Bool
  let isLarge: Bool

  var body: some View {
    let accent = color(from: day.tagColor) ?? Color(red: 0.28, green: 0.52, blue: 0.88)
    let selectedFill = accent.opacity(isSelected ? 0.22 : 0.12)
    let borderColor = day.isToday ? accent.opacity(0.65) : accent.opacity(day.tagColor == nil ? 0.12 : 0.26)
    let mutedText = Color(red: 0.62, green: 0.67, blue: 0.73)
    let primaryText = day.isCurrentMonth ? Color(red: 0.16, green: 0.20, blue: 0.27) : mutedText
    let tagForeground = accentTextColor(for: accent)

    VStack(alignment: .leading, spacing: 4) {
      if let tagLabel = resolvedTagLabel {
        HStack(alignment: .top, spacing: 4) {
          HStack(spacing: tagChipDotSpacing) {
            Circle()
              .fill(accent)
              .frame(width: tagChipDotSize, height: tagChipDotSize)

            Text(tagLabel)
              .font(.system(size: tagChipFontSize, weight: .semibold, design: .rounded))
              .foregroundStyle(tagForeground)
              .lineLimit(1)
              .truncationMode(.tail)
          }
          .padding(.horizontal, tagChipHorizontalPadding)
          .padding(.vertical, tagChipVerticalPadding)
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(
            Capsule(style: .continuous)
              .fill(accent.opacity(0.18))
          )

          Text(dayNumber)
            .font(.system(size: dayFontSize, weight: day.isToday ? .bold : .semibold, design: .rounded))
            .foregroundStyle(primaryText)
            .lineLimit(1)
        }
      } else {
        Text(dayNumber)
          .font(.system(size: dayFontSize, weight: day.isToday ? .bold : .semibold, design: .rounded))
          .foregroundStyle(primaryText)
          .lineLimit(1)
      }

      Spacer(minLength: 0)

      HStack(spacing: dotSpacing) {
        ForEach(Array(day.todoDotColors.prefix(3).enumerated()), id: \.offset) { _, colorHex in
          Circle()
            .fill(color(from: colorHex) ?? accent)
            .frame(width: dotSize, height: dotSize)
        }

        Spacer(minLength: 0)
      }
    }
    .padding(.horizontal, cellHorizontalPadding)
    .padding(.vertical, cellVerticalPadding)
    .frame(maxWidth: .infinity, minHeight: cellMinHeight, alignment: .topLeading)
    .background(
      RoundedRectangle(cornerRadius: cellCornerRadius, style: .continuous)
        .fill(selectedFill)
    )
    .overlay(
      RoundedRectangle(cornerRadius: cellCornerRadius, style: .continuous)
        .stroke(borderColor, lineWidth: day.isToday || day.tagColor != nil ? 1 : 0.7)
    )
    .opacity(day.isCurrentMonth ? 1 : 0.58)
  }

  private var dayNumber: String {
    let rawValue = day.date.split(separator: "-").last.flatMap { Int($0) } ?? 0
    return String(rawValue)
  }

  private func color(from hex: String?) -> Color? {
    guard let hex else {
      return nil
    }

    let sanitized = hex.replacingOccurrences(of: "#", with: "")
    guard sanitized.count == 8, let value = UInt64(sanitized, radix: 16) else {
      return nil
    }

    let alpha = Double((value & 0xFF00_0000) >> 24) / 255
    let red = Double((value & 0x00FF_0000) >> 16) / 255
    let green = Double((value & 0x0000_FF00) >> 8) / 255
    let blue = Double(value & 0x0000_00FF) / 255

    return Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
  }

  private func accentTextColor(for color: Color) -> Color {
    guard let uiColor = UIColor(color).cgColor.components else {
      return Color.black.opacity(0.78)
    }

    let red = uiColor.count > 0 ? uiColor[0] : 0
    let green = uiColor.count > 1 ? uiColor[1] : red
    let blue = uiColor.count > 2 ? uiColor[2] : red
    let luminance = (0.299 * red) + (0.587 * green) + (0.114 * blue)
    return luminance > 0.7 ? Color.black.opacity(0.78) : Color.white.opacity(0.94)
  }

  private var resolvedTagLabel: String? {
    let fullLabel = day.tagLabel?.trimmingCharacters(in: .whitespacesAndNewlines)
    if let fullLabel, !fullLabel.isEmpty {
      return fullLabel
    }

    let shortLabel = day.tagLabelShort?.trimmingCharacters(in: .whitespacesAndNewlines)
    if let shortLabel, !shortLabel.isEmpty {
      return shortLabel
    }

    return nil
  }

  private var dayFontSize: CGFloat {
    isLarge ? 14 : 12
  }

  private var dotSize: CGFloat {
    isLarge ? 5.5 : 4.5
  }

  private var dotSpacing: CGFloat {
    isLarge ? 4 : 3
  }

  private var cellHorizontalPadding: CGFloat {
    isLarge ? 8 : 6
  }

  private var cellVerticalPadding: CGFloat {
    isLarge ? 8 : 6
  }

  private var cellMinHeight: CGFloat {
    isLarge ? 44 : 32
  }

  private var cellCornerRadius: CGFloat {
    isLarge ? 14 : 12
  }

  private var tagChipFontSize: CGFloat {
    isLarge ? 10 : 9
  }

  private var tagChipDotSize: CGFloat {
    isLarge ? 6 : 5
  }

  private var tagChipDotSpacing: CGFloat {
    isLarge ? 5 : 4
  }

  private var tagChipHorizontalPadding: CGFloat {
    isLarge ? 8 : 7
  }

  private var tagChipVerticalPadding: CGFloat {
    isLarge ? 4 : 3
  }
}

private extension CalendarWidgetSnapshotPayload {
  static var placeholder: CalendarWidgetSnapshotPayload {
    let now = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    let year = now.year ?? 2026
    let month = now.month ?? 1
    let dates = buildMonthGridDates(year: year, month: month)

    return CalendarWidgetSnapshotPayload(
      schemaVersion: 1,
      year: year,
      month: month,
      selectedDate: formatDate(year: year, month: month, day: now.day ?? 1),
      defaultDeepLinkTarget: "featurehub:///todo",
	      days: dates.map { date in
	        let dayValue = date.day ?? 1
	        let monthValue = date.month ?? month
	        let yearValue = date.year ?? year
	
	        return CalendarDaySnapshot(
	          date: formatDate(year: yearValue, month: monthValue, day: dayValue),
          isToday: dayValue == (now.day ?? 1) && monthValue == month && yearValue == year,
          isCurrentMonth: monthValue == month && yearValue == year,
          tagColor: nil,
          tagLabel: nil,
          tagLabelShort: nil,
          todoDotColors: [],
          deepLinkTarget: "featurehub:///todo?focusedMonth=\(formatDate(year: year, month: month, day: 1))&selectedDate=\(formatDate(year: yearValue, month: monthValue, day: dayValue))"
        )
      }
    )
  }

  static func buildMonthGridDates(year: Int, month: Int) -> [DateComponents] {
    let calendar = Calendar(identifier: .gregorian)
    let firstDay = calendar.date(from: DateComponents(year: year, month: month, day: 1)) ?? Date()
    let leadingDays = calendar.component(.weekday, from: firstDay) - 2
    let normalizedLeadingDays = leadingDays >= 0 ? leadingDays : 6
    let startDate = calendar.date(byAdding: .day, value: -normalizedLeadingDays, to: firstDay) ?? firstDay
    let range = calendar.range(of: .day, in: .month, for: firstDay) ?? 1..<32
    let totalSlots = Int(ceil(Double(normalizedLeadingDays + range.count) / 7.0)) * 7

    return (0..<totalSlots).compactMap { offset in
      let date = calendar.date(byAdding: .day, value: offset, to: startDate) ?? startDate
      return calendar.dateComponents([.year, .month, .day], from: date)
    }
  }

  static func formatDate(year: Int, month: Int, day: Int) -> String {
    let yearString = String(format: "%04d", year)
    let monthString = String(format: "%02d", month)
    let dayString = String(format: "%02d", day)
    return "\(yearString)-\(monthString)-\(dayString)"
  }
}

struct TodosCalendarWidget: Widget {
  let kind: String = "TodosCalendarWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: CalendarWidgetProvider()) { entry in
      TodosCalendarWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Todo Calendar")
    .description("See your month at a glance with tags and todo dots.")
    .supportedFamilies([.systemMedium, .systemLarge])
  }
}

@main
struct TodosCalendarWidgetBundle: WidgetBundle {
  var body: some Widget {
    TodosCalendarWidget()
  }
}
