// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sentiment_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SentimentResult _$SentimentResultFromJson(Map<String, dynamic> json) {
  return _SentimentResult.fromJson(json);
}

/// @nodoc
mixin _$SentimentResult {
  DateTime get timestamp => throw _privateConstructorUsedError;
  @CurrencyPairConverter()
  CurrencyPair get pair => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_scores')
  Map<String, double> get currencyScores => throw _privateConstructorUsedError;
  @JsonKey(name: 'pair_score')
  double get pairScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'pre_news_block')
  bool get preNewsBlock => throw _privateConstructorUsedError;
  @JsonKey(name: 'hard_block')
  bool get hardBlock => throw _privateConstructorUsedError;
  @JsonKey(name: 'post_news_window')
  bool get postNewsWindow => throw _privateConstructorUsedError;
  @JsonKey(name: 'cot_bias')
  @DirectionConverter()
  Direction get cotBias => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_headlines')
  List<String> get topHeadlines => throw _privateConstructorUsedError;
  @JsonKey(name: 'sentiment_trend')
  String get sentimentTrend => throw _privateConstructorUsedError;

  /// Serializes this SentimentResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SentimentResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SentimentResultCopyWith<SentimentResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SentimentResultCopyWith<$Res> {
  factory $SentimentResultCopyWith(
          SentimentResult value, $Res Function(SentimentResult) then) =
      _$SentimentResultCopyWithImpl<$Res, SentimentResult>;
  @useResult
  $Res call(
      {DateTime timestamp,
      @CurrencyPairConverter() CurrencyPair pair,
      @JsonKey(name: 'currency_scores') Map<String, double> currencyScores,
      @JsonKey(name: 'pair_score') double pairScore,
      @JsonKey(name: 'pre_news_block') bool preNewsBlock,
      @JsonKey(name: 'hard_block') bool hardBlock,
      @JsonKey(name: 'post_news_window') bool postNewsWindow,
      @JsonKey(name: 'cot_bias') @DirectionConverter() Direction cotBias,
      @JsonKey(name: 'top_headlines') List<String> topHeadlines,
      @JsonKey(name: 'sentiment_trend') String sentimentTrend});
}

/// @nodoc
class _$SentimentResultCopyWithImpl<$Res, $Val extends SentimentResult>
    implements $SentimentResultCopyWith<$Res> {
  _$SentimentResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SentimentResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? pair = null,
    Object? currencyScores = null,
    Object? pairScore = null,
    Object? preNewsBlock = null,
    Object? hardBlock = null,
    Object? postNewsWindow = null,
    Object? cotBias = null,
    Object? topHeadlines = null,
    Object? sentimentTrend = null,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair,
      currencyScores: null == currencyScores
          ? _value.currencyScores
          : currencyScores // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      pairScore: null == pairScore
          ? _value.pairScore
          : pairScore // ignore: cast_nullable_to_non_nullable
              as double,
      preNewsBlock: null == preNewsBlock
          ? _value.preNewsBlock
          : preNewsBlock // ignore: cast_nullable_to_non_nullable
              as bool,
      hardBlock: null == hardBlock
          ? _value.hardBlock
          : hardBlock // ignore: cast_nullable_to_non_nullable
              as bool,
      postNewsWindow: null == postNewsWindow
          ? _value.postNewsWindow
          : postNewsWindow // ignore: cast_nullable_to_non_nullable
              as bool,
      cotBias: null == cotBias
          ? _value.cotBias
          : cotBias // ignore: cast_nullable_to_non_nullable
              as Direction,
      topHeadlines: null == topHeadlines
          ? _value.topHeadlines
          : topHeadlines // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sentimentTrend: null == sentimentTrend
          ? _value.sentimentTrend
          : sentimentTrend // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SentimentResultImplCopyWith<$Res>
    implements $SentimentResultCopyWith<$Res> {
  factory _$$SentimentResultImplCopyWith(_$SentimentResultImpl value,
          $Res Function(_$SentimentResultImpl) then) =
      __$$SentimentResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime timestamp,
      @CurrencyPairConverter() CurrencyPair pair,
      @JsonKey(name: 'currency_scores') Map<String, double> currencyScores,
      @JsonKey(name: 'pair_score') double pairScore,
      @JsonKey(name: 'pre_news_block') bool preNewsBlock,
      @JsonKey(name: 'hard_block') bool hardBlock,
      @JsonKey(name: 'post_news_window') bool postNewsWindow,
      @JsonKey(name: 'cot_bias') @DirectionConverter() Direction cotBias,
      @JsonKey(name: 'top_headlines') List<String> topHeadlines,
      @JsonKey(name: 'sentiment_trend') String sentimentTrend});
}

/// @nodoc
class __$$SentimentResultImplCopyWithImpl<$Res>
    extends _$SentimentResultCopyWithImpl<$Res, _$SentimentResultImpl>
    implements _$$SentimentResultImplCopyWith<$Res> {
  __$$SentimentResultImplCopyWithImpl(
      _$SentimentResultImpl _value, $Res Function(_$SentimentResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of SentimentResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? pair = null,
    Object? currencyScores = null,
    Object? pairScore = null,
    Object? preNewsBlock = null,
    Object? hardBlock = null,
    Object? postNewsWindow = null,
    Object? cotBias = null,
    Object? topHeadlines = null,
    Object? sentimentTrend = null,
  }) {
    return _then(_$SentimentResultImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pair: null == pair
          ? _value.pair
          : pair // ignore: cast_nullable_to_non_nullable
              as CurrencyPair,
      currencyScores: null == currencyScores
          ? _value._currencyScores
          : currencyScores // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      pairScore: null == pairScore
          ? _value.pairScore
          : pairScore // ignore: cast_nullable_to_non_nullable
              as double,
      preNewsBlock: null == preNewsBlock
          ? _value.preNewsBlock
          : preNewsBlock // ignore: cast_nullable_to_non_nullable
              as bool,
      hardBlock: null == hardBlock
          ? _value.hardBlock
          : hardBlock // ignore: cast_nullable_to_non_nullable
              as bool,
      postNewsWindow: null == postNewsWindow
          ? _value.postNewsWindow
          : postNewsWindow // ignore: cast_nullable_to_non_nullable
              as bool,
      cotBias: null == cotBias
          ? _value.cotBias
          : cotBias // ignore: cast_nullable_to_non_nullable
              as Direction,
      topHeadlines: null == topHeadlines
          ? _value._topHeadlines
          : topHeadlines // ignore: cast_nullable_to_non_nullable
              as List<String>,
      sentimentTrend: null == sentimentTrend
          ? _value.sentimentTrend
          : sentimentTrend // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SentimentResultImpl implements _SentimentResult {
  const _$SentimentResultImpl(
      {required this.timestamp,
      @CurrencyPairConverter() required this.pair,
      @JsonKey(name: 'currency_scores')
      required final Map<String, double> currencyScores,
      @JsonKey(name: 'pair_score') required this.pairScore,
      @JsonKey(name: 'pre_news_block') required this.preNewsBlock,
      @JsonKey(name: 'hard_block') required this.hardBlock,
      @JsonKey(name: 'post_news_window') required this.postNewsWindow,
      @JsonKey(name: 'cot_bias') @DirectionConverter() required this.cotBias,
      @JsonKey(name: 'top_headlines') required final List<String> topHeadlines,
      @JsonKey(name: 'sentiment_trend') required this.sentimentTrend})
      : _currencyScores = currencyScores,
        _topHeadlines = topHeadlines;

  factory _$SentimentResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$SentimentResultImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  @CurrencyPairConverter()
  final CurrencyPair pair;
  final Map<String, double> _currencyScores;
  @override
  @JsonKey(name: 'currency_scores')
  Map<String, double> get currencyScores {
    if (_currencyScores is EqualUnmodifiableMapView) return _currencyScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_currencyScores);
  }

  @override
  @JsonKey(name: 'pair_score')
  final double pairScore;
  @override
  @JsonKey(name: 'pre_news_block')
  final bool preNewsBlock;
  @override
  @JsonKey(name: 'hard_block')
  final bool hardBlock;
  @override
  @JsonKey(name: 'post_news_window')
  final bool postNewsWindow;
  @override
  @JsonKey(name: 'cot_bias')
  @DirectionConverter()
  final Direction cotBias;
  final List<String> _topHeadlines;
  @override
  @JsonKey(name: 'top_headlines')
  List<String> get topHeadlines {
    if (_topHeadlines is EqualUnmodifiableListView) return _topHeadlines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topHeadlines);
  }

  @override
  @JsonKey(name: 'sentiment_trend')
  final String sentimentTrend;

  @override
  String toString() {
    return 'SentimentResult(timestamp: $timestamp, pair: $pair, currencyScores: $currencyScores, pairScore: $pairScore, preNewsBlock: $preNewsBlock, hardBlock: $hardBlock, postNewsWindow: $postNewsWindow, cotBias: $cotBias, topHeadlines: $topHeadlines, sentimentTrend: $sentimentTrend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SentimentResultImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.pair, pair) || other.pair == pair) &&
            const DeepCollectionEquality()
                .equals(other._currencyScores, _currencyScores) &&
            (identical(other.pairScore, pairScore) ||
                other.pairScore == pairScore) &&
            (identical(other.preNewsBlock, preNewsBlock) ||
                other.preNewsBlock == preNewsBlock) &&
            (identical(other.hardBlock, hardBlock) ||
                other.hardBlock == hardBlock) &&
            (identical(other.postNewsWindow, postNewsWindow) ||
                other.postNewsWindow == postNewsWindow) &&
            (identical(other.cotBias, cotBias) || other.cotBias == cotBias) &&
            const DeepCollectionEquality()
                .equals(other._topHeadlines, _topHeadlines) &&
            (identical(other.sentimentTrend, sentimentTrend) ||
                other.sentimentTrend == sentimentTrend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      timestamp,
      pair,
      const DeepCollectionEquality().hash(_currencyScores),
      pairScore,
      preNewsBlock,
      hardBlock,
      postNewsWindow,
      cotBias,
      const DeepCollectionEquality().hash(_topHeadlines),
      sentimentTrend);

  /// Create a copy of SentimentResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SentimentResultImplCopyWith<_$SentimentResultImpl> get copyWith =>
      __$$SentimentResultImplCopyWithImpl<_$SentimentResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SentimentResultImplToJson(
      this,
    );
  }
}

abstract class _SentimentResult implements SentimentResult {
  const factory _SentimentResult(
      {required final DateTime timestamp,
      @CurrencyPairConverter() required final CurrencyPair pair,
      @JsonKey(name: 'currency_scores')
      required final Map<String, double> currencyScores,
      @JsonKey(name: 'pair_score') required final double pairScore,
      @JsonKey(name: 'pre_news_block') required final bool preNewsBlock,
      @JsonKey(name: 'hard_block') required final bool hardBlock,
      @JsonKey(name: 'post_news_window') required final bool postNewsWindow,
      @JsonKey(name: 'cot_bias')
      @DirectionConverter()
      required final Direction cotBias,
      @JsonKey(name: 'top_headlines') required final List<String> topHeadlines,
      @JsonKey(name: 'sentiment_trend')
      required final String sentimentTrend}) = _$SentimentResultImpl;

  factory _SentimentResult.fromJson(Map<String, dynamic> json) =
      _$SentimentResultImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  @CurrencyPairConverter()
  CurrencyPair get pair;
  @override
  @JsonKey(name: 'currency_scores')
  Map<String, double> get currencyScores;
  @override
  @JsonKey(name: 'pair_score')
  double get pairScore;
  @override
  @JsonKey(name: 'pre_news_block')
  bool get preNewsBlock;
  @override
  @JsonKey(name: 'hard_block')
  bool get hardBlock;
  @override
  @JsonKey(name: 'post_news_window')
  bool get postNewsWindow;
  @override
  @JsonKey(name: 'cot_bias')
  @DirectionConverter()
  Direction get cotBias;
  @override
  @JsonKey(name: 'top_headlines')
  List<String> get topHeadlines;
  @override
  @JsonKey(name: 'sentiment_trend')
  String get sentimentTrend;

  /// Create a copy of SentimentResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SentimentResultImplCopyWith<_$SentimentResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
