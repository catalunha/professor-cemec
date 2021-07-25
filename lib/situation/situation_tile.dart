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
        ? Column(
            children: [
              ListTile(
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
              ),
              situationModel!.type == 'choice'
                  ? SingleChildScrollView(
                      child: Column(
                        children: buildItens(context),
                      ),
                    )
                  : Container()
            ],
          )
        : ListTile(
            leading: Icon(
              AppIconData.undefined,
            ),
            title: Text('Situação não disponivel'),
          );
  }

  buildItens(context) {
    List<Widget> list = [];
    // Map<String, String> map = Map.fromIterable(
    //   widget.formController.situationModel.options!,
    //   key: (element) => element.id,
    //   value: (element) => element,
    // );
    for (var index in situationModel!.options!) {
      // if (map[index] != null) {
      // list.add(
      //   Container(
      //     key: ValueKey(index),
      //     child: Text(index),
      //   ),
      // );
      // }
      list.add(RadioListTile<String>(
        value: index,
        groupValue: situationModel!.choice,
        onChanged: null,
        title: Text(index),
      ));
    }
    // setState(() {});
    return list;
  }
}
