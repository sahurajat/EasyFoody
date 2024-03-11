// ignore_for_file: camel_case_types, unnecessary_overrides, avoid_print, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class bannerController extends GetxController {
  RxList<String> bannerUrls = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    fetschbannerUrls();
  }

  // create this methodfetschbannerUrls
  Future<void> fetschbannerUrls() async {
    try {
      QuerySnapshot bannerSnaphshot =
          await FirebaseFirestore.instance.collection('banners').get();
      if (bannerSnaphshot.docs.isNotEmpty) {
        bannerUrls.value = bannerSnaphshot.docs
            .map((doc) => doc['imageurl'] as String)
            .toList();
      }
    } catch (e) {
      print("error:$e");
    }
  }
}
