import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:ai_image_generator/feature/prompt/repo/prompt_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'prompt_event.dart';
part 'prompt_state.dart';

class PromptBloc extends Bloc<PromptEvent, PromptState> {
  PromptBloc(): super(PromptInitial()){
    on<PromptInitialEvent>(promptInitialEvent);
    on<PromptEnteredEvent>(promptEnteredEvent);
  }

  FutureOr<void> promptEnteredEvent(PromptEnteredEvent event, Emitter<PromptState> emit) async{

    emit(PromptGeneratingImageLoadState());
    List<int>? bytes = await PromptRepo.generateImage(event.prompt);

    if(bytes != null) {
      emit(PromptGeneratingImageSuccessState(Uint8List.fromList(bytes)));
    } else {
      emit(PromptGeneratingImageErrorState());
    }
  }


  FutureOr<void> promptInitialEvent(PromptInitialEvent event, Emitter<PromptState> emit) {
    emit(PromptGeneratingImageSuccessState(null));
  }
}