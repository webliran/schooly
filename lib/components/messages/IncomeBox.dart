import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:schooly/components/messages/MailItemList.dart';
import 'package:schooly/providers/mail.provider.dart';

class IncomeBox extends StatefulWidget {
  final prevMailProviderHolder;
  IncomeBox(this.prevMailProviderHolder);
  @override
  _IncomeBoxState createState() => _IncomeBoxState();
}

class _IncomeBoxState extends State<IncomeBox> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    if (widget.prevMailProviderHolder.messageList != null) {
      widget.prevMailProviderHolder.setMainInfo();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mailProviderHolder = context.watch<MailProvider>();

    void _onRefresh() async {
      await mailProviderHolder.getInbox("append_new");
      _refreshController.refreshCompleted();
    }

    void _onLoading() async {
      await mailProviderHolder.getInbox("append_old");
      _refreshController.loadComplete();
    }

    return mailProviderHolder.messageList != null
        ? Stack(children: [
            Container(
              child: mailProviderHolder.messageList.data.length > 0
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
                          itemCount: mailProviderHolder.messageList.data.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return MailItemList(
                                mailProviderHolder.messageList.data[index]);
                          }),
                    )
                  : Text('אין הודעות'),
            ),
            mailProviderHolder.showPreloader
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[CircularProgressIndicator()],
                      ),
                    ),
                  )
                : Container()
          ])
        : Center(child: CircularProgressIndicator());
  }
}
