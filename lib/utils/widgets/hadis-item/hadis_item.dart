import 'package:api_learn/models/hadis_model.dart';
import 'package:api_learn/utils/color/my_app_color.dart';
import 'package:api_learn/utils/constants/constants.dart';
import 'package:flutter/material.dart';

class HadisItem extends StatelessWidget {
  const HadisItem({
    super.key,
    required this.hadisM,
  });

  final HadisModel hadisM;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 1,
            color: const Color(0xff007C4A),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Book Name : ${hadisM.book!.bookName}',
                    style: const TextStyle(
                      color: MyAppColor.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Hadis Number : ${hadisM.hadithNumber}',
                    style: const TextStyle(
                      color: MyAppColor.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              space4C,
              Text(
                hadisM.hadithEnglish!,
                style: const TextStyle(
                  color: MyAppColor.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
