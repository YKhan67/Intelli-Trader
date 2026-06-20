// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NewsItem _$NewsItemFromJson(Map<String, dynamic> json) {
  return _NewsItem.fromJson(json);
}

/// @nodoc
mixin _$NewsItem {
  @JsonKey(name: 'article_uuid')
  String get articleUuid => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  String get headline => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'sentiment_score')
  double get sentimentScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'currencies_mentioned')
  List<String> get currenciesMentioned => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  /// Serializes this NewsItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NewsItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NewsItemCopyWith<NewsItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsItemCopyWith<$Res> {
  factory $NewsItemCopyWith(NewsItem value, $Res Function(NewsItem) then) =
      _$NewsItemCopyWithImpl<$Res, NewsItem>;
  @useResult
  $Res call(
      {@JsonKey(name: 'article_uuid') String articleUuid,
      DateTime? timestamp,
      String source,
      String headline,
      String body,
      @JsonKey(name: 'sentiment_score') double sentimentScore,
      @JsonKey(name: 'currencies_mentioned') List<String> currenciesMentioned,
      String url});
}

/// @nodoc
class _$NewsItemCopyWithImpl<$Res, $Val extends NewsItem>
    implements $NewsItemCopyWith<$Res> {
  _$NewsItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NewsItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? articleUuid = null,
    Object? timestamp = freezed,
    Object? source = null,
    Object? headline = null,
    Object? body = null,
    Object? sentimentScore = null,
    Object? currenciesMentioned = null,
    Object? url = null,
  }) {
    return _then(_value.copyWith(
      articleUuid: null == articleUuid
          ? _value.articleUuid
          : articleUuid // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      headline: null == headline
          ? _value.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      sentimentScore: null == sentimentScore
          ? _value.sentimentScore
          : sentimentScore // ignore: cast_nullable_to_non_nullable
              as double,
      currenciesMentioned: null == currenciesMentioned
          ? _value.currenciesMentioned
          : currenciesMentioned // ignore: cast_nullable_to_non_nullable
              as List<String>,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NewsItemImplCopyWith<$Res>
    implements $NewsItemCopyWith<$Res> {
  factory _$$NewsItemImplCopyWith(
          _$NewsItemImpl value, $Res Function(_$NewsItemImpl) then) =
      __$$NewsItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'article_uuid') String articleUuid,
      DateTime? timestamp,
      String source,
      String headline,
      String body,
      @JsonKey(name: 'sentiment_score') double sentimentScore,
      @JsonKey(name: 'currencies_mentioned') List<String> currenciesMentioned,
      String url});
}

/// @nodoc
class __$$NewsItemImplCopyWithImpl<$Res>
    extends _$NewsItemCopyWithImpl<$Res, _$NewsItemImpl>
    implements _$$NewsItemImplCopyWith<$Res> {
  __$$NewsItemImplCopyWithImpl(
      _$NewsItemImpl _value, $Res Function(_$NewsItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of NewsItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? articleUuid = null,
    Object? timestamp = freezed,
    Object? source = null,
    Object? headline = null,
    Object? body = null,
    Object? sentimentScore = null,
    Object? currenciesMentioned = null,
    Object? url = null,
  }) {
    return _then(_$NewsItemImpl(
      articleUuid: null == articleUuid
          ? _value.articleUuid
          : articleUuid // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      headline: null == headline
          ? _value.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      sentimentScore: null == sentimentScore
          ? _value.sentimentScore
          : sentimentScore // ignore: cast_nullable_to_non_nullable
              as double,
      currenciesMentioned: null == currenciesMentioned
          ? _value._currenciesMentioned
          : currenciesMentioned // ignore: cast_nullable_to_non_nullable
              as List<String>,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NewsItemImpl extends _NewsItem {
  const _$NewsItemImpl(
      {@JsonKey(name: 'article_uuid') this.articleUuid = '',
      this.timestamp,
      this.source = 'Unknown',
      this.headline = 'No Headline',
      this.body = '',
      @JsonKey(name: 'sentiment_score') this.sentimentScore = 0.0,
      @JsonKey(name: 'currencies_mentioned')
      final List<String> currenciesMentioned = const [],
      this.url = ''})
      : _currenciesMentioned = currenciesMentioned,
        super._();

  factory _$NewsItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewsItemImplFromJson(json);

  @override
  @JsonKey(name: 'article_uuid')
  final String articleUuid;
  @override
  final DateTime? timestamp;
  @override
  @JsonKey()
  final String source;
  @override
  @JsonKey()
  final String headline;
  @override
  @JsonKey()
  final String body;
  @override
  @JsonKey(name: 'sentiment_score')
  final double sentimentScore;
  final List<String> _currenciesMentioned;
  @override
  @JsonKey(name: 'currencies_mentioned')
  List<String> get currenciesMentioned {
    if (_currenciesMentioned is EqualUnmodifiableListView)
      return _currenciesMentioned;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currenciesMentioned);
  }

  @override
  @JsonKey()
  final String url;

  @override
  String toString() {
    return 'NewsItem(articleUuid: $articleUuid, timestamp: $timestamp, source: $source, headline: $headline, body: $body, sentimentScore: $sentimentScore, currenciesMentioned: $currenciesMentioned, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsItemImpl &&
            (identical(other.articleUuid, articleUuid) ||
                other.articleUuid == articleUuid) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.headline, headline) ||
                other.headline == headline) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.sentimentScore, sentimentScore) ||
                other.sentimentScore == sentimentScore) &&
            const DeepCollectionEquality()
                .equals(other._currenciesMentioned, _currenciesMentioned) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      articleUuid,
      timestamp,
      source,
      headline,
      body,
      sentimentScore,
      const DeepCollectionEquality().hash(_currenciesMentioned),
      url);

  /// Create a copy of NewsItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsItemImplCopyWith<_$NewsItemImpl> get copyWith =>
      __$$NewsItemImplCopyWithImpl<_$NewsItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsItemImplToJson(
      this,
    );
  }
}

abstract class _NewsItem extends NewsItem {
  const factory _NewsItem(
      {@JsonKey(name: 'article_uuid') final String articleUuid,
      final DateTime? timestamp,
      final String source,
      final String headline,
      final String body,
      @JsonKey(name: 'sentiment_score') final double sentimentScore,
      @JsonKey(name: 'currencies_mentioned')
      final List<String> currenciesMentioned,
      final String url}) = _$NewsItemImpl;
  const _NewsItem._() : super._();

  factory _NewsItem.fromJson(Map<String, dynamic> json) =
      _$NewsItemImpl.fromJson;

  @override
  @JsonKey(name: 'article_uuid')
  String get articleUuid;
  @override
  DateTime? get timestamp;
  @override
  String get source;
  @override
  String get headline;
  @override
  String get body;
  @override
  @JsonKey(name: 'sentiment_score')
  double get sentimentScore;
  @override
  @JsonKey(name: 'currencies_mentioned')
  List<String> get currenciesMentioned;
  @override
  String get url;

  /// Create a copy of NewsItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewsItemImplCopyWith<_$NewsItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
