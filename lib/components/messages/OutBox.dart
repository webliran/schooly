import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:schooly/components/messages/MailItemList.dart';
import 'package:schooly/components/messages/MailItemListOut.dart';
import 'package:schooly/providers/mail.provider.dart';

class OutBox extends StatefulWidget {
  @override
  _OutBoxState createState() => _OutBoxState();
}

class _OutBoxState extends State<OutBox> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    var mailProviderHolder = context.watch<MailProvider>();

    void _onRefresh() async {
      await mailProviderHolder.getOutBox("append_new");
      _refreshController.refreshCompleted();
    }

    void _onLoading() async {
      await mailProviderHolder.getOutBox("append_old");
      _refreshController.loadComplete();
    }

    return mailProviderHolder.messageListOut != null
        ? Container(
            child: mailProviderHolder.messageListOut.data.length > 0
                ? SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: CustomHeader(
                        builder: (BuildContext context, RefreshStatus mode) {
                      return Center(child: CircularProgressIndicator());
                    }),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus mode) {
                        return mode == LoadStatus.loading
                            ? Center(child: CircularProgressIndicator())
                            : Container();
                      },
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.builder(
                        itemCount:
                            mailProviderHolder.messageListOut.data.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          //print(mailProviderHolder.messageListOut.data[index]);
                          return MailItemListOut(
                              mailProviderHolder.messageListOut.data[index]);
                        }),
                  )
                : Text('אין הודעות'),
          )
        : Center(child: CircularProgressIndicator());
  }
}
