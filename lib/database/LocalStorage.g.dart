// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocalStorage.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL UNIQUE');
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL UNIQUE');
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _profilePictureMeta =
      const VerificationMeta('profilePicture');
  @override
  late final GeneratedColumn<String> profilePicture = GeneratedColumn<String>(
      'profile_picture', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        deviceId,
        username,
        email,
        passwordHash,
        profilePicture,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('profile_picture')) {
      context.handle(
          _profilePictureMeta,
          profilePicture.isAcceptableOrUnknown(
              data['profile_picture']!, _profilePictureMeta));
    } else if (isInserting) {
      context.missing(_profilePictureMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      profilePicture: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}profile_picture'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  /// 自动增量的用户ID，唯一标识用户
  final int id;

  /// 设备唯一id
  final String deviceId;

  /// 用户名，要求唯一且长度在1到50之间
  final String username;

  /// 用户邮箱，要求唯一且长度在1到100之间
  final String email;

  /// 用户密码的哈希值
  final String passwordHash;

  /// 用户头像的URL，允许为空
  final String profilePicture;

  /// 用户的状态消息，默认为true
  final int? status;

  /// 用户创建时间，默认为当前时间
  final String createdAt;

  /// 用户更新时间，默认为当前时间
  final String updatedAt;
  const User(
      {required this.id,
      required this.deviceId,
      required this.username,
      required this.email,
      required this.passwordHash,
      required this.profilePicture,
      this.status,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['username'] = Variable<String>(username);
    map['email'] = Variable<String>(email);
    map['password_hash'] = Variable<String>(passwordHash);
    map['profile_picture'] = Variable<String>(profilePicture);
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<int>(status);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      username: Value(username),
      email: Value(email),
      passwordHash: Value(passwordHash),
      profilePicture: Value(profilePicture),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      username: serializer.fromJson<String>(json['username']),
      email: serializer.fromJson<String>(json['email']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      profilePicture: serializer.fromJson<String>(json['profilePicture']),
      status: serializer.fromJson<int?>(json['status']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'username': serializer.toJson<String>(username),
      'email': serializer.toJson<String>(email),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'profilePicture': serializer.toJson<String>(profilePicture),
      'status': serializer.toJson<int?>(status),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  User copyWith(
          {int? id,
          String? deviceId,
          String? username,
          String? email,
          String? passwordHash,
          String? profilePicture,
          Value<int?> status = const Value.absent(),
          String? createdAt,
          String? updatedAt}) =>
      User(
        id: id ?? this.id,
        deviceId: deviceId ?? this.deviceId,
        username: username ?? this.username,
        email: email ?? this.email,
        passwordHash: passwordHash ?? this.passwordHash,
        profilePicture: profilePicture ?? this.profilePicture,
        status: status.present ? status.value : this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('profilePicture: $profilePicture, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deviceId, username, email, passwordHash,
      profilePicture, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.username == this.username &&
          other.email == this.email &&
          other.passwordHash == this.passwordHash &&
          other.profilePicture == this.profilePicture &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> deviceId;
  final Value<String> username;
  final Value<String> email;
  final Value<String> passwordHash;
  final Value<String> profilePicture;
  final Value<int?> status;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.profilePicture = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String deviceId,
    required String username,
    required String email,
    required String passwordHash,
    required String profilePicture,
    this.status = const Value.absent(),
    required String createdAt,
    required String updatedAt,
  })  : deviceId = Value(deviceId),
        username = Value(username),
        email = Value(email),
        passwordHash = Value(passwordHash),
        profilePicture = Value(profilePicture),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? deviceId,
    Expression<String>? username,
    Expression<String>? email,
    Expression<String>? passwordHash,
    Expression<String>? profilePicture,
    Expression<int>? status,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (profilePicture != null) 'profile_picture': profilePicture,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? deviceId,
      Value<String>? username,
      Value<String>? email,
      Value<String>? passwordHash,
      Value<String>? profilePicture,
      Value<int?>? status,
      Value<String>? createdAt,
      Value<String>? updatedAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      profilePicture: profilePicture ?? this.profilePicture,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (profilePicture.present) {
      map['profile_picture'] = Variable<String>(profilePicture.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('profilePicture: $profilePicture, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ChatsTable extends Chats with TableInfo<$ChatsTable, Chat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _senderIdMeta =
      const VerificationMeta('senderId');
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
      'sender_id', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _senderUsernameMeta =
      const VerificationMeta('senderUsername');
  @override
  late final GeneratedColumn<String> senderUsername = GeneratedColumn<String>(
      'sender_username', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _senderAvatarMeta =
      const VerificationMeta('senderAvatar');
  @override
  late final GeneratedColumn<String> senderAvatar = GeneratedColumn<String>(
      'sender_avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recipientIdMeta =
      const VerificationMeta('recipientId');
  @override
  late final GeneratedColumn<String> recipientId = GeneratedColumn<String>(
      'recipient_id', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _isGroupMeta =
      const VerificationMeta('isGroup');
  @override
  late final GeneratedColumn<int> isGroup = GeneratedColumn<int>(
      'is_group', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _msgTypeMeta =
      const VerificationMeta('msgType');
  @override
  late final GeneratedColumn<String> msgType = GeneratedColumn<String>(
      'msg_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contentTextMeta =
      const VerificationMeta('contentText');
  @override
  late final GeneratedColumn<String> contentText = GeneratedColumn<String>(
      'content_text', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 1, maxTextLength: 1000),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contentAttachmentsMeta =
      const VerificationMeta('contentAttachments');
  @override
  late final GeneratedColumn<String> contentAttachments =
      GeneratedColumn<String>('content_attachments', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _metadataMessageIdMeta =
      const VerificationMeta('metadataMessageId');
  @override
  late final GeneratedColumn<String> metadataMessageId =
      GeneratedColumn<String>('metadata_message_id', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
              minTextLength: 1, maxTextLength: 50),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _metadataStatusMeta =
      const VerificationMeta('metadataStatus');
  @override
  late final GeneratedColumn<String> metadataStatus = GeneratedColumn<String>(
      'metadata_status', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        senderId,
        senderUsername,
        senderAvatar,
        recipientId,
        isGroup,
        msgType,
        contentText,
        contentAttachments,
        timestamp,
        metadataMessageId,
        metadataStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chats';
  @override
  VerificationContext validateIntegrity(Insertable<Chat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sender_id')) {
      context.handle(_senderIdMeta,
          senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
    }
    if (data.containsKey('sender_username')) {
      context.handle(
          _senderUsernameMeta,
          senderUsername.isAcceptableOrUnknown(
              data['sender_username']!, _senderUsernameMeta));
    } else if (isInserting) {
      context.missing(_senderUsernameMeta);
    }
    if (data.containsKey('sender_avatar')) {
      context.handle(
          _senderAvatarMeta,
          senderAvatar.isAcceptableOrUnknown(
              data['sender_avatar']!, _senderAvatarMeta));
    }
    if (data.containsKey('recipient_id')) {
      context.handle(
          _recipientIdMeta,
          recipientId.isAcceptableOrUnknown(
              data['recipient_id']!, _recipientIdMeta));
    }
    if (data.containsKey('is_group')) {
      context.handle(_isGroupMeta,
          isGroup.isAcceptableOrUnknown(data['is_group']!, _isGroupMeta));
    } else if (isInserting) {
      context.missing(_isGroupMeta);
    }
    if (data.containsKey('msg_type')) {
      context.handle(_msgTypeMeta,
          msgType.isAcceptableOrUnknown(data['msg_type']!, _msgTypeMeta));
    } else if (isInserting) {
      context.missing(_msgTypeMeta);
    }
    if (data.containsKey('content_text')) {
      context.handle(
          _contentTextMeta,
          contentText.isAcceptableOrUnknown(
              data['content_text']!, _contentTextMeta));
    } else if (isInserting) {
      context.missing(_contentTextMeta);
    }
    if (data.containsKey('content_attachments')) {
      context.handle(
          _contentAttachmentsMeta,
          contentAttachments.isAcceptableOrUnknown(
              data['content_attachments']!, _contentAttachmentsMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('metadata_message_id')) {
      context.handle(
          _metadataMessageIdMeta,
          metadataMessageId.isAcceptableOrUnknown(
              data['metadata_message_id']!, _metadataMessageIdMeta));
    } else if (isInserting) {
      context.missing(_metadataMessageIdMeta);
    }
    if (data.containsKey('metadata_status')) {
      context.handle(
          _metadataStatusMeta,
          metadataStatus.isAcceptableOrUnknown(
              data['metadata_status']!, _metadataStatusMeta));
    } else if (isInserting) {
      context.missing(_metadataStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      senderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_id']),
      senderUsername: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}sender_username'])!,
      senderAvatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_avatar']),
      recipientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipient_id']),
      isGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_group'])!,
      msgType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}msg_type'])!,
      contentText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_text'])!,
      contentAttachments: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}content_attachments']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      metadataMessageId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}metadata_message_id'])!,
      metadataStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}metadata_status'])!,
    );
  }

  @override
  $ChatsTable createAlias(String alias) {
    return $ChatsTable(attachedDatabase, alias);
  }
}

class Chat extends DataClass implements Insertable<Chat> {
  final int id;
  final String? senderId;
  final String senderUsername;
  final String? senderAvatar;
  final String? recipientId;
  final int isGroup;
  final String msgType;
  final String contentText;
  final String? contentAttachments;
  final DateTime timestamp;
  final String metadataMessageId;
  final String metadataStatus;
  const Chat(
      {required this.id,
      this.senderId,
      required this.senderUsername,
      this.senderAvatar,
      this.recipientId,
      required this.isGroup,
      required this.msgType,
      required this.contentText,
      this.contentAttachments,
      required this.timestamp,
      required this.metadataMessageId,
      required this.metadataStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || senderId != null) {
      map['sender_id'] = Variable<String>(senderId);
    }
    map['sender_username'] = Variable<String>(senderUsername);
    if (!nullToAbsent || senderAvatar != null) {
      map['sender_avatar'] = Variable<String>(senderAvatar);
    }
    if (!nullToAbsent || recipientId != null) {
      map['recipient_id'] = Variable<String>(recipientId);
    }
    map['is_group'] = Variable<int>(isGroup);
    map['msg_type'] = Variable<String>(msgType);
    map['content_text'] = Variable<String>(contentText);
    if (!nullToAbsent || contentAttachments != null) {
      map['content_attachments'] = Variable<String>(contentAttachments);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['metadata_message_id'] = Variable<String>(metadataMessageId);
    map['metadata_status'] = Variable<String>(metadataStatus);
    return map;
  }

  ChatsCompanion toCompanion(bool nullToAbsent) {
    return ChatsCompanion(
      id: Value(id),
      senderId: senderId == null && nullToAbsent
          ? const Value.absent()
          : Value(senderId),
      senderUsername: Value(senderUsername),
      senderAvatar: senderAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(senderAvatar),
      recipientId: recipientId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipientId),
      isGroup: Value(isGroup),
      msgType: Value(msgType),
      contentText: Value(contentText),
      contentAttachments: contentAttachments == null && nullToAbsent
          ? const Value.absent()
          : Value(contentAttachments),
      timestamp: Value(timestamp),
      metadataMessageId: Value(metadataMessageId),
      metadataStatus: Value(metadataStatus),
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chat(
      id: serializer.fromJson<int>(json['id']),
      senderId: serializer.fromJson<String?>(json['senderId']),
      senderUsername: serializer.fromJson<String>(json['senderUsername']),
      senderAvatar: serializer.fromJson<String?>(json['senderAvatar']),
      recipientId: serializer.fromJson<String?>(json['recipientId']),
      isGroup: serializer.fromJson<int>(json['isGroup']),
      msgType: serializer.fromJson<String>(json['msgType']),
      contentText: serializer.fromJson<String>(json['contentText']),
      contentAttachments:
          serializer.fromJson<String?>(json['contentAttachments']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      metadataMessageId: serializer.fromJson<String>(json['metadataMessageId']),
      metadataStatus: serializer.fromJson<String>(json['metadataStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'senderId': serializer.toJson<String?>(senderId),
      'senderUsername': serializer.toJson<String>(senderUsername),
      'senderAvatar': serializer.toJson<String?>(senderAvatar),
      'recipientId': serializer.toJson<String?>(recipientId),
      'isGroup': serializer.toJson<int>(isGroup),
      'msgType': serializer.toJson<String>(msgType),
      'contentText': serializer.toJson<String>(contentText),
      'contentAttachments': serializer.toJson<String?>(contentAttachments),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'metadataMessageId': serializer.toJson<String>(metadataMessageId),
      'metadataStatus': serializer.toJson<String>(metadataStatus),
    };
  }

  Chat copyWith(
          {int? id,
          Value<String?> senderId = const Value.absent(),
          String? senderUsername,
          Value<String?> senderAvatar = const Value.absent(),
          Value<String?> recipientId = const Value.absent(),
          int? isGroup,
          String? msgType,
          String? contentText,
          Value<String?> contentAttachments = const Value.absent(),
          DateTime? timestamp,
          String? metadataMessageId,
          String? metadataStatus}) =>
      Chat(
        id: id ?? this.id,
        senderId: senderId.present ? senderId.value : this.senderId,
        senderUsername: senderUsername ?? this.senderUsername,
        senderAvatar:
            senderAvatar.present ? senderAvatar.value : this.senderAvatar,
        recipientId: recipientId.present ? recipientId.value : this.recipientId,
        isGroup: isGroup ?? this.isGroup,
        msgType: msgType ?? this.msgType,
        contentText: contentText ?? this.contentText,
        contentAttachments: contentAttachments.present
            ? contentAttachments.value
            : this.contentAttachments,
        timestamp: timestamp ?? this.timestamp,
        metadataMessageId: metadataMessageId ?? this.metadataMessageId,
        metadataStatus: metadataStatus ?? this.metadataStatus,
      );
  @override
  String toString() {
    return (StringBuffer('Chat(')
          ..write('id: $id, ')
          ..write('senderId: $senderId, ')
          ..write('senderUsername: $senderUsername, ')
          ..write('senderAvatar: $senderAvatar, ')
          ..write('recipientId: $recipientId, ')
          ..write('isGroup: $isGroup, ')
          ..write('msgType: $msgType, ')
          ..write('contentText: $contentText, ')
          ..write('contentAttachments: $contentAttachments, ')
          ..write('timestamp: $timestamp, ')
          ..write('metadataMessageId: $metadataMessageId, ')
          ..write('metadataStatus: $metadataStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      senderId,
      senderUsername,
      senderAvatar,
      recipientId,
      isGroup,
      msgType,
      contentText,
      contentAttachments,
      timestamp,
      metadataMessageId,
      metadataStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chat &&
          other.id == this.id &&
          other.senderId == this.senderId &&
          other.senderUsername == this.senderUsername &&
          other.senderAvatar == this.senderAvatar &&
          other.recipientId == this.recipientId &&
          other.isGroup == this.isGroup &&
          other.msgType == this.msgType &&
          other.contentText == this.contentText &&
          other.contentAttachments == this.contentAttachments &&
          other.timestamp == this.timestamp &&
          other.metadataMessageId == this.metadataMessageId &&
          other.metadataStatus == this.metadataStatus);
}

class ChatsCompanion extends UpdateCompanion<Chat> {
  final Value<int> id;
  final Value<String?> senderId;
  final Value<String> senderUsername;
  final Value<String?> senderAvatar;
  final Value<String?> recipientId;
  final Value<int> isGroup;
  final Value<String> msgType;
  final Value<String> contentText;
  final Value<String?> contentAttachments;
  final Value<DateTime> timestamp;
  final Value<String> metadataMessageId;
  final Value<String> metadataStatus;
  const ChatsCompanion({
    this.id = const Value.absent(),
    this.senderId = const Value.absent(),
    this.senderUsername = const Value.absent(),
    this.senderAvatar = const Value.absent(),
    this.recipientId = const Value.absent(),
    this.isGroup = const Value.absent(),
    this.msgType = const Value.absent(),
    this.contentText = const Value.absent(),
    this.contentAttachments = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.metadataMessageId = const Value.absent(),
    this.metadataStatus = const Value.absent(),
  });
  ChatsCompanion.insert({
    this.id = const Value.absent(),
    this.senderId = const Value.absent(),
    required String senderUsername,
    this.senderAvatar = const Value.absent(),
    this.recipientId = const Value.absent(),
    required int isGroup,
    required String msgType,
    required String contentText,
    this.contentAttachments = const Value.absent(),
    required DateTime timestamp,
    required String metadataMessageId,
    required String metadataStatus,
  })  : senderUsername = Value(senderUsername),
        isGroup = Value(isGroup),
        msgType = Value(msgType),
        contentText = Value(contentText),
        timestamp = Value(timestamp),
        metadataMessageId = Value(metadataMessageId),
        metadataStatus = Value(metadataStatus);
  static Insertable<Chat> custom({
    Expression<int>? id,
    Expression<String>? senderId,
    Expression<String>? senderUsername,
    Expression<String>? senderAvatar,
    Expression<String>? recipientId,
    Expression<int>? isGroup,
    Expression<String>? msgType,
    Expression<String>? contentText,
    Expression<String>? contentAttachments,
    Expression<DateTime>? timestamp,
    Expression<String>? metadataMessageId,
    Expression<String>? metadataStatus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (senderId != null) 'sender_id': senderId,
      if (senderUsername != null) 'sender_username': senderUsername,
      if (senderAvatar != null) 'sender_avatar': senderAvatar,
      if (recipientId != null) 'recipient_id': recipientId,
      if (isGroup != null) 'is_group': isGroup,
      if (msgType != null) 'msg_type': msgType,
      if (contentText != null) 'content_text': contentText,
      if (contentAttachments != null) 'content_attachments': contentAttachments,
      if (timestamp != null) 'timestamp': timestamp,
      if (metadataMessageId != null) 'metadata_message_id': metadataMessageId,
      if (metadataStatus != null) 'metadata_status': metadataStatus,
    });
  }

  ChatsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? senderId,
      Value<String>? senderUsername,
      Value<String?>? senderAvatar,
      Value<String?>? recipientId,
      Value<int>? isGroup,
      Value<String>? msgType,
      Value<String>? contentText,
      Value<String?>? contentAttachments,
      Value<DateTime>? timestamp,
      Value<String>? metadataMessageId,
      Value<String>? metadataStatus}) {
    return ChatsCompanion(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderUsername: senderUsername ?? this.senderUsername,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      recipientId: recipientId ?? this.recipientId,
      isGroup: isGroup ?? this.isGroup,
      msgType: msgType ?? this.msgType,
      contentText: contentText ?? this.contentText,
      contentAttachments: contentAttachments ?? this.contentAttachments,
      timestamp: timestamp ?? this.timestamp,
      metadataMessageId: metadataMessageId ?? this.metadataMessageId,
      metadataStatus: metadataStatus ?? this.metadataStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (senderUsername.present) {
      map['sender_username'] = Variable<String>(senderUsername.value);
    }
    if (senderAvatar.present) {
      map['sender_avatar'] = Variable<String>(senderAvatar.value);
    }
    if (recipientId.present) {
      map['recipient_id'] = Variable<String>(recipientId.value);
    }
    if (isGroup.present) {
      map['is_group'] = Variable<int>(isGroup.value);
    }
    if (msgType.present) {
      map['msg_type'] = Variable<String>(msgType.value);
    }
    if (contentText.present) {
      map['content_text'] = Variable<String>(contentText.value);
    }
    if (contentAttachments.present) {
      map['content_attachments'] = Variable<String>(contentAttachments.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (metadataMessageId.present) {
      map['metadata_message_id'] = Variable<String>(metadataMessageId.value);
    }
    if (metadataStatus.present) {
      map['metadata_status'] = Variable<String>(metadataStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatsCompanion(')
          ..write('id: $id, ')
          ..write('senderId: $senderId, ')
          ..write('senderUsername: $senderUsername, ')
          ..write('senderAvatar: $senderAvatar, ')
          ..write('recipientId: $recipientId, ')
          ..write('isGroup: $isGroup, ')
          ..write('msgType: $msgType, ')
          ..write('contentText: $contentText, ')
          ..write('contentAttachments: $contentAttachments, ')
          ..write('timestamp: $timestamp, ')
          ..write('metadataMessageId: $metadataMessageId, ')
          ..write('metadataStatus: $metadataStatus')
          ..write(')'))
        .toString();
  }
}

class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL UNIQUE');
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now().toIso8601String()));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now().toIso8601String()));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(Insertable<Group> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Group(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class Group extends DataClass implements Insertable<Group> {
  /// 自增的群组ID，唯一标识一个群组
  final int id;

  /// 群组名称，必须唯一且长度在1到50个字符之间
  final String? name;

  /// 群组描述，可为空
  final String? description;

  /// 群组创建时间，默认为当前时间
  final String createdAt;

  /// 群组更新时间，默认为当前时间
  final String updatedAt;
  const Group(
      {required this.id,
      this.name,
      this.description,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Group.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Group copyWith(
          {int? id,
          Value<String?> name = const Value.absent(),
          Value<String?> description = const Value.absent(),
          String? createdAt,
          String? updatedAt}) =>
      Group(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> description;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  GroupsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<Group> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  GroupsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? name,
      Value<String?>? description,
      Value<String>? createdAt,
      Value<String>? updatedAt}) {
    return GroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UserGroupRelationsTable extends UserGroupRelations
    with TableInfo<$UserGroupRelationsTable, UserGroupRelation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserGroupRelationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isAdminMeta =
      const VerificationMeta('isAdmin');
  @override
  late final GeneratedColumn<bool> isAdmin = GeneratedColumn<bool>(
      'is_admin', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_admin" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _joinedAtMeta =
      const VerificationMeta('joinedAt');
  @override
  late final GeneratedColumn<String> joinedAt = GeneratedColumn<String>(
      'joined_at', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now().toIso8601String()));
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, groupId, isAdmin, joinedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_group_relations';
  @override
  VerificationContext validateIntegrity(Insertable<UserGroupRelation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('is_admin')) {
      context.handle(_isAdminMeta,
          isAdmin.isAcceptableOrUnknown(data['is_admin']!, _isAdminMeta));
    }
    if (data.containsKey('joined_at')) {
      context.handle(_joinedAtMeta,
          joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserGroupRelation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserGroupRelation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      isAdmin: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_admin'])!,
      joinedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}joined_at'])!,
    );
  }

  @override
  $UserGroupRelationsTable createAlias(String alias) {
    return $UserGroupRelationsTable(attachedDatabase, alias);
  }
}

class UserGroupRelation extends DataClass
    implements Insertable<UserGroupRelation> {
  /// 自增的关系ID，唯一标识一条关系
  final int id;

  /// 用户ID，表示一个群组成员
  final int userId;

  /// 群组ID，表示用户所属的群组
  final int groupId;

  /// 用户是否为群组管理员
  final bool isAdmin;

  /// 用户加入群组的时间，默认为当前时间
  final String joinedAt;
  const UserGroupRelation(
      {required this.id,
      required this.userId,
      required this.groupId,
      required this.isAdmin,
      required this.joinedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['group_id'] = Variable<int>(groupId);
    map['is_admin'] = Variable<bool>(isAdmin);
    map['joined_at'] = Variable<String>(joinedAt);
    return map;
  }

  UserGroupRelationsCompanion toCompanion(bool nullToAbsent) {
    return UserGroupRelationsCompanion(
      id: Value(id),
      userId: Value(userId),
      groupId: Value(groupId),
      isAdmin: Value(isAdmin),
      joinedAt: Value(joinedAt),
    );
  }

  factory UserGroupRelation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserGroupRelation(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      groupId: serializer.fromJson<int>(json['groupId']),
      isAdmin: serializer.fromJson<bool>(json['isAdmin']),
      joinedAt: serializer.fromJson<String>(json['joinedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'groupId': serializer.toJson<int>(groupId),
      'isAdmin': serializer.toJson<bool>(isAdmin),
      'joinedAt': serializer.toJson<String>(joinedAt),
    };
  }

  UserGroupRelation copyWith(
          {int? id,
          int? userId,
          int? groupId,
          bool? isAdmin,
          String? joinedAt}) =>
      UserGroupRelation(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        groupId: groupId ?? this.groupId,
        isAdmin: isAdmin ?? this.isAdmin,
        joinedAt: joinedAt ?? this.joinedAt,
      );
  @override
  String toString() {
    return (StringBuffer('UserGroupRelation(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('groupId: $groupId, ')
          ..write('isAdmin: $isAdmin, ')
          ..write('joinedAt: $joinedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, groupId, isAdmin, joinedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserGroupRelation &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.groupId == this.groupId &&
          other.isAdmin == this.isAdmin &&
          other.joinedAt == this.joinedAt);
}

class UserGroupRelationsCompanion extends UpdateCompanion<UserGroupRelation> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> groupId;
  final Value<bool> isAdmin;
  final Value<String> joinedAt;
  const UserGroupRelationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.isAdmin = const Value.absent(),
    this.joinedAt = const Value.absent(),
  });
  UserGroupRelationsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int groupId,
    this.isAdmin = const Value.absent(),
    this.joinedAt = const Value.absent(),
  })  : userId = Value(userId),
        groupId = Value(groupId);
  static Insertable<UserGroupRelation> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? groupId,
    Expression<bool>? isAdmin,
    Expression<String>? joinedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (groupId != null) 'group_id': groupId,
      if (isAdmin != null) 'is_admin': isAdmin,
      if (joinedAt != null) 'joined_at': joinedAt,
    });
  }

  UserGroupRelationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int>? groupId,
      Value<bool>? isAdmin,
      Value<String>? joinedAt}) {
    return UserGroupRelationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      isAdmin: isAdmin ?? this.isAdmin,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (isAdmin.present) {
      map['is_admin'] = Variable<bool>(isAdmin.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<String>(joinedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserGroupRelationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('groupId: $groupId, ')
          ..write('isAdmin: $isAdmin, ')
          ..write('joinedAt: $joinedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  late final $UsersTable users = $UsersTable(this);
  late final $ChatsTable chats = $ChatsTable(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $UserGroupRelationsTable userGroupRelations =
      $UserGroupRelationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, chats, groups, userGroupRelations];
}
