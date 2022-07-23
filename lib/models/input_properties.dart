import 'package:rentx/extensions/string_extension.dart';
import 'package:rentx/infrastructure/request.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/car.dart';

enum InputTypeEnum { string, decimal, integer }

extension InputTypeExtension on InputTypeEnum {
  String value() {
    return name.capitalize();
  }
}

enum DataTypeEnum { input, predefined }

extension DataTypeEnumeExtension on DataTypeEnum {
  String value() {
    return name.capitalize();
  }
}

class CarPropertyInput extends RentXSerialized {
  CarPropertyType? key;
  DataTypeEnum? type;
  List<String>? values;
  String? imageUrl;
  InputTypeEnum? inputType;

  CarPropertyInput(
      {this.key, this.type, this.values, this.imageUrl, this.inputType});

  CarPropertyInput.fromJson(Map<String, dynamic> json) {
    key = EnumUtil.strToEnumNullable(CarPropertyType.values, json['key']);
    type = EnumUtil.strToEnumNullable(DataTypeEnum.values, json['type']);
    values = convertList(json['values'], (p0) => p0.toString());
    imageUrl = json['imageUrl'];
    inputType =
        EnumUtil.strToEnumNullable(InputTypeEnum.values, json['inputType']);
  }

  @override
  Map<String, dynamic> toJson() => {
        'key': key?.name.capitalize(),
        'type': type?.value(),
        'values': values,
        'imageUrl': imageUrl,
        'inputType': inputType?.value()
      };
}
