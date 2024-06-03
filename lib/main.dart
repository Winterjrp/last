import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:last/utility/hive_box.dart';
import 'package:last/utility/hive_models/ingredient_in_recipes_model.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/pet_type/pet_physiological_info/pet_physiological_model.dart';
import 'package:last/utility/hive_models/pet_profile_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/utility/hive_models/nutrient_limit_info_model.dart';
import 'package:last/modules/admin/recipe/update_recipe/recipes_model.dart';
import 'package:last/modules/normal/login/responsive_login_view.dart';
import 'package:last/modules/normal/my_pet_with_no_authen/my_pet_with_no_authen_view.dart';
import 'package:last/provider/authentication_provider.dart';

void main() async {
  await Hive.initFlutter();
  await _openAllHiveBoxes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    bool isAuthen = true;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.mitrTextTheme(),
      ),
      home: ChangeNotifierProvider(
        create: (_) => AuthenticationProvider(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // return const MyPetView();
              return const MyPetWithNoAuthenticationView();
            }
            // return const AdminGetRecipeView();
            return const LoginView();
          },
        ),
      ),
    );
  }
}

Future<void> _openAllHiveBoxes() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PetProfileModelAdapter());
  Hive.registerAdapter(IngredientModelAdapter());
  Hive.registerAdapter(NutrientModelAdapter());
  Hive.registerAdapter(PetTypeModelAdapter());
  Hive.registerAdapter(PetChronicDiseaseModelAdapter());
  Hive.registerAdapter(NutrientLimitInfoModelAdapter());
  Hive.registerAdapter(IngredientInRecipeModelAdapter());
  Hive.registerAdapter(RecipeModelAdapter());
  Hive.registerAdapter(PetPhysiologicalModelAdapter());
  petTypeBox = await Hive.openBox<PetTypeModel>('petType');
  ingredientBox = await Hive.openBox<IngredientModel>('ingredient');
  recipeBox = await Hive.openBox<RecipeModel>('recipe');
}
