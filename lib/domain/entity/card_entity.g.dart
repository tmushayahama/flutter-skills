// GENERATED CODE - DO NOT MODIFY BY HAND

part of card_entity;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CardEntity extends CardEntity {
  @override
  final String name;
  @override
  final String description;
  @override
  final BuiltList<BulletEntity> bulletPoints;
  @override
  final BuiltList<String> tags;
  @override
  final CardStatus status;
  @override
  final bool isFavorite;
  @override
  final String imagePath;
  @override
  final DateTime addedDate;
  @override
  final DateTime dueDate;
  @override
  final DateTime finishedDate;
  @override
  final DateTime notificationDate;

  factory _$CardEntity([void updates(CardEntityBuilder b)]) =>
      (new CardEntityBuilder()..update(updates)).build();

  _$CardEntity._(
      {this.name,
      this.description,
      this.bulletPoints,
      this.tags,
      this.status,
      this.isFavorite,
      this.imagePath,
      this.addedDate,
      this.dueDate,
      this.finishedDate,
      this.notificationDate})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('CardEntity', 'name');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('CardEntity', 'description');
    }
    if (bulletPoints == null) {
      throw new BuiltValueNullFieldError('CardEntity', 'bulletPoints');
    }
    if (tags == null) {
      throw new BuiltValueNullFieldError('CardEntity', 'tags');
    }
    if (status == null) {
      throw new BuiltValueNullFieldError('CardEntity', 'status');
    }
    if (isFavorite == null) {
      throw new BuiltValueNullFieldError('CardEntity', 'isFavorite');
    }
    if (imagePath == null) {
      throw new BuiltValueNullFieldError('CardEntity', 'imagePath');
    }
  }

  @override
  CardEntity rebuild(void updates(CardEntityBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  CardEntityBuilder toBuilder() => new CardEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CardEntity &&
        name == other.name &&
        description == other.description &&
        bulletPoints == other.bulletPoints &&
        tags == other.tags &&
        status == other.status &&
        isFavorite == other.isFavorite &&
        imagePath == other.imagePath &&
        addedDate == other.addedDate &&
        dueDate == other.dueDate &&
        finishedDate == other.finishedDate &&
        notificationDate == other.notificationDate;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc($jc(0, name.hashCode),
                                            description.hashCode),
                                        bulletPoints.hashCode),
                                    tags.hashCode),
                                status.hashCode),
                            isFavorite.hashCode),
                        imagePath.hashCode),
                    addedDate.hashCode),
                dueDate.hashCode),
            finishedDate.hashCode),
        notificationDate.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CardEntity')
          ..add('name', name)
          ..add('description', description)
          ..add('bulletPoints', bulletPoints)
          ..add('tags', tags)
          ..add('status', status)
          ..add('isFavorite', isFavorite)
          ..add('imagePath', imagePath)
          ..add('addedDate', addedDate)
          ..add('dueDate', dueDate)
          ..add('finishedDate', finishedDate)
          ..add('notificationDate', notificationDate))
        .toString();
  }
}

class CardEntityBuilder implements Builder<CardEntity, CardEntityBuilder> {
  _$CardEntity _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  ListBuilder<BulletEntity> _bulletPoints;
  ListBuilder<BulletEntity> get bulletPoints =>
      _$this._bulletPoints ??= new ListBuilder<BulletEntity>();
  set bulletPoints(ListBuilder<BulletEntity> bulletPoints) =>
      _$this._bulletPoints = bulletPoints;

  ListBuilder<String> _tags;
  ListBuilder<String> get tags => _$this._tags ??= new ListBuilder<String>();
  set tags(ListBuilder<String> tags) => _$this._tags = tags;

  CardStatus _status;
  CardStatus get status => _$this._status;
  set status(CardStatus status) => _$this._status = status;

  bool _isFavorite;
  bool get isFavorite => _$this._isFavorite;
  set isFavorite(bool isFavorite) => _$this._isFavorite = isFavorite;

  String _imagePath;
  String get imagePath => _$this._imagePath;
  set imagePath(String imagePath) => _$this._imagePath = imagePath;

  DateTime _addedDate;
  DateTime get addedDate => _$this._addedDate;
  set addedDate(DateTime addedDate) => _$this._addedDate = addedDate;

  DateTime _dueDate;
  DateTime get dueDate => _$this._dueDate;
  set dueDate(DateTime dueDate) => _$this._dueDate = dueDate;

  DateTime _finishedDate;
  DateTime get finishedDate => _$this._finishedDate;
  set finishedDate(DateTime finishedDate) =>
      _$this._finishedDate = finishedDate;

  DateTime _notificationDate;
  DateTime get notificationDate => _$this._notificationDate;
  set notificationDate(DateTime notificationDate) =>
      _$this._notificationDate = notificationDate;

  CardEntityBuilder();

  CardEntityBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _description = _$v.description;
      _bulletPoints = _$v.bulletPoints?.toBuilder();
      _tags = _$v.tags?.toBuilder();
      _status = _$v.status;
      _isFavorite = _$v.isFavorite;
      _imagePath = _$v.imagePath;
      _addedDate = _$v.addedDate;
      _dueDate = _$v.dueDate;
      _finishedDate = _$v.finishedDate;
      _notificationDate = _$v.notificationDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CardEntity other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CardEntity;
  }

  @override
  void update(void updates(CardEntityBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$CardEntity build() {
    _$CardEntity _$result;
    try {
      _$result = _$v ??
          new _$CardEntity._(
              name: name,
              description: description,
              bulletPoints: bulletPoints.build(),
              tags: tags.build(),
              status: status,
              isFavorite: isFavorite,
              imagePath: imagePath,
              addedDate: addedDate,
              dueDate: dueDate,
              finishedDate: finishedDate,
              notificationDate: notificationDate);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'bulletPoints';
        bulletPoints.build();
        _$failedField = 'tags';
        tags.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'CardEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
