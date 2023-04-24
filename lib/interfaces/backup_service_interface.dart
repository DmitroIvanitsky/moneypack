import 'dart:io';

abstract class BackupServiceInterface {

  void saveBackup();

  void loadBackup(File file);
}