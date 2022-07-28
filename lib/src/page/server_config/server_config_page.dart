import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:flutter_winner_app/src/page/server_config/view_model/server_config_page_view_model.dart';
import 'package:provider/provider.dart';

class ServerConfigPage extends StatefulWidget {
  const ServerConfigPage({Key? key}) : super(key: key);

  @override
  State<ServerConfigPage> createState() => _ServerConfigPageState();
}

class _ServerConfigPageState
    extends BasePage<ServerConfigPage, ServerConfigPageViewModel> {
  @override
  Widget buildPage(BuildContext context) {
    final serverList = context.select<ServerConfigPageViewModel, List<String>>(
      (value) => value.serverList,
    );
    final currentIndex = context.select<ServerConfigPageViewModel, int>(
      (value) => value.currentIndex,
    );
    return ListView.separated(
      itemBuilder: (context, index) {
        bool selected = index == currentIndex;
        return Container(
          height: 60,
          color: Colors.white,
          child: TextButton(
            onPressed: () async => viewModel.onSelectedServer(index),
            child: ListTile(
              leading: Icon(
                selected ? Icons.check_box : Icons.check_box_outline_blank,
              ),
              title: Text(serverList[index]),
              selected: selected,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: serverList.length,
    );
  }

  @override
  ServerConfigPageViewModel create() {
    return ServerConfigPageViewModel();
  }

  @override
  void configPage(BasePageController controller, BuildContext context) {
    super.configPage(controller, context);
    controller.appBar?.actions = [
      TextButton(
        onPressed: () => _onDeleteServer(context),
        style: TextButton.styleFrom(primary: Colors.red),
        child: const Text("删除"),
      ),
      TextButton(
        onPressed: () => _onAddServer(context),
        child: const Text("新增"),
      ),
    ];
  }

  void _onAddServer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: _AddServerWdiget(
            controller: viewModel.controller,
            onAdd: () => viewModel.onAddServer(),
          ),
        );
      },
    );
  }

  void _onDeleteServer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("删除选中服务器地址"),
          content: const Text("确定删除吗？"),
          actions: [
            TextButton(
              child: const Text("取消"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("确定"),
              onPressed: () {
                Navigator.pop(context);
                viewModel.onDeleteServer();
              },
            ),
          ],
        );
      },
    );
  }
}

class _AddServerWdiget extends StatelessWidget {
  /// 输入框文本控制器
  final TextEditingController? controller;

  /// 点击添加按钮的回掉
  final VoidCallback? onAdd;

  /// 构造器
  /// [controller] 输入框文本控制器
  /// [onAdd] 点击添加按钮的回掉
  const _AddServerWdiget({
    Key? key,
    this.controller,
    this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(hintText: '请输入服务器地址'),
            controller: controller,
          ),
          hiSpace(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                onAdd?.call();
                Navigator.pop(context);
              },
              child: const Text("添加"),
            ),
          ),
        ],
      ),
    );
  }
}
