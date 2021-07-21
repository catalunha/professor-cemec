import 'package:professor/resource/resource_model.dart';
import 'package:flutter/material.dart';
import 'package:professor/theme/app_icon.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceCard extends StatelessWidget {
  final ResourceModel resourceModel;

  const ResourceCard({
    Key? key,
    required this.resourceModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            leading: resourceModel.url != null && resourceModel.url!.isNotEmpty
                ? Icon(AppIconData.linkOn)
                : Icon(AppIconData.linkOff),
            title: Text('${resourceModel.title}'),
            subtitle: Text('${resourceModel.description}'),
            onTap: resourceModel.url != null && resourceModel.url!.isNotEmpty
                ? () async {
                    bool can = await canLaunch(resourceModel.url!);
                    if (can) {
                      await launch(resourceModel.url!);
                    }
                  }
                : null,
          ),
          Text(resourceModel.id),
          Wrap(
            children: [
              IconButton(
                tooltip: 'Editar este recurso',
                icon: Icon(AppIconData.edit),
                onPressed: () async {
                  Navigator.pushNamed(context, '/resource_addedit',
                      arguments: resourceModel.id);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
