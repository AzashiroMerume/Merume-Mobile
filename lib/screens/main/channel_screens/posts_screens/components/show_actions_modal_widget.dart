import 'package:flutter/material.dart';
import 'package:merume_mobile/constants/colors.dart';

typedef ActionCallback = void Function();

void showActionsModal(
  BuildContext context, {
  required bool byMe,
  required ActionCallback replyAction,
  required ActionCallback updateAction,
  required ActionCallback copyToClipboardAction,
  required ActionCallback deleteAction,
  required ActionCallback selectAction,
}) {
  const iconColor = AppColors.lavenderHaze;
  const textStyle = TextStyle(fontFamily: "WorkSans", color: Colors.white);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.postMain,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border.all(color: AppColors.lavenderHaze.withOpacity(0.5)),
        ),
        child: Wrap(
          children: <Widget>[
            // TODO: reply for participants and comment for everyone else
            ListTile(
              leading: const Icon(Icons.reply, color: iconColor),
              title: const Text('Reply', style: textStyle),
              onTap: () {
                // Perform reply action
                replyAction();
                Navigator.pop(context);
              },
            ),
            if (byMe)
              ListTile(
                leading: const Icon(Icons.edit, color: iconColor),
                title: const Text('Update', style: textStyle),
                onTap: () {
                  // Perform update action
                  updateAction();
                  Navigator.pop(context);
                },
              ),
            ListTile(
              leading: const Icon(Icons.copy, color: iconColor),
              title: const Text('Copy', style: textStyle),
              onTap: () {
                // Perform copy to clipboard action
                copyToClipboardAction();
                Navigator.pop(context);
              },
            ),
            if (byMe)
              ListTile(
                leading: const Icon(Icons.delete, color: iconColor),
                title: const Text('Delete', style: textStyle),
                onTap: () {
                  // Perform delete action
                  deleteAction();
                  Navigator.pop(context);
                },
              ),
            ListTile(
              leading: const Icon(Icons.check, color: iconColor),
              title: const Text('Select', style: textStyle),
              onTap: () {
                // Perform select action
                selectAction();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
