import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String senderId;
  final MessageType type;
  final String? text;
  final MediaData? media;
  final DateTime timestamp;
  final MessageStatus status;

  Message({
    required this.id,
    required this.senderId,
    required this.type,
    this.text,
    this.media,
    required this.timestamp,
    required this.status,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      senderId: data['senderId'],
      type: MessageType.values.byName(data['type']),
      text: data['text'],
      media: data['media'] != null ? MediaData.fromFirestore(data['media']) : null,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      status: MessageStatus.values.byName(data['status']),
    );
  }

  Map<String, dynamic> toFirestore({bool useServerTimestamp = false}) {
    return {
      'id': id,
      'senderId': senderId,
      'type': type.name,
      'text': text,
      'media': media?.toMap(),
      'timestamp': useServerTimestamp ?
      FieldValue.serverTimestamp() :
      (timestamp != null ? Timestamp.fromDate(timestamp!) : null),
      'status': status.name,
    };
  }
}

class MediaData {
  final String url;
  final String? thumbnail;
  final int? width;
  final int? height;
  final int? size;
  final int? duration;

  MediaData({
    required this.url,
    this.thumbnail,
    this.width,
    this.height,
    this.size,
    this.duration,
  });

  factory MediaData.fromFirestore(Map<String, dynamic> data) {
    return MediaData(
      url: data['url'],
      thumbnail: data['thumbnail'],
      width: data['width'],
      height: data['height'],
      size: data['size'],
      duration: data['duration'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'thumbnail': thumbnail,
      'width': width,
      'height': height,
      'size': size,
      'duration': duration,
    };
  }
}

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed
}