import 'package:professor/resource/resource_model.dart';
import 'package:flutter/material.dart';
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
                ? Icon(Icons.link)
                : Icon(Icons.link_off),
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
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                Navigator.pushNamed(context, '/resource_addedit',
                    arguments: resourceModel.id);
              },
            ),
          ),
          Text(resourceModel.id),
        ],
      ),
    );
  }
}
