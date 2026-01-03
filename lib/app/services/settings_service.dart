import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/ui.dart';
import '../models/address_model.dart';
import '../models/setting_model.dart';
import '../repositories/setting_repository.dart';
import 'auth_service.dart';

class SettingsService extends GetxService {
  final setting = Setting().obs;
  final address = Address().obs;
  late GetStorage _box;

  late SettingRepository _settingsRepo;

  SettingsService() {
    _settingsRepo = SettingRepository();
    _box = GetStorage();
  }

  Future<SettingsService> init() async {
    address.listen((Address _address) {
      _box.write('current_address', _address.toJson());
    });
    setting.value = await _settingsRepo.get();
    setting.value.modules = await _settingsRepo.getModules();
    await getAddress();
    // ensure we have a sensible default color scheme similar to the Barberaa app
    _applyDefaultColorSchemeIfMissing();
    // apply the Barberaa-like palette on startup
    applyBarberaaPalette(persist: false);
    return this;
  }

  void _applyDefaultColorSchemeIfMissing() {
    // Modern vibrant palette:
    // - mainColor: Purple/Magenta (D822F0) for primary actions and highlights
    // - secondColor: Yellow (F2F22A) for secondary accents and text
    // - accentColor: Complementary shade for dividers/backgrounds
    // These defaults only apply when the server doesn't provide values.
    const defaultMain = '#D822F0'; // vibrant purple
    const defaultSecond = '#F2F22A'; // bright yellow
    const defaultAccent = '#D822F0';
    const defaultScaffold = '#FFFFFF';

    if (setting.value.mainColor == null || setting.value.mainColor!.isEmpty) {
      setting.value.mainColor = defaultMain;
    }
    if (setting.value.secondColor == null ||
        setting.value.secondColor!.isEmpty) {
      setting.value.secondColor = defaultSecond;
    }
    if (setting.value.accentColor == null ||
        setting.value.accentColor!.isEmpty) {
      setting.value.accentColor = defaultAccent;
    }
    if (setting.value.scaffoldColor == null ||
        setting.value.scaffoldColor!.isEmpty) {
      setting.value.scaffoldColor = defaultScaffold;
    }
    // dark theme fallbacks
    if (setting.value.mainDarkColor == null ||
        setting.value.mainDarkColor!.isEmpty) {
      setting.value.mainDarkColor = '#C017D1'; // darker purple for dark theme
    }
    if (setting.value.secondDarkColor == null ||
        setting.value.secondDarkColor!.isEmpty) {
      setting.value.secondDarkColor = '#FFD600'; // darker yellow for dark theme
    }
    if (setting.value.accentDarkColor == null ||
        setting.value.accentDarkColor!.isEmpty) {
      setting.value.accentDarkColor = '#C017D1';
    }
  }

  /// Force-apply a modern vibrant palette at runtime and update the app theme.
  /// If [persist] is true the values will be written to local storage so they
  /// survive app restart (this does not update server settings).
  void applyBarberaaPalette({bool persist = false}) {
    const modernMain = '#D822F0'; // vibrant purple
    const modernSecond = '#F2F22A'; // bright yellow
    const modernAccent = '#D822F0';
    const modernScaffold = '#FFFFFF';
    const modernMainDark = '#C017D1'; // darker purple for dark theme
    const modernSecondDark = '#FFD600'; // darker yellow for dark theme

    setting.value.mainColor = modernMain;
    setting.value.secondColor = modernSecond;
    setting.value.accentColor = modernAccent;
    setting.value.scaffoldColor = modernScaffold;

    setting.value.mainDarkColor = modernMainDark;
    setting.value.secondDarkColor = modernSecondDark;
    setting.value.accentDarkColor = modernMainDark;

    if (persist) {
      _box.write('setting_main_color', modernMain);
      _box.write('setting_second_color', modernSecond);
      _box.write('setting_accent_color', modernAccent);
      _box.write('setting_scaffold_color', modernScaffold);
      _box.write('setting_main_dark_color', modernMainDark);
      _box.write('setting_second_dark_color', modernSecondDark);
      _box.write('setting_accent_dark_color', modernMainDark);
    }

    // Ask GetX to update the app theme immediately
    try {
      Get.changeTheme(getLightTheme());
      Get.changeThemeMode(getThemeMode());
    } catch (e) {
      // ignore if called before GetMaterialApp is ready
    }
  }

  ThemeData getLightTheme() {
    // TODO change font dynamically
    return ThemeData(
        primaryColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: 0,
            foregroundColor: Colors.white,
            backgroundColor: Ui.parseColor(setting.value.mainColor)),
        brightness: Brightness.light,
        dividerColor: Ui.parseColor(setting.value.accentColor, opacity: 0.08),
        focusColor: Ui.parseColor(setting.value.accentColor, opacity: 0.1),
        hintColor: const Color(0xFF9E9E9E),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: Ui.parseColor(setting.value.mainColor)),
        ),
        colorScheme: ColorScheme.light(
          primary: Ui.parseColor(setting.value.mainColor),
          secondary: Ui.parseColor(setting.value.secondColor),
          tertiary: const Color(0xFF6C63FF),
          outline: Ui.parseColor(setting.value.accentColor, opacity: 0.1),
          outlineVariant:
              Ui.parseColor(setting.value.accentColor, opacity: 0.08),
          surface: Colors.white,
          surfaceVariant: const Color(0xFFF5F5F5),
        ),
        textTheme: GoogleFonts.getTextTheme(
          _getLocale().startsWith('ar') ? 'Cairo' : 'Poppins',
          TextTheme(
            titleLarge: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
                color: Ui.parseColor(setting.value.mainColor),
                height: 1.3),
            headlineSmall: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2C2C2C),
                height: 1.3),
            headlineMedium: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
                height: 1.3),
            displaySmall: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
                height: 1.3),
            displayMedium: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: Ui.parseColor(setting.value.mainColor),
                height: 1.4),
            displayLarge: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
                height: 1.4),
            titleSmall: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF424242),
                height: 1.2),
            titleMedium: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: Ui.parseColor(setting.value.mainColor),
                height: 1.2),
            bodyMedium: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF424242),
                height: 1.2),
            bodyLarge: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF616161),
                height: 1.2),
            bodySmall: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF9E9E9E),
                height: 1.2),
          ),
        ));
  }

  ThemeData getDarkTheme() {
    // TODO change font dynamically
    return ThemeData(
        primaryColor: const Color(0xFF1A1A1A),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: 0,
            backgroundColor: Ui.parseColor(setting.value.mainDarkColor),
            foregroundColor: Colors.white),
        scaffoldBackgroundColor: const Color(0xFF121212),
        brightness: Brightness.dark,
        dividerColor:
            Ui.parseColor(setting.value.accentDarkColor, opacity: 0.08),
        focusColor: Ui.parseColor(setting.value.accentDarkColor, opacity: 0.1),
        hintColor: const Color(0xFF9E9E9E),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: Ui.parseColor(setting.value.mainDarkColor)),
        ),
        colorScheme: ColorScheme.dark(
          primary: Ui.parseColor(setting.value.mainDarkColor),
          secondary: Ui.parseColor(setting.value.secondDarkColor),
          tertiary: const Color(0xFF8B5CF6),
          outline: Ui.parseColor(setting.value.accentDarkColor, opacity: 0.1),
          outlineVariant:
              Ui.parseColor(setting.value.accentDarkColor, opacity: 0.08),
          surface: const Color(0xFF1E1E1E),
          surfaceVariant: const Color(0xFF2C2C2C),
        ),
        textTheme: GoogleFonts.getTextTheme(
            _getLocale().startsWith('ar') ? 'Cairo' : 'Poppins',
            TextTheme(
              titleLarge: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                  color: Ui.parseColor(setting.value.mainDarkColor),
                  height: 1.3),
              headlineSmall: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFF5F5F5),
                  height: 1.3),
              headlineMedium: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFFFFFF),
                  height: 1.3),
              displaySmall: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFFFFFF),
                  height: 1.3),
              displayMedium: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  color: Ui.parseColor(setting.value.mainDarkColor),
                  height: 1.4),
              displayLarge: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFFFFFF),
                  height: 1.4),
              titleSmall: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFBDBDBD),
                  height: 1.2),
              titleMedium: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: Ui.parseColor(setting.value.mainDarkColor),
                  height: 1.2),
              bodyMedium: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFBDBDBD),
                  height: 1.2),
              bodyLarge: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9E9E9E),
                  height: 1.2),
              bodySmall: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF757575),
                  height: 1.2),
            )));
  }

  ThemeData getWebLightTheme() {
    // TODO change font dynamically
    return ThemeData(
        primaryColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: 0,
            foregroundColor: Colors.white,
            backgroundColor: Ui.parseColor(setting.value.mainColor)),
        brightness: Brightness.light,
        dividerColor: Ui.parseColor(setting.value.accentColor, opacity: 0.08),
        focusColor: Ui.parseColor(setting.value.accentColor, opacity: 0.1),
        hintColor: const Color(0xFF9E9E9E),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: Ui.parseColor(setting.value.mainColor)),
        ),
        colorScheme: ColorScheme.light(
          primary: Ui.parseColor(setting.value.mainColor),
          secondary: Ui.parseColor(setting.value.secondColor),
        ),
        textTheme: GoogleFonts.getTextTheme(
          _getLocale().toString().startsWith('ar') ? 'Cairo' : 'Poppins',
          TextTheme(
            titleLarge: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Ui.parseColor(setting.value.mainColor),
                height: 1.3),
            headlineSmall: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2C2C2C),
                height: 1.3),
            headlineMedium: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
                height: 1.3),
            displaySmall: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
                height: 1.3),
            displayMedium: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                color: Ui.parseColor(setting.value.mainColor),
                height: 1.4),
            displayLarge: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
                height: 1.4),
            titleSmall: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF424242),
                height: 1.2),
            titleMedium: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Ui.parseColor(setting.value.mainColor),
                height: 1.2),
            bodyMedium: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF424242),
                height: 1.2),
            bodyLarge: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF616161),
                height: 1.2),
            bodySmall: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF9E9E9E),
                height: 1.2),
          ),
        ));
  }

  ThemeData getWebDarkTheme() {
    // TODO change font dynamically
    return ThemeData(
        primaryColor: const Color(0xFF1A1A1A),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: 0,
            backgroundColor: Ui.parseColor(setting.value.mainDarkColor),
            foregroundColor: Colors.white),
        scaffoldBackgroundColor: const Color(0xFF121212),
        brightness: Brightness.dark,
        dividerColor:
            Ui.parseColor(setting.value.accentDarkColor, opacity: 0.08),
        focusColor: Ui.parseColor(setting.value.accentDarkColor, opacity: 0.1),
        hintColor: const Color(0xFF9E9E9E),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: Ui.parseColor(setting.value.mainDarkColor)),
        ),
        colorScheme: ColorScheme.dark(
          primary: Ui.parseColor(setting.value.mainDarkColor),
          secondary: Ui.parseColor(setting.value.secondDarkColor),
        ),
        textTheme: GoogleFonts.getTextTheme(
            _getLocale().toString().startsWith('ar') ? 'Cairo' : 'Poppins',
            TextTheme(
              titleLarge: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: Ui.parseColor(setting.value.mainDarkColor),
                  height: 1.3),
              headlineSmall: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFF5F5F5),
                  height: 1.3),
              headlineMedium: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFFFFFF),
                  height: 1.3),
              displaySmall: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFFFFFF),
                  height: 1.3),
              displayMedium: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  color: Ui.parseColor(setting.value.mainDarkColor),
                  height: 1.4),
              displayLarge: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFFFFFF),
                  height: 1.4),
              titleSmall: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFBDBDBD),
                  height: 1.2),
              titleMedium: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Ui.parseColor(setting.value.mainDarkColor),
                  height: 1.2),
              bodyMedium: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFBDBDBD),
                  height: 1.2),
              bodyLarge: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9E9E9E),
                  height: 1.2),
              bodySmall: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF757575),
                  height: 1.2),
            )));
  }

  String _getLocale() {
    String _locale = GetStorage().read<String>('language') ?? '';
    if (_locale.isEmpty) {
      _locale = setting.value.mobileLanguage ?? 'en';
    }
    return _locale;
  }

  ThemeMode getThemeMode() {
    String? _themeMode = GetStorage().read<String>('theme_mode');
    switch (_themeMode) {
      case 'ThemeMode.light':
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.light
              .copyWith(systemNavigationBarColor: Colors.white),
        );
        return ThemeMode.light;
      case 'ThemeMode.dark':
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.dark
              .copyWith(systemNavigationBarColor: Colors.black87),
        );
        return ThemeMode.dark;
      case 'ThemeMode.system':
        return ThemeMode.system;
      default:
        if (setting.value.defaultTheme == "dark") {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark
                .copyWith(systemNavigationBarColor: Colors.black87),
          );
          return ThemeMode.dark;
        } else {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light
                .copyWith(systemNavigationBarColor: Colors.white),
          );
          return ThemeMode.light;
        }
    }
  }

  Future getAddress() async {
    try {
      if (_box.hasData('current_address') && !address.value.isUnknown()) {
        address.value = Address.fromJson(await _box.read('current_address'));
      } else if (Get.find<AuthService>().isAuth) {
        List<Address> _addresses = await _settingsRepo.getAddresses();
        if (_addresses.isNotEmpty) {
          address.value = _addresses
              .firstWhere((_address) => _address.isDefault, orElse: () {
            return _addresses.first;
          });
        }
      }
    } catch (e) {
      Get.log(e.toString());
    }
  }

  bool isModuleActivated(String moduleName) {
    return setting.value.modules?.contains(moduleName) ?? false;
  }
}
