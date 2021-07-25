import 'package:flutter/material.dart';

import 'package:professor/situation/controller/situation_model.dart';
import 'package:professor/situation/situation_tile.dart';
import 'package:professor/theme/app_icon.dart';
import 'package:url_launcher/url_launcher.dart';

class SituationCard extends StatelessWidget {
  final SituationModel situationModel;
  const SituationCard({
    Key? key,
    required this.situationModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SituationTile(
            situationModel: situationModel,
          ),
          Wrap(
            children: [
              IconButton(
                tooltip: 'Editar este recurso',
                icon: Icon(AppIconData.edit),
                onPressed: () async {
                  Navigator.pushNamed(context, '/situation_addedit',
                      arguments: situationModel.id);
                },
              ),
              IconButton(
                tooltip: 'Solução desta situação',
                icon: Icon(AppIconData.solution),
                onPressed: () async {
                  bool can = await canLaunch(situationModel.solutionUrl);
                  if (can) {
                    await launch(situationModel.solutionUrl);
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
