import 'package:flutter/material.dart';
import 'package:merume_mobile/providers/error_provider.dart';
import 'package:merume_mobile/utils/colors.dart';
import 'package:merume_mobile/utils/text_styles.dart';
import 'package:provider/provider.dart';

class ErrorConsumerDisplay extends StatelessWidget {
  const ErrorConsumerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ErrorProvider>(
      builder: (context, provider, _) {
        if (provider.showError) {
          return Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (provider.retrySeconds > 0)
                  Column(
                    children: [
                      Text(provider.errorMessage, style: TextStyles.errorSmall),
                      Text(
                        'Retrying in ${provider.retrySeconds} seconds...',
                        style: TextStyles.errorSmall,
                      ),
                    ],
                  ),
                if (provider.retrySeconds < 0)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 15,
                    width: 15,
                    child: const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.mellowLemon),
                    ),
                  ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
