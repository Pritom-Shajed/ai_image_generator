import 'dart:typed_data';
import 'package:ai_image_generator/helper/environment/environment.dart';
import 'package:dio/dio.dart';

class PromptRepo {
  static Future<Uint8List?> generateImage (String prompt) async {
   try {
     String url = Environment.apiUrl;

     Map<String, dynamic> headers = {
       'Authorization': 'Bearer ${Environment.apiKey}'
     };


     Map<String, dynamic> payload = {
       'prompt': prompt,
       'style_id': '122',
       'aspect_ratio': '1:1',
       'cfg': '0',
       'seed': '0',
       'high_res_results': '1'
     };

     Dio dio = Dio();

     dio.options = BaseOptions(headers: headers, responseType: ResponseType.bytes);

     final response = await dio.post(url, data: FormData.fromMap(payload));

     if(response.statusCode == 200){

       Uint8List uint8list = Uint8List.fromList(response.data);

       return uint8list;
     } else {
       return null;
     }
   } catch (e){
     throw Exception(e.toString());
   }
  }
}
