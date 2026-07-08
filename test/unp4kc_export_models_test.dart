import 'package:flutter_test/flutter_test.dart';
import 'package:starcitizen_doctor/data/app_unp4k_p4k_item_data.dart';
import 'package:starcitizen_doctor/ui/tools/unp4kc/widgets/models.dart';

void main() {
  group('collectFilesForExport', () {
    test('returns selected file directly', () {
      final files = {
        r'Data\foo.txt': AppUnp4kP4kItemData(
          name: r'Data\foo.txt',
          isDirectory: false,
        ),
      };

      expect(collectFilesForExport([r'Data\foo.txt'], files), [
        r'Data\foo.txt',
      ]);
    });

    test('expands selected folder to child files only', () {
      final files = {
        r'Data\Folder': AppUnp4kP4kItemData(
          name: r'Data\Folder',
          isDirectory: true,
        ),
        r'Data\Folder\a.txt': AppUnp4kP4kItemData(
          name: r'Data\Folder\a.txt',
          isDirectory: false,
        ),
        r'Data\Folder\Sub': AppUnp4kP4kItemData(
          name: r'Data\Folder\Sub',
          isDirectory: true,
        ),
        r'Data\Folder\Sub\b.txt': AppUnp4kP4kItemData(
          name: r'Data\Folder\Sub\b.txt',
          isDirectory: false,
        ),
        r'Data\Other\c.txt': AppUnp4kP4kItemData(
          name: r'Data\Other\c.txt',
          isDirectory: false,
        ),
      };

      expect(collectFilesForExport([r'Data\Folder'], files), [
        r'Data\Folder\Sub\b.txt',
        r'Data\Folder\a.txt',
      ]);
    });

    test('deduplicates files selected directly and through folder', () {
      final files = {
        r'Data\Folder': AppUnp4kP4kItemData(
          name: r'Data\Folder',
          isDirectory: true,
        ),
        r'Data\Folder\a.txt': AppUnp4kP4kItemData(
          name: r'Data\Folder\a.txt',
          isDirectory: false,
        ),
      };

      expect(
        collectFilesForExport([r'Data\Folder', r'Data\Folder\a.txt'], files),
        [r'Data\Folder\a.txt'],
      );
    });
  });

  group('defaultExportName', () {
    test('uses converted extension when requested', () {
      expect(defaultExportName(r'Data\audio.wem', true), 'audio.wav');
      expect(defaultExportName(r'Data\texture.dds.1', true), 'texture.png');
      expect(defaultExportName(r'Data\ship.cgf', true), 'ship.glb');
    });

    test('preserves original file name when conversion is disabled', () {
      expect(defaultExportName(r'Data\audio.wem', false), 'audio.wem');
    });
  });
}
