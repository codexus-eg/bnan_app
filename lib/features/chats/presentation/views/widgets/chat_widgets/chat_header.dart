import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/user_info.dart';
import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(
        top: 19,
        // start: 16,
        end: 16,
        bottom: 19,
      ),
      decoration: const BoxDecoration(
        color: ColorManager.mainColor14,
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(10),
          bottomEnd: Radius.circular(10),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: () => MyNavigator.pop(context),
              icon: Icon(
                isRtl ? Icons.arrow_back : Icons.arrow_forward,
                color: ColorManager.white,
              ),
            ),
            const UserInfo(),
          ],
        ),
      ),
    );
  }
}



// class _Avatar extends StatelessWidget {
//   const _Avatar();

//   @override
//   Widget build(BuildContext context) {
//     return const CircleAvatar(
//       radius: 20,
//       backgroundColor: Color(0xffC9A24A),
//       child: Text(
//         'س',
//         style: TextStyle(
//           color: ColorManager.mainColor14,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }
