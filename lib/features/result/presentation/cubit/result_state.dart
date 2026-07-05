import 'package:equatable/equatable.dart';
import 'package:solar_calculator/features/result/model/result_session.dart';
import 'package:solar_calculator/features/result/repository/model.dart';

class ResultState extends Equatable {
  const ResultState({
    required this.session,
    this.result,
    this.isStreaming = false,
    this.isFallback = false,
    this.isRefreshing = false,
    this.shareMessage,
  });

  final ResultSession session;
  final ResulteModel? result;
  final bool isStreaming;
  final bool isFallback;
  final bool isRefreshing;
  final String? shareMessage;

  ResulteModel get data => result ?? session.result;

  ResultState copyWith({
    ResultSession? session,
    ResulteModel? result,
    bool? isStreaming,
    bool? isFallback,
    bool? isRefreshing,
    String? shareMessage,
    bool clearShareMessage = false,
  }) {
    return ResultState(
      session: session ?? this.session,
      result: result ?? this.result,
      isStreaming: isStreaming ?? this.isStreaming,
      isFallback: isFallback ?? this.isFallback,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      shareMessage:
          clearShareMessage ? null : (shareMessage ?? this.shareMessage),
    );
  }

  @override
  List<Object?> get props => [
    session,
    result,
    isStreaming,
    isFallback,
    isRefreshing,
    shareMessage,
  ];
}
