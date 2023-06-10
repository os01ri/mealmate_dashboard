import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealmate_dashboard/core/extensions/widget_extensions.dart';
import 'package:mealmate_dashboard/core/helper/cubit_status.dart';
import 'package:mealmate_dashboard/core/ui/theme/colors.dart';
import 'package:mealmate_dashboard/core/ui/theme/text_styles.dart';
import 'package:mealmate_dashboard/core/ui/widgets/main_text_field.dart';
import 'package:mealmate_dashboard/core/ui/widgets/mm_data_table/mm_add_dialog.dart';
import 'package:mealmate_dashboard/core/ui/widgets/mm_data_table/mm_delete_dialog.dart';
import 'package:mealmate_dashboard/core/ui/widgets/simple_label_text_field.dart';
import 'package:mealmate_dashboard/features/store/domain/usecases/add_nutritional.dart';
import 'package:mealmate_dashboard/features/store/domain/usecases/delete_nutritional.dart';
import 'package:mealmate_dashboard/features/store/domain/usecases/index_nutritional.dart';
import 'package:mealmate_dashboard/features/store/presentation/cubit/store_cubit.dart';

class NutritionalDeleteFieldWidget extends StatefulWidget {
  final Function onDeleteFinish;
  final dynamic id;
  const NutritionalDeleteFieldWidget({Key? key,required this.onDeleteFinish,required this.id}) : super(key: key);

  @override
  State<NutritionalDeleteFieldWidget> createState() => _NutritionalDeleteFieldWidgetState();
}

class _NutritionalDeleteFieldWidgetState extends State<NutritionalDeleteFieldWidget> {
  late TextEditingController nameController;
  final _formKey = GlobalKey<FormState>();
  late final StoreCubit _storeCubit;



  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    _storeCubit = StoreCubit();

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Row(
            children: [
              Expanded(child: Text("Are you sure you want to delete this item?",
                style: AppTextStyles.styleWeight700(
                  fontSize: 24,
                  color: Colors.red
                ),
              )),

              SizedBox(width: 16,),

              Icon(Icons.warning,
                color: Colors.red,
                size: 34,
              ),
            ],
          ),




          SizedBox(height: 30,),

          BlocListener(
            bloc: _storeCubit,
            listener: (context,StoreState state) {
              if(state.status == CubitStatus.success)
                {
                  Navigator.of(context).pop();
                  widget.onDeleteFinish();
                }
            },
            child: BlocBuilder<StoreCubit, StoreState>(
              bloc: _storeCubit,
              builder: (BuildContext context, StoreState state) {
                return switch (state.status) {
                CubitStatus.loading => const CircularProgressIndicator.adaptive().center(),
                CubitStatus.failure => const Text('error').center(),

                _ =>  mmDeleteDialogFooter(context: context,
                onDelete: (){

                _storeCubit.deleteNutritional(DeleteNutritionalParams(id: widget.id));

                }),
              };
              },
            ),
          ),

        ],
      ),
    );
  }
}