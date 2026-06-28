import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';

 List<HomeStateModel> parentHomeStats = [
  HomeStateModel(
    icon: ImageManager.children,
    value: '2',
    title: 'الأبناء',
    iconColor: ColorManager.blue4260
  ),
  HomeStateModel(
    icon: ImageManager.certificateBadgeIcon,
    value: '3',
    title: 'شهادات',
    iconColor: ColorManager.mainColor14
  ),
  HomeStateModel(
    icon: ImageManager.starIcon,
    value: '5',
    title: 'تقييمات',
  ),
  HomeStateModel(
    icon: ImageManager.subscription,
    value: '2',
    title: 'الاشتراكات',
    iconColor: ColorManager.redD5
  ),
];
