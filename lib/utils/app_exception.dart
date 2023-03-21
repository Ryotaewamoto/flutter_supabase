/// アプリ内で使用する例外型のインターフェース。
class AppException implements Exception {
  const AppException({
    this.code,
    this.message,
    this.defaultMessage = 'エラーが発生しました。',
  });

  /// ステータスコードや独自のエラーコードなどのエラー種別を識別するための文字列
  final String? code;

  /// 例外の内容を説明するメッセージ
  final String? message;

  /// message が空の場合に使用されるメッセージ
  final String defaultMessage;

  @override
  String toString() {
    if (code == null) {
      return (message ?? '').ifIsEmpty(defaultMessage);
    }
    return '[$code] ${(message ?? '').ifIsEmpty(defaultMessage)}';
  }
}

extension StringExtension on String {
  /// 空文字の場合に変わりの文字を返す。
  String ifIsEmpty(String placeholder) => isEmpty ? placeholder : this;
}
