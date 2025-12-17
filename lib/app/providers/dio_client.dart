/*
 * File name: dio_client.dart
 * Updated: 2025
 * Cache: In-memory (NO Hive)
 * Fully backward compatible with SmarterVision codebase
 */

import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;

import '../../common/custom_trace.dart';
import '../../common/log.dart' as log;
import '../exceptions/network_exceptions.dart';

const _defaultConnectTimeout = Duration(minutes: 1);
const _defaultReceiveTimeout = Duration(minutes: 1);

class DioClient {
  final String baseUrl;

  late final dio.Dio _dio;
  late final dio.Options optionsNetwork;
  late final dio.Options optionsCache;

  final List<dio.Interceptor>? interceptors;
  final RxList<String> _progress = <String>[].obs;

  late final CacheOptions _cacheOptions;

  DioClient(
      this.baseUrl,
      dio.Dio? dioInstance, {
        this.interceptors,
      }) {
    _dio = dioInstance ?? dio.Dio();

    _dio.options
      ..baseUrl = baseUrl
      ..connectTimeout = _defaultConnectTimeout
      ..receiveTimeout = _defaultReceiveTimeout
      ..headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Requested-With': 'XMLHttpRequest',
        'Accept-Language': 'en',
      };

    if (interceptors?.isNotEmpty ?? false) {
      _dio.interceptors.addAll(interceptors!);
    }

    if (kDebugMode) {
      _dio.interceptors.add(log.LogInterceptor());
    }

    _initMemoryCache();

    optionsNetwork = dio.Options(headers: Map.of(_dio.options.headers));
    optionsCache = dio.Options(
      headers: Map.of(_dio.options.headers),
      extra: {'useCache': true},
    );
  }

  void _initMemoryCache() {
    _cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      maxStale: const Duration(minutes: 10),
      hitCacheOnNetworkFailure: true,
    );

    _dio.interceptors.add(DioCacheInterceptor(options: _cacheOptions));
  }

  // --------------------------------------------------
  // GET
  // --------------------------------------------------
  Future<dio.Response> getUri(
      Uri uri, {
        dio.Options? options,
        dio.CancelToken? cancelToken,
        dio.ProgressCallback? onReceiveProgress,
      }) async {
    final trace = CustomTrace(StackTrace.current);
    _startProgress(trace);
    try {
      return await _dio.getUri(
        uri,
        options: _resolveOptions(options),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    } finally {
      _endProgress(trace);
    }
  }

  // --------------------------------------------------
  // POST
  // --------------------------------------------------
  Future<dio.Response> postUri(
      Uri uri, {
        dynamic data,
        dio.Options? options,
        dio.CancelToken? cancelToken,
        dio.ProgressCallback? onSendProgress,
        dio.ProgressCallback? onReceiveProgress,
      }) async {
    final trace = CustomTrace(StackTrace.current);
    _startProgress(trace);
    try {
      return await _dio.postUri(
        uri,
        data: data,
        options: _resolveOptions(options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    } finally {
      _endProgress(trace);
    }
  }

  // --------------------------------------------------
  // PUT
  // --------------------------------------------------
  Future<dio.Response> putUri(
      Uri uri, {
        dynamic data,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) async {
    final trace = CustomTrace(StackTrace.current);
    _startProgress(trace);
    try {
      return await _dio.putUri(
        uri,
        data: data,
        options: _resolveOptions(options),
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    } finally {
      _endProgress(trace);
    }
  }

  // --------------------------------------------------
  // DELETE
  // --------------------------------------------------
  Future<dio.Response> deleteUri(
      Uri uri, {
        dynamic data,
        dio.Options? options,
        dio.CancelToken? cancelToken,
      }) async {
    final trace = CustomTrace(StackTrace.current);
    _startProgress(trace);
    try {
      return await _dio.deleteUri(
        uri,
        data: data,
        options: _resolveOptions(options),
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    } finally {
      _endProgress(trace);
    }
  }

  // --------------------------------------------------
  // HELPERS
  // --------------------------------------------------
  dio.Options _resolveOptions(dio.Options? options) {
    final useCache = options?.extra?['useCache'] ?? true;
    if (!useCache) return options ?? dio.Options();
    return _cacheOptions.toOptions().copyWith(
      headers: options?.headers,
    );
  }

  bool isLoading({String? task, List<String>? tasks}) {
    if (tasks != null) {
      return tasks.any(_progress.contains);
    }
    if (task != null) {
      return _progress.contains(task);
    }
    return _progress.isNotEmpty;
  }

  void _startProgress(CustomTrace trace) {
    _progress.add(_getTaskName(trace));
  }

  void _endProgress(CustomTrace trace) {
    _progress.remove(_getTaskName(trace));
  }

  String _getTaskName(CustomTrace trace) {
    return trace.callerFunctionName?.split('.').last ?? 'unknown';
  }
}
