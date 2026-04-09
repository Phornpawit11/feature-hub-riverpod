// สร้างตัวแปร TextTheme เตรียมไว้ (สามารถแยกไฟล์ไปอยู่โฟลเดอร์ theme ได้)
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

final TextTheme myGlobalTextTheme = TextTheme(
  // ==========================================
  // 1. DISPLAY: ตัวหนังสือขนาดใหญ่พิเศษ
  // เหมาะสำหรับ: หน้า Splash Screen หรือโชว์ตัวเลขสถิติสำคัญ (เช่น จำนวนรถทั้งหมด)
  // ==========================================
  displayLarge: TextStyle(fontSize: 57.sp, fontWeight: FontWeight.bold),
  displayMedium: TextStyle(fontSize: 45.sp, fontWeight: FontWeight.w700),
  displaySmall: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w600),

  // ==========================================
  // 2. HEADLINE: หัวข้อหลักของหน้าจอ
  // เหมาะสำหรับ: ชื่อหน้า (เช่น "แดชบอร์ด", "รายการรถยนต์")
  // ==========================================
  headlineLarge: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
  headlineMedium: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w600),
  headlineSmall: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),

  // ==========================================
  // 3. TITLE: หัวข้อย่อย
  // เหมาะสำหรับ: ข้อความบน AppBar, ทะเบียนรถใน ListView, ชื่อคนขับ
  // ==========================================
  titleLarge: TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  ), // Default ของ AppBar
  titleMedium: TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  ), // Default ของ ListTile title
  titleSmall: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),

  // ==========================================
  // 4. BODY: เนื้อหาทั่วไปที่ใช้อ่าน
  // เหมาะสำหรับ: รายละเอียดสถานะรถ, ข้อความยาวๆ, แจ้งเตือน
  // ==========================================
  bodyLarge: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal),
  bodyMedium: TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.normal,
  ), // Default ของ Text() ทั่วไป
  bodySmall: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal),

  // ==========================================
  // 5. LABEL: ข้อความประกอบ / ปุ่ม / คำอธิบายขนาดเล็ก
  // เหมาะสำหรับ: ข้อความบนปุ่มกด, วันที่และเวลา (Timestamp), สถานะ (Online/Offline)
  // ==========================================
  labelLarge: TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  ), // Default ของปุ่ม (ElevatedButton, TextButton)
  labelMedium: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
  labelSmall: TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  ),
);
