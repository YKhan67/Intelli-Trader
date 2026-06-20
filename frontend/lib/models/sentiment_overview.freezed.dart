// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sentiment_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CurrencySentiment _$CurrencySentimentFromJson(Map<String, dynamic> json) {
  return _CurrencySentiment.fromJson(json);
}

/// @nodoc
mixin _$CurrencySentiment {
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'score_4h')
  double get score4h => throw _privateConstructorUsedError;
  @JsonKey(name: 'score_24h')
  double get score24h => throw _privateConstructorUsedError;
  String get trend => throw _privateConstructorUsedError;

  /// Serializes this CurrencySentiment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CurrencySentiment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencySentimentCopyWith<CurrencySentiment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencySentimentCopyWith<$Res> {
  factory $CurrencySentimentCopyWith(
          CurrencySentiment value, $Res Function(CurrencySentiment) then) =
      _$CurrencySentimentCopyWithImpl<$Res, CurrencySentiment>;
  @useResult
  $Res call(
      {String currency,
      @JsonKey(name: 'score_4h') double score4h,
      @JsonKey(name: 'score_24h') double score24h,
      String trend});
}

/// @nodoc
class _$CurrencySentimentCopyWithImpl<$Res, $Val extends CurrencySentiment>
    implements $CurrencySentimentCopyWith<$Res> {
  _$CurrencySentimentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrencySentiment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currency = null,
    Object? score4h = null,
    Object? score24h = null,
    Object? trend = null,
  }) {
    return _then(_value.copyWith(
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      score4h: null == score4h
          ? _value.score4h
          : score4h // ignore: cast_nullable_to_non_nullable
              as double,
      score24h: null == score24h
          ? _value.score24h
          : score24h // ignore: cast_nullable_to_non_nullable
              as double,
      trend: null == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencySentimentImplCopyWith<$Res>
    implements $CurrencySentimentCopyWith<$Res> {
  factory _$$CurrencySentimentImplCopyWith(_$CurrencySentimentImpl value,
          $Res Function(_$CurrencySentimentImpl) then) =
      __$$CurrencySentimentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String currency,
      @JsonKey(name: 'score_4h') double score4h,
      @JsonKey(name: 'score_24h') double score24h,
      String trend});
}

/// @nodoc
class __$$CurrencySentimentImplCopyWithImpl<$Res>
    extends _$CurrencySentimentCopyWithImpl<$Res, _$CurrencySentimentImpl>
    implements _$$CurrencySentimentImplCopyWith<$Res> {
  __$$CurrencySentimentImplCopyWithImpl(_$CurrencySentimentImpl _value,
      $Res Function(_$CurrencySentimentImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrencySentiment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currency = null,
    Object? score4h = null,
    Object? score24h = null,
    Object? trend = null,
  }) {
    return _then(_$CurrencySentimentImpl(
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      score4h: null == score4h
          ? _value.score4h
          : score4h // ignore: cast_nullable_to_non_nullable
              as double,
      score24h: null == score24h
          ? _value.score24h
          : score24h // ignore: cast_nullable_to_non_nullable
              as double,
      trend: null == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrencySentimentImpl implements _CurrencySentiment {
  const _$CurrencySentimentImpl(
      {this.currency = '',
      @JsonKey(name: 'score_4h') this.score4h = 0.0,
      @JsonKey(name: 'score_24h') this.score24h = 0.0,
      this.trend = 'stable'});

  factory _$CurrencySentimentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrencySentimentImplFromJson(json);

  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'score_4h')
  final double score4h;
  @override
  @JsonKey(name: 'score_24h')
  final double score24h;
  @override
  @JsonKey()
  final String trend;

  @override
  String toString() {
    return 'CurrencySentiment(currency: $currency, score4h: $score4h, score24h: $score24h, trend: $trend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencySentimentImpl &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.score4h, score4h) || other.score4h == score4h) &&
            (identical(other.score24h, score24h) ||
                other.score24h == score24h) &&
            (identical(other.trend, trend) || other.trend == trend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, currency, score4h, score24h, trend);

  /// Create a copy of CurrencySentiment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencySentimentImplCopyWith<_$CurrencySentimentImpl> get copyWith =>
      __$$CurrencySentimentImplCopyWithImpl<_$CurrencySentimentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrencySentimentImplToJson(
      this,
    );
  }
}

abstract class _CurrencySentiment implements CurrencySentiment {
  const factory _CurrencySentiment(
      {final String currency,
      @JsonKey(name: 'score_4h') final double score4h,
      @JsonKey(name: 'score_24h') final double score24h,
      final String trend}) = _$CurrencySentimentImpl;

  factory _CurrencySentiment.fromJson(Map<String, dynamic> json) =
      _$CurrencySentimentImpl.fromJson;

  @override
  String get currency;
  @override
  @JsonKey(name: 'score_4h')
  double get score4h;
  @override
  @JsonKey(name: 'score_24h')
  double get score24h;
  @override
  String get trend;

  /// Create a copy of CurrencySentiment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencySentimentImplCopyWith<_$CurrencySentimentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SentimentOverview _$SentimentOverviewFromJson(Map<String, dynamic> json) {
  return _SentimentOverview.fromJson(json);
}

/// @nodoc
mixin _$SentimentOverview {
  Map<String, CurrencySentiment> get currencies =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'pair_sentiment')
  List<PairSentimentScore> get pairSentiment =>
      throw _privateConstructorUsedError;

  /// Serializes this SentimentOverview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SentimentOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SentimentOverviewCopyWith<SentimentOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SentimentOverviewCopyWith<$Res> {
  factory $SentimentOverviewCopyWith(
          SentimentOverview value, $Res Function(SentimentOverview) then) =
      _$SentimentOverviewCopyWithImpl<$Res, SentimentOverview>;
  @useResult
  $Res call(
      {Map<String, CurrencySentiment> currencies,
      @JsonKey(name: 'pair_sentiment') List<PairSentimentScore> pairSentiment});
}

/// @nodoc
class _$SentimentOverviewCopyWithImpl<$Res, $Val extends SentimentOverview>
    implements $SentimentOverviewCopyWith<$Res> {
  _$SentimentOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SentimentOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencies = null,
    Object? pairSentiment = null,
  }) {
    return _then(_value.copyWith(
      currencies: null == currencies
          ? _value.currencies
          : currencies // ignore: cast_nullable_to_non_nullable
              as Map<String, CurrencySentiment>,
      pairSentiment: null == pairSentiment
          ? _value.pairSentiment
          : pairSentiment // ignore: cast_nullable_to_non_nullable
              as List<PairSentimentScore>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SentimentOverviewImplCopyWith<$Res>
    implements $SentimentOverviewCopyWith<$Res> {
  factory _$$SentimentOverviewImplCopyWith(_$SentimentOverviewImpl value,
          $Res Function(_$SentimentOverviewImpl) then) =
      __$$SentimentOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, CurrencySentiment> currencies,
      @JsonKey(name: 'pair_sentiment') List<PairSentimentScore> pairSentiment});
}

/// @nodoc
class __$$SentimentOverviewImplCopyWithImpl<$Res>
    extends _$SentimentOverviewCopyWithImpl<$Res, _$SentimentOverviewImpl>
    implements _$$SentimentOverviewImplCopyWith<$Res> {
  __$$SentimentOverviewImplCopyWithImpl(_$SentimentOverviewImpl _value,
      $Res Function(_$SentimentOverviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of SentimentOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencies = null,
    Object? pairSentiment = null,
  }) {
    return _then(_$SentimentOverviewImpl(
      currencies: null == currencies
          ? _value._currencies
          : currencies // ignore: cast_nullable_to_non_nullable
              as Map<String, CurrencySentiment>,
      pairSentiment: null == pairSentiment
          ? _value._pairSentiment
          : pairSentiment // ignore: cast_nullable_to_non_nullable
              as List<PairSentimentScore>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SentimentOverviewImpl implements _SentimentOverview {
  const _$SentimentOverviewImpl(
      {final Map<String, CurrencySentiment> currencies = const {},
      @JsonKey(name: 'pair_sentiment')
      final List<PairSentimentScore> pairSentiment = const []})
      : _currencies = currencies,
        _pairSentiment = pairSentiment;

  factory _$SentimentOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$SentimentOverviewImplFromJson(json);

  final Map<String, CurrencySentiment> _currencies;
  @override
  @JsonKey()
  Map<String, CurrencySentiment> get currencies {
    if (_currencies is EqualUnmodifiableMapView) return _currencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_currencies);
  }

  final List<PairSentimentScore> _pairSentiment;
  @override
  @JsonKey(name: 'pair_sentiment')
  List<PairSentimentScore> get pairSentiment {
    if (_pairSentiment is EqualUnmodifiableListView) return _pairSentiment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pairSentiment);
  }

  @override
  String toString() {
    return 'SentimentOverview(currencies: $currencies, pairSentiment: $pairSentiment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SentimentOverviewImpl &&
            const DeepCollectionEquality()
                .equals(other._currencies, _currencies) &&
            const DeepCollectionEquality()
                .equals(other._pairSentiment, _pairSentiment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_currencies),
      const DeepCollectionEquality().hash(_pairSentiment));

  /// Create a copy of SentimentOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SentimentOverviewImplCopyWith<_$SentimentOverviewImpl> get copyWith =>
      __$$SentimentOverviewImplCopyWithImpl<_$SentimentOverviewImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SentimentOverviewImplToJson(
      this,
    );
  }
}

abstract class _SentimentOverview implements SentimentOverview {
  const factory _SentimentOverview(
      {final Map<String, CurrencySentiment> currencies,
      @JsonKey(name: 'pair_sentiment')
      final List<PairSentimentScore> pairSentiment}) = _$SentimentOverviewImpl;

  factory _SentimentOverview.fromJson(Map<String, dynamic> json) =
      _$SentimentOverviewImpl.fromJson;

  @override
  Map<String, CurrencySentiment> get currencies;
  @override
  @JsonKey(name: 'pair_sentiment')
  List<PairSentimentScore> get pairSentiment;

  /// Create a copy of SentimentOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SentimentOverviewImplCopyWith<_$SentimentOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PairSentimentScore _$PairSentimentScoreFromJson(Map<String, dynamic> json) {
  return _PairSentimentScore.fromJson(json);
}

/// @nodoc
mixin _$PairSentimentScore {
  String get pair => throw _privateConstructorUsedError;
  double get score => throw _privateConstructorUsedError;

  /// Serializes this PairSentimentScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PairSentimentScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PairSentimentScoreCopyWith<PairSentimentScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PairSentimentScoreCopyWith<$Res> {
  factory $PairSentimentScoreCopyWith(
          PairSentimentScore value, $Res Function(PairSentimentScore) then) =
      _$PairSentimentScoreCopyWithImpl<$Res, PairSentimentScore>;
  @useResult
  $Res call({String pair, double score});
}

/// @nodoc
class _$PairSentimentScoreCopyWithImpl<$Res, $Val extends PairSentimentScore>
    implements $PairSentimentScoreCopyWith<$Res> {
  _$PairSentimentScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PairSentimentScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pair = null,
    Object? score = null,
  }) {
    return _then(_value.copyWith(
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PairSentimentScoreImplCopyWith<$Res>
    implements $PairSentimentScoreCopyWith<$Res> {
  factory _$$PairSentimentScoreImplCopyWith(_$PairSentimentScoreImpl value,
          $Res Function(_$PairSentimentScoreImpl) then) =
      __$$PairSentimentScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String pair, double score});
}

/// @nodoc
class __$$PairSentimentScoreImplCopyWithImpl<$Res>
    extends _$PairSentimentScoreCopyWithImpl<$Res, _$PairSentimentScoreImpl>
    implements _$$PairSentimentScoreImplCopyWith<$Res> {
  __$$PairSentimentScoreImplCopyWithImpl(_$PairSentimentScoreImpl _value,
      $Res Function(_$PairSentimentScoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of PairSentimentScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pair = null,
    Object? score = null,
  }) {
    return _then(_$PairSentimentScoreImpl(
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PairSentimentScoreImpl implements _PairSentimentScore {
  const _$PairSentimentScoreImpl({this.pair = '', this.score = 0.0});

  factory _$PairSentimentScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$PairSentimentScoreImplFromJson(json);

  @override
  @JsonKey()
  final String pair;
  @override
  @JsonKey()
  final double score;

  @override
  String toString() {
    return 'PairSentimentScore(pair: $pair, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PairSentimentScoreImpl &&
            (identical(other.pair, pair) || other.pair == pair) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, pair, score);

  /// Create a copy of PairSentimentScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PairSentimentScoreImplCopyWith<_$PairSentimentScoreImpl> get copyWith =>
      __$$PairSentimentScoreImplCopyWithImpl<_$PairSentimentScoreImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PairSentimentScoreImplToJson(
      this,
    );
  }
}

abstract class _PairSentimentScore implements PairSentimentScore {
  const factory _PairSentimentScore({final String pair, final double score}) =
      _$PairSentimentScoreImpl;

  factory _PairSentimentScore.fromJson(Map<String, dynamic> json) =
      _$PairSentimentScoreImpl.fromJson;

  @override
  String get pair;
  @override
  double get score;

  /// Create a copy of PairSentimentScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PairSentimentScoreImplCopyWith<_$PairSentimentScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
