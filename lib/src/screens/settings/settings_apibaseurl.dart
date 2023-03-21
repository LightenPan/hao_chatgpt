import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hao_chatgpt/src/extensions.dart';
import 'package:hao_chatgpt/src/preferences_manager.dart';

import '../../../l10n/generated/l10n.dart';
import '../../network/openai_service.dart';

class SettingsApiBaseUrl extends StatefulWidget {
  const SettingsApiBaseUrl({Key? key}) : super(key: key);

  @override
  State<SettingsApiBaseUrl> createState() => _SettingsProxyState();
}

class _SettingsProxyState extends State<SettingsApiBaseUrl> {
  final _hostnameController = TextEditingController();
  final _portNumberController = TextEditingController();
  String _apiBaseUrl = "https://api.openai.com";

  @override
  void initState() {
    super.initState();
    if (appPref.apiBaseUrl != null)
    {
      _apiBaseUrl = appPref.apiBaseUrl!;
    }
  }

  @override
  Widget build(BuildContext ctx) {
    String keyValue = _apiBaseUrl;
    Widget widget = AlertDialog(
      title: const Text(
        'API Base Url',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      content: TextField(
        controller: TextEditingController()..text = _apiBaseUrl,
        autofocus: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
        ),
        onChanged: (value) {
          keyValue = value;
        },
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (keyValue.isNotBlank) {
              keyValue = keyValue.trim();
              appPref.setApiBaseUrl(keyValue);
              openaiService.updateApiBaseUrl();
            }
            Navigator.of(ctx).pop(true);
          },
          child: Text(S.of(ctx).confirm),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(S.of(ctx).cancel),
        ),
      ],
    );
    return widget;
  }

  @override
  void dispose() {
    _hostnameController.dispose();
    _portNumberController.dispose();
    super.dispose();
  }
}
