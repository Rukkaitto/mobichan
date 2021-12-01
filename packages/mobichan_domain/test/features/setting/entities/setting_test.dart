import 'package:flutter_test/flutter_test.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

void main() {
  group('Setting', () {
    const tSetting = Setting(title: 'Title', value: '', type: SettingType.bool);
    const tSettings = [
      tSetting,
      Setting(title: 'Other title', value: '', type: SettingType.bool),
    ];
    group('findByTitle', () {
      test('should return null if no setting is found', () {
        final setting = tSettings.findByTitle('test');
        expect(setting, null);
      });

      test('should return the setting if it is found', () {
        final setting = tSettings.findByTitle(tSetting.title);
        expect(setting, tSetting);
      });
    });

    group('props', () {
      test('should return the title, value and type', () {
        final props = tSetting.props;
        expect(props, [tSetting.title, tSetting.value, tSetting.type]);
      });
    });
  });
}
