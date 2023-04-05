import 'package:api_learn/models/hadis_model.dart';
import 'package:api_learn/utils/color/my_app_color.dart';
import 'package:api_learn/utils/constants/constants.dart';
import 'package:api_learn/utils/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class HadisItem extends StatefulWidget {
  const HadisItem({
    super.key,
    required this.hadisM,
  });

  final HadisModel hadisM;

  @override
  State<HadisItem> createState() => _HadisItemState();
}

class _HadisItemState extends State<HadisItem> {
  Translation? translatedData;
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
                    'Chapter Number : ${widget.hadisM.chapter!.chapterNumber}',
                    style: const TextStyle(
                      color: MyAppColor.primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Hadis Number : ${widget.hadisM.hadithNumber}',
                    style: const TextStyle(
                      color: MyAppColor.primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              space4C,
              SelectableText(
                widget.hadisM.hadithArabic!,
                style: const TextStyle(
                  color: MyAppColor.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.justify,
              ),
              space3C,
              CustomButtoon(
                label: 'Translate',
                marginHorizontal: 0,
                marginVertical: 0,
                height: 34,
                width: 85,
                borderRadiusAll: 15,
                isBorder: true,
                labelColor: MyAppColor.primaryColor,
                primary: MyAppColor.bgColor,
                onPressed: () async {
                  GoogleTranslator translator = GoogleTranslator();
                  if (translatedData == null) {
                    translatedData = await translator.translate(
                        widget.hadisM.hadithEnglish!,
                        from: 'en',
                        to: 'bn');
                  } else {
                    translatedData!.sourceLanguage.code == 'en'
                        ? translatedData = await translator.translate(
                            widget.hadisM.hadithEnglish!,
                            from: 'bn',
                            to: 'en')
                        : translatedData = await translator.translate(
                            widget.hadisM.hadithEnglish!,
                            from: 'en',
                            to: 'bn');
                  }
                  setState(() {});
                },
              ),
              space3C,
              SelectableText(
                translatedData == null
                    ? widget.hadisM.hadithEnglish!
                    : translatedData!.text,
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
