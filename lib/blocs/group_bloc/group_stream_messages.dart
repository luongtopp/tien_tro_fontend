enum GroupStreamMessage {
  validating,
  groupLoaded,
  streamEnded,
  streamError,
  setupError,
}

extension GroupStreamMessageExtension on GroupStreamMessage {
  String get message {
    switch (this) {
      case GroupStreamMessage.validating:
        return 'Đang xác thực...';
      case GroupStreamMessage.groupLoaded:
        return 'Nhóm đã được tải';
      case GroupStreamMessage.streamEnded:
        return 'Stream nhóm đã kết thúc';
      case GroupStreamMessage.streamError:
        return 'Lỗi khi stream nhóm';
      case GroupStreamMessage.setupError:
        return 'Lỗi khi thiết lập stream nhóm';
    }
  }
}
