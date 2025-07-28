import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentorme/app/constants/app_colors.dart';
import 'package:mentorme/app/constants/app_strings.dart';
import 'app_error.dart';

class ErrorHandler {
  static AppError handleError(dynamic error) {
    if (error is AppError) {
      return error;
    }

    if (error is SocketException) {
      return const NetworkError(
        message: AppStrings.networkError,
        code: 'NETWORK_ERROR',
      );
    }

    if (error is HttpException) {
      return NetworkError(
        message: error.message,
        code: 'HTTP_ERROR',
        originalError: error,
      );
    }

    if (error is FormatException) {
      return ServerError(
        message: AppStrings.serverError,
        code: 'FORMAT_ERROR',
        originalError: error,
      );
    }

    return UnknownError(
      message: AppStrings.unknownError,
      code: 'UNKNOWN_ERROR',
      originalError: error,
    );
  }

  static AppError handleHttpResponse(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return const ValidationError(
          message: 'Data yang dikirim tidak valid',
          code: 'BAD_REQUEST',
        );
      case 401:
        return const AuthenticationError(
          message: 'Sesi telah berakhir, silakan login kembali',
          code: 'UNAUTHORIZED',
        );
      case 403:
        return const AuthenticationError(
          message: 'Anda tidak memiliki akses',
          code: 'FORBIDDEN',
        );
      case 404:
        return const ServerError(
          message: AppStrings.dataNotFound,
          statusCode: 404,
          code: 'NOT_FOUND',
        );
      case 500:
        return const ServerError(
          message: AppStrings.serverError,
          statusCode: 500,
          code: 'INTERNAL_SERVER_ERROR',
        );
      default:
        return ServerError(
          message: 'Terjadi kesalahan: ${response.statusCode}',
          statusCode: response.statusCode,
          code: 'HTTP_ERROR',
        );
    }
  }

  static String getErrorMessage(AppError error) {
    if (error is NetworkError) {
      return AppStrings.networkError;
    } else if (error is AuthenticationError) {
      return error.message;
    } else if (error is ValidationError) {
      return error.message;
    } else if (error is ServerError) {
      return AppStrings.serverError;
    } else {
      return AppStrings.unknownError;
    }
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: AppColors.textLight,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void showErrorFromAppError(BuildContext context, AppError error) {
    showError(context, getErrorMessage(error));
  }
}
