import 'package:ai_image_generator/feature/prompt/bloc/prompt_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePromptScreen extends StatefulWidget {
  const CreatePromptScreen({super.key});

  @override
  State<CreatePromptScreen> createState() => _CreatePromptScreenState();
}

class _CreatePromptScreenState extends State<CreatePromptScreen> {

  late TextEditingController textEditingController;

  late PromptBloc promptBloc;

  @override
  void initState() {
    textEditingController = TextEditingController();
    promptBloc = PromptBloc();
    promptBloc.add(PromptInitialEvent());
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    promptBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Generate Images'),),
      body: BlocConsumer<PromptBloc, PromptState>(
        bloc: promptBloc,
          listener: (context, state){}, builder: (context, state){
        switch (state.runtimeType){
          case PromptGeneratingImageLoadState:
            return const Center(child: CircularProgressIndicator());
          case PromptGeneratingImageErrorState:
            return const Center(child: Text('Something went wrong'));
          case PromptGeneratingImageSuccessState:
            final successState = state as PromptGeneratingImageSuccessState;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: successState.uint8list == null ? const AssetImage('assets/bgImage.jpg') : MemoryImage(successState.uint8list!) as ImageProvider<Object>, fit: BoxFit.cover)
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Enter your prompt', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      const SizedBox(height: 20,),
                      TextField(
                        controller: textEditingController,
                        cursorColor: Colors.deepPurple,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)
                            )
                        ),
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                          height: 42,
                          width: double.maxFinite,
                          child: ElevatedButton.icon(onPressed: (){
                            if(textEditingController.text.isNotEmpty){
                              promptBloc.add(PromptEnteredEvent(prompt: textEditingController.text.trim()));
                            }
                          }, icon: const Icon(Icons.generating_tokens), label: const Text('Generate')))
                    ],
                  ),
                )
              ],
            );
          default:
            return const SizedBox.shrink();

        }
      })
    );
  }
}
