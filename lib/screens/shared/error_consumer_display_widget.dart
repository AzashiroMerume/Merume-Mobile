import 'package:flutter/material.dart';
import 'package:merume_mobile/providers/error_provider.dart';
import 'package:merume_mobile/constants/colors.dart';
import 'package:merume_mobile/constants/text_styles.dart';
import 'package:provider/provider.dart';

class ErrorConsumerDisplay extends StatelessWidget {
  const ErrorConsumerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ErrorProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            if (provider.showError)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            Align(
              alignment: Alignment.topCenter,
              child: provider.showError
                  ? FractionallySizedBox(
                      widthFactor: 0.8,
                      heightFactor: 0.2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (provider.retrySeconds > 0)
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  color: AppColors.darkGrey,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  children: [
                                    Text(provider.errorMessage,
                                        style: TextStyles.errorSmall),
                                    Text(
                                      'Retrying in ${provider.retrySeconds} seconds...',
                                      style: TextStyles.errorSmall,
                                    ),
                                  ],
                                ),
                              ),
                            if (provider.retrySeconds == 0)
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                height: 15,
                                width: 15,
                                child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.mellowLemon),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        );
      },
    );
  }
}
