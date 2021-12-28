import 'package:flutter/material.dart';

class NextFocusNodeManager {
  final Map<int, FocusNode> _focusNodeMap = {};

  /// 通过索引获取 [FocusNode]
  /// [index] 当前输入框的索引
  FocusNode getFocusNode(int index) {
    FocusNode? focusNode = _focusNodeMap[index];
    if (focusNode != null) return focusNode;
    FocusNode newFocusNode = FocusNode();
    _focusNodeMap[index] = newFocusNode;
    return newFocusNode;
  }

  /// 请求下个输入框获取焦点
  /// [index] 下个输入框的索引
  void nextRequestFocusNode(int index) {
    FocusNode? focusNode = _focusNodeMap[index];
    if (focusNode == null) return;
    focusNode.requestFocus();
  }
}
