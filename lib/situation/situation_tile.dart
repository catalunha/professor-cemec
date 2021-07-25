import 'package:flutter/material.dart';

import 'package:professor/situation/controller/situation_model.dart';
import 'package:professor/theme/app_icon.dart';
import 'package:url_launcher/url_launcher.dart';

class SituationTile extends StatelessWidget {
  final SituationModel? situationModel;

  const SituationTile({
    Key? key,
    this.situationModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return situationModel != null
        ? ListTile(
            leading: Icon(AppIconData.proposal),
            title: Text('${situationModel!.title}'),
            subtitle: Text(
                '${situationModel!.description}\nsituationId: ${situationModel!.id}'),
            onTap: situationModel?.proposalUrl != null &&
                    situationModel!.proposalUrl.isNotEmpty
                ? () async {
                    bool can = await canLaunch(situationModel!.proposalUrl);
                    if (can) {
                      await launch(situationModel!.proposalUrl);
                    }
                  }
                : null,
          )
        : ListTile(
            leading: Icon(
              AppIconData.undefined,
            ),
            title: Text('Recurso não disponivel'),
          );
  }
}
