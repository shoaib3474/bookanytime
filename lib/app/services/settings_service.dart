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
    // Barberaa-like palette (adjustable):
    // - mainColor: warm yellow/gold for highlights and selected pill
    // - secondColor: dark navy/charcoal for text/icons
    // - accentColor: slightly transparent variant used for dividers/background tints
    // These defaults only apply when the server doesn't provide values.
    const defaultMain = '#F7C948'; // warm yellow/gold
    const defaultSecond = '#12263A'; // dark navy
    const defaultAccent = '#F7C948';
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
      setting.value.mainDarkColor = defaultMain;
    }
    if (setting.value.secondDarkColor == null ||
        setting.value.secondDarkColor!.isEmpty) {
      setting.value.secondDarkColor = defaultSecond;
    }
    if (setting.value.accentDarkColor == null ||
        setting.value.accentDarkColor!.isEmpty) {
      setting.value.accentDarkColor = defaultAccent;
    }
  }

  /// Force-apply a Barberaa-like palette at runtime and update the app theme.
  /// If [persist] is true the values will be written to local storage so they
  /// survive app restart (this does not update server settings).
  void applyBarberaaPalette({bool persist = false}) {
    const barberaaMain = '#F7C948';
    const barberaaSecond = '#12263A';
    const barberaaAccent = '#F7C948';
    const barberaaScaffold = '#FFFFFF';

    setting.value.mainColor = barberaaMain;
    setting.value.secondColor = barberaaSecond;
    setting.value.accentColor = barberaaAccent;
    setting.value.scaffoldColor = barberaaScaffold;

    setting.value.mainDarkColor = barberaaMain;
    setting.value.secondDarkColor = barberaaSecond;
    setting.value.accentDarkColor = barberaaAccent;

    if (persist) {
      _box.write('setting_main_color', barberaaMain);
      _box.write('setting_second_color', barberaaSecond);
      _box.write('setting_accent_color', barberaaAccent);
      _box.write('setting_scaffold_color', barberaaScaffold);
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
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            elevation: 0, foregroundColor: Colors.white),
        brightness: Brightness.light,
        dividerColor: Ui.parseColor(setting.value.accentColor, opacity: 0.1),
        focusColor: Ui.parseColor(setting.value.accentColor),
        hintColor: Ui.parseColor(setting.value.secondColor),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: Ui.parseColor(setting.value.mainColor)),
        ),
        colorScheme: ColorScheme.light(
          primary: Ui.parseColor(setting.value.mainColor),
          secondary: Ui.parseColor(setting.value.mainColor),
          outline: Ui.parseColor(setting.value.accentColor, opacity: 0.1),
          outlineVariant:
              Ui.parseColor(setting.value.accentColor, opacity: 0.1),
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
                color: Ui.parseColor(setting.value.secondColor),
                height: 1.3),
            headlineMedium: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                color: Ui.parseColor(setting.value.secondColor),
                height: 1.3),
            displaySmall: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Ui.parseColor(setting.value.secondColor),
                height: 1.3),
            displayMedium: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: Ui.parseColor(setting.value.mainColor),
                height: 1.4),
            displayLarge: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w300,
                color: Ui.parseColor(setting.value.secondColor),
                height: 1.4),
            titleSmall: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
                color: Ui.parseColor(setting.value.secondColor),
                height: 1.2),
            titleMedium: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: Ui.parseColor(setting.value.mainColor),
                height: 1.2),
            bodyMedium: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: Ui.parseColor(setting.value.secondColor),
                height: 1.2),
            bodyLarge: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Ui.parseColor(setting.value.secondColor),
                height: 1.2),
            bodySmall: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w300,
                color: Ui.parseColor(setting.value.accentColor),
                height: 1.2),
          ),
        ));
  }

  ThemeData getDarkTheme() {
    // TODO change font dynamically
    return ThemeData(
        primaryColor: const Color(0xFF252525),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(elevation: 0),
        scaffoldBackgroundColor: const Color(0xFF2C2C2C),
        brightness: Brightness.dark,
        dividerColor:
            Ui.parseColor(setting.value.accentDarkColor, opacity: 0.1),
        focusColor: Ui.parseColor(setting.value.accentDarkColor),
        hintColor: Ui.parseColor(setting.value.secondDarkColor),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: Ui.parseColor(setting.value.mainColor)),
        ),
        colorScheme: ColorScheme.dark(
          primary: Ui.parseColor(setting.value.mainDarkColor),
          secondary: Ui.parseColor(setting.value.mainDarkColor),
          outline: Ui.parseColor(setting.value.accentDarkColor, opacity: 0.1),
          outlineVariant:
              Ui.parseColor(setting.value.accentDarkColor, opacity: 0.1),
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
                  color: Ui.parseColor(setting.value.secondDarkColor),
                  height: 1.3),
              headlineMedium: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Ui.parseColor(setting.value.secondDarkColor),
                  height: 1.3),
              displaySmall: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Ui.parseColor(setting.value.secondDarkColor),
                  height: 1.3),
              displayMedium: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  color: Ui.parseColor(setting.value.mainDarkColor),
                  height: 1.4),
              displayLarge: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w300,
                  color: Ui.parseColor(setting.value.secondDarkColor),
                  height: 1.4),
              titleSmall: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: Ui.parseColor(setting.value.secondDarkColor),
                  height: 1.2),
              titleMedium: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  color: Ui.parseColor(setting.value.mainDarkColor),
                  height: 1.2),
              bodyMedium: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: Ui.parseColor(setting.value.secondDarkColor),
                  height: 1.2),
              bodyLarge: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Ui.parseColor(setting.value.secondDarkColor),
                  height: 1.2),
              bodySmall: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300,
                  color: Ui.parseColor(setting.value.accentDarkColor),
                  height: 1.2),
            )));
  }

  ThemeData getWebLightTheme() {
    // TODO change font dynamically
    return ThemeData(
        primaryColor: Colors.white,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            elevation: 0, foregroundColor: Colors.white),
        brightness: Brightness.light,
        dividerColor: Ui.parseColor(setting.value.accentColor, opacity: 0.1),
        focusColor: Ui.parseColor(setting.value.accentColor),
        hintColor: Ui.parseColor(setting.value.secondColor),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: Ui.parseColor(setting.value.mainColor)),
        ),
        colorScheme: ColorScheme.light(
          primary: Ui.parseColor(setting.value.mainColor),
          secondary: Ui.parseColor(setting.value.mainColor),
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
                color: Ui.parseColor(setting.value.secondColor),
                height: 1.3),
            headlineMedium: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
                color: Ui.parseColor(setting.value.secondColor),
                height: 1.3),
            displaySmall: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: Ui.parseColor(setting.value.secondColor),
                height: 1.3),
            displayMedium: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                color: Ui.parseColor(setting.value.mainColor),
                height: 1.4),
            displayLarge: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w300,
                color: Ui.parseColor(setting.value.secondColor),
                height: 1.4),
            titleSmall: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Ui.parseColor(setting.value.secondColor),
                height: 1.2),
            titleMedium: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: Ui.parseColor(setting.value.mainColor),
                height: 1.2),
            bodyMedium: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Ui.parseColor(setting.value.secondColor),
                height: 1.2),
            bodyLarge: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Ui.parseColor(setting.value.secondColor),
                height: 1.2),
            bodySmall: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
                color: Ui.parseColor(setting.value.accentColor),
                height: 1.2),
          ),
        ));
  }

  ThemeData getWebDarkTheme() {
    // TODO change font dynamically
    return ThemeData(
        primaryColor: const Color(0xFF252525),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(elevation: 0),
        scaffoldBackgroundColor: const Color(0xFF2C2C2C),
        brightness: Brightness.dark,
        dividerColor:
            Ui.parseColor(setting.value.accentDarkColor, opacity: 0.1),
        focusColor: Ui.parseColor(setting.value.accentDarkColor),
        hintColor: Ui.parseColor(setting.value.secondDarkColor),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: Ui.parseColor(setting.value.mainColor)),
        ),
        colorScheme: ColorScheme.dark(
          primary: Ui.parseColor(setting.value.mainDarkColor),
          secondary: Ui.parseColor(setting.value.mainDarkColor),
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
                  color: Ui.parseColor(setting.value.secondDarkColor),
                  height: 1.3),
              headlineMedium: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  color: Ui.parseColor(setting.value.secondDarkColor),
                  height: 1.3),
              displaySmall: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  color: Ui.parseColor(setting.value.secondDarkColor),
                  height: 1.3),
              displayMedium: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  color: Ui.parseColor(setting.value.mainDarkColor),
                  height: 1.4),
              displayLarge: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w300,
                  color: Ui.parseColor(setting.value.secondDarkColor),
                  height: 1.4),
              titleSmall: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Ui.parseColor(setting.value.secondDarkColor),
                  height: 1.2),
              titleMedium: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Ui.parseColor(setting.value.mainDarkColor),
                  height: 1.2),
              bodyMedium: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Ui.parseColor(setting.value.secondDarkColor),
                  height: 1.2),
              bodyLarge: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Ui.parseColor(setting.value.secondDarkColor),
                  height: 1.2),
              bodySmall: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                  color: Ui.parseColor(setting.value.accentDarkColor),
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
