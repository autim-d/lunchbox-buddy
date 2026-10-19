import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/features/kids/presentation/kids_notifier.dart';
import 'package:lunchbox_buddy/features/kids/presentation/kids_screen.dart';
import 'package:lunchbox_buddy/features/onboarding/presentation/onboarding_screen.dart';
import 'package:lunchbox_buddy/features/recipe/presentation/debug_recipes_screen.dart';
import 'package:lunchbox_buddy/features/recipe/presentation/recipe_detail_screen.dart';
import 'package:lunchbox_buddy/features/recipe/presentation/saved_recipes_screen.dart';
import 'package:lunchbox_buddy/features/suggest/presentation/home_screen.dart';
import 'package:lunchbox_buddy/features/suggest/presentation/results_screen.dart';

/// Listenable that triggers GoRouter redirect re-evaluation when kids list changes
class _RouterListenable extends ChangeNotifier {
  _RouterListenable(Ref ref) {
    ref.listen(kidsListNotifierProvider, (_, _) => notifyListeners());
  }
}

/// Provider configuring the GoRouter instance with reactive redirect
final appRouterProvider = Provider<GoRouter>((ref) {
  final listenable = _RouterListenable(ref);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: listenable,
    redirect: (context, state) {
      final kidsAsync = ref.read(kidsListNotifierProvider);

      // Allow loading state without prematurely redirecting
      if (kidsAsync.isLoading) return null;

      final kids = kidsAsync.asData?.value ?? const [];
      final hasKids = kids.isNotEmpty;
      final isGoingToOnboarding = state.matchedLocation == '/onboarding';
      final isGoingToKids = state.matchedLocation == '/kids';

      // If no profiles exist, user must go through onboarding (unless managing on /kids)
      if (!hasKids) {
        if (isGoingToKids) return null;
        return isGoingToOnboarding ? null : '/onboarding';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/kids',
        name: 'kids',
        builder: (context, state) => const KidsScreen(),
      ),
      GoRoute(
        path: '/debug-recipes',
        name: 'debug-recipes',
        builder: (context, state) => const DebugRecipesScreen(),
      ),
      GoRoute(
        path: '/results',
        name: 'results',
        builder: (context, state) => const ResultsScreen(),
      ),
      GoRoute(
        path: '/recipe/:id',
        name: 'recipe-detail',
        builder: (context, state) {
          final recipeId = state.pathParameters['id'] ?? '';
          final extraRecipe = state.extra as Recipe?;
          return RecipeDetailScreen(
            recipeId: recipeId,
            initialRecipe: extraRecipe,
          );
        },
      ),
      GoRoute(
        path: '/saved-recipes',
        name: 'saved-recipes',
        builder: (context, state) => const SavedRecipesScreen(),
      ),
    ],
  );
});
