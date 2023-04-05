import 'dart:convert';
import 'package:api_learn/controllers/book_controller.dart';
import 'package:api_learn/controllers/chapter_controller.dart';
import 'package:api_learn/models/book_model.dart';
import 'package:api_learn/models/chapterModel.dart';
import 'package:api_learn/models/hadis_model.dart';
import 'package:api_learn/utils/global/global.dart';
import 'package:api_learn/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

enum HttpMethod { get, post, put, patch, del, multipartFilePost }

class ServiceAPI {
  static const String baseUrl = 'https://www.hadithapi.com/api/';
  static const String apiKey =
      'apiKey=\$2y\$10\$aI4luo34DOS8n00dXJsMYufypqqAYIj1viEhIYPYZfsvnYrXvdwy';

  /// Multiple data add on multiple fields
  /// [allInfoField] defile as
  /// allInfoField =
  ///   {
  ///     "name": "name",
  ///     "age": 20,
  ///   };
  ///
  /// Single Image Add in request
  /// Multiple Image file add on multiple fields
  /// [imageListWithKeyValue] defile as
  /// imageListWithKeyValue = [
  ///   {
  ///     "key": "product_image",
  ///     "value": "../../../product_image.png",
  ///   },
  ///   {
  ///     "key": "product_image2",
  ///     "value": "../../../product_image2.png",
  ///   }
  /// ];
  ///
  /// Multiple Image file add on sigle field
  /// [multipleImageListWithKeyValue] defile as
  /// multipleImageListWithKeyValue = [
  ///   {
  ///     "key": "product_image",
  ///     "value":[
  ///         "../../../product_image11.png",
  ///         "../../../product_image12.png",
  ///         "../../../product_image13.png",
  ///         "../../../product_image14.png",
  ///       ],
  ///   },
  ///   {
  ///     "key": "product_image2",
  ///     "value": [
  ///         "../../../product_image21.png",
  ///         "../../../product_image22.png",
  ///         "../../../product_image23.png",
  ///         "../../../product_image24.png",
  ///       ],
  ///   }
  /// ];
  static Future<dynamic> genericCall({
    required String url,
    required HttpMethod httpMethod,
    Map<String, String>? headers,
    Map<String, String>? allInfoField,
    List<Map<String, dynamic>>? imageListWithKeyValue,
    List<Map<String, dynamic>>? multipleImageListWithKeyValue,
    Object? body,
    Encoding? encoding,
    bool noNeedAuthToken = true,
    bool isLoadingEnable = false,
    bool isErrorHandleButtonExists = false,
    String? errorButtonLabel,
    Function()? errorButtonPressed,
  }) async {
    try {
      final urlL = Uri.parse(url);
      dynamic response;
      if (httpMethod == HttpMethod.multipartFilePost) {
        var request = http.MultipartRequest("POST", urlL);
        request.headers.addAll(noNeedAuthToken
            ? headers ?? {}
            : {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer Token'
              });
        if (allInfoField != null) {
          request.fields.addAll(allInfoField);
        }

        if (imageListWithKeyValue != null) {
          for (int i = 0; i < imageListWithKeyValue.length; i++) {
            request.files.add(await http.MultipartFile.fromPath(
                imageListWithKeyValue[i]['key'],
                imageListWithKeyValue[i]['value']));
          }
        }

        if (multipleImageListWithKeyValue != null) {
          for (int i = 0; i < multipleImageListWithKeyValue.length; i++) {
            if (multipleImageListWithKeyValue[i]['key'] != null) {
              List<http.MultipartFile> files = [];
              for (String path in multipleImageListWithKeyValue[i]['key']) {
                var f = await http.MultipartFile.fromPath(
                    multipleImageListWithKeyValue[i]['key'], path);
                files.add(f);
              }
              request.files.addAll(files);
              globalLogger.d(multipleImageListWithKeyValue[i]['key']);
            }
          }
        }

        final res = await request.send();
        response = await http.Response.fromStream(res);
      } else {
        response = (httpMethod == HttpMethod.get
            ? await http
                .get(urlL,
                    headers: noNeedAuthToken
                        ? headers ?? {}
                        : {
                            'Content-Type': 'application/json; charset=UTF-8',
                            'Authorization': 'Bearer Token'
                          })
                .timeout(const Duration(seconds: 20), onTimeout: () {
                return http.Response('Token Error', 500);
              }).catchError((e) {
                globalLogger.e(e.toString());
                return http.Response('Token Error', 500);
              })
            : httpMethod == HttpMethod.post
                ? await http
                    .post(urlL,
                        headers: noNeedAuthToken
                            ? headers ?? {}
                            : {
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                'Authorization': 'Bearer Token'
                              },
                        body: body,
                        encoding: encoding)
                    .timeout(const Duration(seconds: 20), onTimeout: () {
                    return http.Response('Token Error', 500);
                  }).catchError((e) {
                    globalLogger.e(e.toString());
                    return http.Response('Token Error', 500);
                  })
                : httpMethod == HttpMethod.put
                    ? await http
                        .put(urlL,
                            headers: noNeedAuthToken
                                ? headers ?? {}
                                : {
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                    'Authorization': 'Bearer Token'
                                  },
                            body: body,
                            encoding: encoding)
                        .timeout(const Duration(seconds: 20), onTimeout: () {
                        return http.Response('Token Error', 500);
                      }).catchError((e) {
                        globalLogger.e(e.toString());
                        return http.Response('Token Error', 500);
                      })
                    : httpMethod == HttpMethod.patch
                        ? await http
                            .patch(urlL,
                                headers: noNeedAuthToken
                                    ? headers ?? {}
                                    : {
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                        'Authorization': 'Bearer Token'
                                      },
                                body: body,
                                encoding: encoding)
                            .timeout(const Duration(seconds: 20),
                                onTimeout: () {
                            return http.Response('Token Error', 500);
                          }).catchError((e) {
                            globalLogger.e(e.toString());
                            return http.Response('Token Error', 500);
                          })
                        : await http.delete(urlL,
                            headers: noNeedAuthToken
                                ? headers ?? {}
                                : {
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                    'Authorization': 'Bearer Token'
                                  },
                            body: body,
                            encoding: encoding));
      }
      globalLogger.d(response.body);
      if (isLoadingEnable) {
        Get.back();
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.closeAllSnackbars();
        return jsonDecode(response.body);
      } else if (response.statusCode == 400) {
        showAlert("The request was invalid!");
      } else if (response.statusCode == 401) {
        showAlert("Invalid login credentials!");
      } else if (response.statusCode == 403) {
        showAlert("You do not have enough permissions to perform this action!");
      } else if (response.statusCode == 404) {
        showAlert("The requested resource not found!");
      } else if (response.statusCode == 405) {
        showAlert("This request is not supported by the resource!");
      } else if (response.statusCode == 409) {
        showAlert("The request could not be completed due to a conflict!");
      } else if (response.statusCode == 429) {
        showAlert("Server is busy now!");
      } else if (response.statusCode == 500) {
        showAlert(
            "The request was not completed due to an internal error on the server side!");
      } else if (response.statusCode == 503) {
        showAlert("The server was unavailable!");
      } else {
        showAlert("Something went wrong!");
      }
      return {};
    } catch (e) {
      globalLogger.e(e);
      return {};
    }
  }

  /******************************** Book ********************************/
  /// Get All Book List
  static Future<List<BookModel>> getAllBookList() async {
    List<BookModel> bookLis = [];
    final response = await ServiceAPI.genericCall(
      url: '${baseUrl}books?$apiKey',
      httpMethod: HttpMethod.get,
    );
    globalLogger.d(response, "Get Book List Route");

    if (response['status'] != null && response['status'] == 200) {
      response['books'].forEach((element) {
        bookLis.add(BookModel.fromJson(element));
      });
    } else if (response['status'] != null && response['status'] != 200) {
      showAlert(response['message']);
    }
    return bookLis;
  }

  /// Get All Chapter List
  static Future<List<ChapterModel>> getAllChapterList(
      {required String bookSlug}) async {
    List<ChapterModel> chapterList = [];
    final response = await ServiceAPI.genericCall(
      url: '$baseUrl$bookSlug/chapters?$apiKey',
      httpMethod: HttpMethod.get,
    );
    globalLogger.d(response, "Get Chapter List Route");

    if (response['status'] != null && response['status'] == 200) {
      response['chapters'].forEach((element) {
        chapterList.add(ChapterModel.fromJson(element));
      });
    } else if (response['status'] != null && response['status'] != 200) {
      showAlert(response['message']);
    }
    return chapterList;
  }

  /// Get All Hadis List
  static Future<List<HadisModel>> getAllHadisList(
      {bool isPaginate = false}) async {
    List<HadisModel> hadisList = [];
    final response = await ServiceAPI.genericCall(
      url:
          '$baseUrl/hadiths/?$apiKey&book=${BookController.to.selectedBookSlug.toString()}&chapter=${ChapterController.to.selectedChapterNumber}&paginate=25',
      httpMethod: HttpMethod.get,
    );
    globalLogger.d(response, "Get Hadis List Route");

    if (response['status'] != null && response['status'] == 200) {
      response['hadiths']['data'].forEach((element) {
        hadisList.add(HadisModel.fromJson(element));
      });
    } else if (response['status'] != null && response['status'] != 200) {
      showAlert(response['message']);
    }
    return hadisList;
  }

  ///Alert Dialog
  static void showAlert(String message, {Widget? errorHandleButton}) {
    if (Get.isDialogOpen!) {
      Get.back(closeOverlays: true);
    } else {
      Get.defaultDialog(
        title: "Error",
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        actions: [
          CustomButtoon(
            height: 42,
            label: "OK",
            marginVertical: 8,
            onPressed: () {
              Get.back();
            },
          ),
          if (errorHandleButton != null) errorHandleButton,
        ],
      );
    }
  }
}
