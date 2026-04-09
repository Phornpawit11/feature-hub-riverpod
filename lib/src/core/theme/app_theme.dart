import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todos_riverpod/src/core/theme/global_text_theme.dart';

/// ชั้นข้อมูล (`Class`) [AppTheme]
/// ใช้สำหรับจัดการและกำหนดค่า **Theme** (รูปแบบหน้าตา) หลักของแอปพลิเคชัน
/// ทั้งในโหมดสว่าง (Light Mode) และโหมดมืด (Dark Mode)
///
/// คลาสนี้มีหน้าที่รับผิดชอบในการรวมการตั้งค่า **สี (Colors)**, **ตัวอักษร (Typography)**,
/// และ **รูปร่างขององค์ประกอบต่างๆ (Component Shapes)** โดยใช้แพ็กเกจ `flex_color_scheme`
/// เพื่อให้ UI ของแอปมีความสม่ำเสมอ เป็นระบบ และโค้ดอ่านง่าย
///
/// **เหตุผลทางธุรกิจ (Business Logic / The "Why"):**
/// - การใช้ `flex_color_scheme` ช่วยลดความซับซ้อนในการจัดการสีและสร้าง ColorScheme ที่สอดคล้องกันตามหลัก Material Design
/// - กำหนดฟอนต์ `Kanit` เป็นค่าเริ่มต้น เพื่อรองรับภาษาไทยให้แสดงผลได้อย่างสวยงามและอ่านง่าย
/// - มีการใช้พื้นหลังแบบนุ่มนวล `Color(0xFFF6F8FB)` ใน Light Mode เพื่อลดอาการล้าของสายตาผู้ใช้
/// - มีการตั้งค่า `interactionEffects` และ `tintedDisabledControls` เพื่อให้ผู้ใช้รับรู้สถานะการทำงานของปุ่มได้อย่างชัดเจน (UX Improvement)
///
/// **ตัวอย่างการนำไปใช้งาน:**
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
/// ```
abstract final class AppTheme {
  /// เก็บค่า [ThemeData] สำหรับ **โหมดสว่าง (Light Mode)**
  ///
  /// ตัวแปรนี้ทำหน้าที่ตั้งค่าสี พื้นหลัง ฟอนต์ และรูปทรงย่อยของ Material Components ต่างๆ
  /// สำหรับใช้งานในสภาวะที่มีแสงสว่างปกติ
  ///
  /// **รายละเอียดที่สำคัญ (The "Why"):**
  /// - `scheme`: ใช้ตระกูลสี [FlexScheme.flutterDash] เป็นแกนหลัก เพื่อให้เข้ากับแบรนด์ของโปรเจกต์
  /// - `defaultRadius`: ตั้งค่าเป็น `16.0` เพื่อให้ปุ่ม กรอบข้อความ และการ์ดต่างๆ มีขอบโค้งมน ดูทันสมัย เป็นมิตรกับผู้ใช้ (Modern UI/UX)
  /// - `blendOnColors`: เปิดใช้งานเพื่อให้สีพื้นฐาน (เช่น Surface) ผสมกับสีหลักเล็กน้อย สร้างความกลมกลืนในหน้าจอ
  /// - `keyColors`: ใช้ `keepPrimary` และ `keepPrimaryContainer` เพื่อป้องกันไม่ให้กลไกการคำนวณสีอัตโนมัติไปปรับเปลี่ยนรหัสสีหลักที่เราต้องการล็อกไว้ตายตัว
  static ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.flutterDash,
    textTheme: myGlobalTextTheme,
    fontFamily: 'Kanit',
    scaffoldBackground: const Color(0xFFF6F8FB),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      blendOnColors: true,
      defaultRadius: 16.0,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    keyColors: const FlexKeyColors(
      keepPrimary: true,
      keepPrimaryContainer: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  /// เก็บค่า [ThemeData] สำหรับ **โหมดมืด (Dark Mode)**
  ///
  /// ตัวแปรนี้ทำหน้าที่สลับโทนสีของแอปให้อยู่ในโทนเข้ม เพื่อช่วยถนอมสายตาเวลาใช้งานในที่มืด
  /// และยังมีส่วนช่วยประหยัดแบตเตอรี่ในหน้าจอสมาร์ทโฟนบางประเภท (เช่น หน้าจอ OLED)
  ///
  /// **รายละเอียดที่สำคัญ (The "Why"):**
  /// - `blendLevel`: ตั้งค่าเป็น `20` เพื่อให้สีพื้นหลังสีเทาดำดึงสีหลัก (Primary Color) เข้ามาผสมเล็กน้อย ช่วยให้สีไม่ดำสนิทจนเกินไป (หลีกเลี่ยง Contrast ที่รุนแรงจนปวดตา)
  /// - `defaultRadius`: ตั้งค่าเป็น `20.0` (มีความโค้งมนกว้างกว่าแสงสว่างเล็กน้อย) เพื่อปรับสมดุลมวลสีเข้มเมื่อสะท้อนกับการ์ดหรือหน้าต่างแจ้งเตือน
  /// - ใช้ [myGlobalTextTheme] เช่นเดียวกับโหมดสว่าง แต่ค่าความสว่างของตัวอักษรจะถูกสลับให้เกิดเป็นสีสว่างอัตโนมัติตามกลไกของแพ็กเกจ FlexColorScheme
  static ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.flutterDash,
    blendLevel: 20,
    fontFamily: 'Kanit',
    textTheme: myGlobalTextTheme,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 20.0,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    keyColors: const FlexKeyColors(),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
