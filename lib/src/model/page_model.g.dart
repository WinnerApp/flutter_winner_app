// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageModel _$PageModelFromJson(Map<String, dynamic> json) => PageModel()
  ..pageNum = json['pageNum'] as int? ?? 0
  ..total = json['total'] as int? ?? 0
  ..pageSize = json['pageSize'] as int? ?? 0
  ..totalPage = json['totalPage'] as int? ?? 0;

Map<String, dynamic> _$PageModelToJson(PageModel instance) => <String, dynamic>{
      'pageNum': instance.pageNum,
      'total': instance.total,
      'pageSize': instance.pageSize,
      'totalPage': instance.totalPage,
    };
