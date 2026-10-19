---
name: lunchbox-buddy-flutter
description: Build "Lunchbox Buddy" (لانش بوكس بادي), an Arabic-first, AI-powered Flutter app (Android + iOS) that helps mothers decide what to cook and pack for their children. Use this skill whenever the task touches this project in any way - Flutter screens, widgets, state, Firebase, Gemini/AI features, recipes, kid profiles, meal planning, grocery lists, RTL/Arabic localization, design system, performance, or testing - even if the request does not mention the app name.
---

# Lunchbox Buddy - Flutter build skill

You are a senior Flutter engineer building a production-quality mobile app. Read this file fully before writing code. Follow it over your own defaults. If something here conflicts with the user's latest instruction, the user wins; say so in one line.

## 1. Product in one paragraph

A mother opens the app, tells it (by tapping, typing, speaking, or photographing her fridge) what she has, how much time she has, and who she is cooking for. The app answers with 3 meal ideas that fit her children's ages, allergies, dislikes and the ingredients she has. She taps one, cooks with a step-by-step Cook Mode, and later tells the app how it went. The app gets better with every answer. It must feel like a warm kitchen helper, never like a form, never like a generic AI chatbot.

Primary user: a busy mother, one hand free, often cooking, often tired. Design for glanceability, big touch targets, and zero typing when possible.

Default language: Arabic (RTL), with English as second language. All code, comments, identifiers and commit messages are in English. All user-facing strings live in ARB files.

## 2. Non-negotiables

1. **Safety is deterministic, not AI.** Allergen and age-safety filtering is done by plain Dart code against canonical ingredient IDs. The LLM may suggest; code decides. Never ship a recipe to the screen that has not passed `SafetyFilter`. Never trust an LLM to say "this is allergen-free".
2. **No API keys in the app.** All Gemini calls go through Firebase AI Logic with App Check enabled. Never hardcode secrets. Never commit `google-services.json` / `GoogleService-Info.plist` contents into docs or logs.
3. **Arabic-first, RTL-correct.** Every screen is built and checked in RTL first, then LTR. Use `EdgeInsetsDirectional`, `AlignmentDirectional`, `start`/`end`, never `left`/`right`.
4. **Offline-first for the core loop.** Saved recipes, kid profiles, the current week plan and the grocery list work with no internet. AI features degrade gracefully with a friendly message and a non-AI fallback (browse saved/curated recipes).
5. **Every AI call is structured.** Use JSON output with a response schema, parse into typed models, validate, and handle failure. Never render raw model text as UI, except in clearly marked chat bubbles.
6. **Not medical advice.** Show a short, one-time disclaimer for nutrition/allergy features. Do not make health claims.
7. **Small, reviewable steps.** Work phase by phase (section 9). Do not build features from a later phase early.

## 3. Stack (do not substitute without asking)

| Concern | Choice |
|---|---|
| Framework | Flutter (latest stable), Dart null-safe, `analysis_options.yaml` with `flutter_lints` + strict casts |
| State | Riverpod (`flutter_riverpod` + `riverpod_annotation` codegen) |
| Routing | `go_router` |
| Models | `freezed` + `json_serializable` |
| Local DB | `drift` (SQLite) for recipes, plans, grocery list, feedback |
| Backend | Firebase: Auth (anonymous first, upgrade to phone/Google later), Firestore, App Check, Remote Config, Crashlytics, Analytics |
| AI | Firebase AI Logic (`firebase_ai` package) with the Gemini Developer API backend, structured output |
| i18n | `flutter_localizations` + `intl` + ARB, Arabic default |
| Fonts | `google_fonts`: Cairo or Tajawal for Arabic, a matching Latin font for English |
| Motion | `flutter_animate`; `rive` or `lottie` only for 2-3 hero animations |
| Images | `cached_network_image`, resize/compress before upload |
| Voice | `speech_to_text` for input (Arabic locale), `flutter_tts` optional for Cook Mode |
| Camera | `image_picker` (fridge scan) |
| Notifications | `flutter_local_notifications` (night-before "what shall we pack tomorrow?") |
| Testing | `flutter_test`, `mocktail`, `integration_test`, golden tests for key widgets |

Before using any package API, check its current docs (pub.dev / official Firebase docs / the Firebase or Dart MCP server if available). Do not write Firebase AI, App Check or Riverpod code from memory; those APIs change. Read the docs, then write the code. Do not hardcode a Gemini model name in widgets: read it from `AppConfig`, fed by Remote Config, so models can be swapped without a release. Use a fast "flash"-class model for parsing and ranking and only escalate for rare complex generation.

## 4. Project structure (feature-first)

```
lib/
  main.dart
  app/                    # app widget, router, theme, bootstrap
  core/
    config/               # AppConfig, Remote Config keys
    errors/               # Failure types, result type
    safety/               # SafetyFilter, allergen + age rules, canonical ingredients
    ai/                   # AiClient, prompts, schemas, response parsers
    data/                 # drift database, DAOs, Firestore services
    l10n/                 # ARB files, helpers
    ui/                   # design system: tokens, components, animations
    utils/
  features/
    onboarding/
    kids/                 # kid profiles
    suggest/              # the "what do we cook?" flow
    recipe/               # detail + Cook Mode
    planner/              # week plan
    grocery/              # shopping list
    pantry_scan/          # fridge photo
    feedback/             # "did they eat it?" loop
    settings/
test/
integration_test/
```

Each feature has `data/`, `domain/`, `presentation/`. Domain has no Flutter imports. Widgets never call Firebase or Gemini directly; they talk to Riverpod providers that talk to repositories.

## 5. Core data models

Keep these as the source of truth (freezed):

- `KidProfile`: id, name, birthDate (age is derived), allergies (set of `AllergenId`), dislikes (set of `IngredientId`), likes, pickyLevel (0-3), lunchboxType (hot/cold/none), notes.
- `Ingredient`: canonical `id`, Arabic and English names, `allergens`, `category` (aisle), `commonInRegion`.
- `Recipe`: id, title, description, `ingredients` (IngredientId + quantity + unit), `steps`, prepMinutes, cookMinutes, servings, tags (quick, no-oven, one-pan, hidden-veggies, lunchbox-friendly, budget), `source` (curated / ai-generated / user), `ageMinMonths`, imagePath, `safetyVersion`.
- `MealSuggestionRequest`: kids selected, available ingredients, maxMinutes, mood tags (picky, budget, healthy, fun), mealType (breakfast/lunchbox/dinner/snack), free-text note.
- `MealPlan` (week), `GroceryItem`, `MealFeedback` (recipeId, kidId, reaction: loved/ok/refused, reasonTag, date).

Ingredients are always canonical IDs. Free-text ingredient names from AI or users are mapped to IDs by `IngredientResolver`; unresolved items are flagged "unverified" and block the allergen guarantee (show a gentle warning).

## 6. AI architecture

### 6.1 Hybrid: curated corpus + AI
- Start from a **curated recipe corpus** (the existing recipes from the old project, cleaned and tagged by a human). This is the quality floor and works offline.
- AI is used for: (a) understanding the mother's request, (b) ranking and adapting corpus recipes, (c) generating a brand-new recipe only when asked or when nothing fits, always labelled "AI idea" and always passed through `SafetyFilter`.
- Prefer ranking/adapting over generating. It is cheaper, faster and safer.

### 6.2 AI features (each is one function in `core/ai`, one prompt file, one schema, one parser, one test)
1. `parseRequest(text|voice)`: Arabic (including dialect) to `MealSuggestionRequest`. Example input: "الولد ما يحب الخضار وعندي دجاج وأرز وما عندي وقت". 
2. `rankAndAdapt(candidates, request, kids)`: picks 3 from candidates, proposes swaps ("replace yogurt with labneh"), explains why in one friendly sentence.
3. `generateRecipe(request, kids)`: structured recipe with canonical ingredient names.
4. `scanFridge(image)`: returns detected ingredients with confidence; the user must confirm chips before use.
5. `substitute(ingredient, context)`: safe swaps respecting the kids' allergies.
6. `weeklyPlan(kids, preferences, feedbackHistory)`: 5-7 days, variety rules (no repeated main protein two days in a row, one "fun" day).
7. `explainRefusal(feedback)`: optional, turns "he refused" into 1-2 adaptation tips for next time.

### 6.3 Rules for every AI call
- System instruction sets role, language (reply in the user's language), tone (warm, brief, practical), and forbids medical claims.
- Use JSON mode with a response schema. Parse into freezed models. On parse failure retry once with the error appended; on second failure return a typed `Failure` and use the fallback path.
- Pass only what is needed: kid age and allergy IDs, not names. Never send photos of children. Fridge photos are processed and not stored by default.
- Stream where the UI is a chat; use skeleton loaders where the result is a card list.
- Cache results in drift keyed by a hash of (request + kids' constraints). Reuse before calling again.
- Timeout (8-10 s), cancel on screen exit, per-user rate limit, and never block the UI thread: heavy parsing runs in `compute`/an isolate.
- Log latency and failure rate to Analytics (no personal data).

### 6.4 SafetyFilter pipeline (mandatory, in `core/safety`)
```
AI/curated recipe -> resolve ingredients to IDs -> allergen check (kids' allergies)
 -> age rules (e.g. choking hazards, honey for infants, per ageMinMonths)
 -> dislike check (soft: lowers rank, does not remove)
 -> pass / fail with reason
```
- Rules live in a versioned Dart table with unit tests. A pediatric dietitian or qualified person should review the age-rule table before launch. Mark this as TODO in the repo until reviewed.
- Unit-test with at least 30 allergy/age cases. This suite must be green before any release.

## 7. Features and what "done" means

Build in the phases of section 9. Acceptance criteria for the MVP:

1. **Onboarding (under 60 seconds):** language, add one child (name, birth year/month, allergies chips, dislikes chips), done. No account wall; anonymous auth in the background.
2. **Suggest flow:** one big tactile button "اقترحي لي وجبة" opens a sheet with chips for time, meal type, mood, and a mic/text/camera row. Result: 3 swipeable meal cards in under 4 seconds on a normal connection (skeleton while loading).
3. **Recipe detail:** hero image or illustration, time/servings, ingredient list with "I have it" checks, adjust servings (quantities scale), swap suggestions, save, add missing items to grocery list.
4. **Cook Mode:** one step per screen, very large text, screen stays awake, hands-free next/back (swipe or voice), built-in timers parsed from step text, haptics, a clear "done" moment.
5. **Feedback loop:** after cooking, one tap: loved / ok / refused (plus optional reason chip). Stored locally and used by ranking.
6. **Grocery list:** grouped by aisle, tick-off, share as text (WhatsApp friendly), works offline.
7. **Saved recipes + history**, offline.

Post-MVP (only when asked): fridge scan, weekly planner, night-before reminder, Ramadan mode (suhoor/iftar suggestions), budget mode using local prices, multiple households, shareable family plan, premium tier.

## 8. Design system

Direction: warm, tactile, playful but trustworthy; the feeling of a real kitchen (paper, ceramic, wood, steam), not neon gradients, not purple-on-white AI defaults. Mothers should feel looked after, not sold to.

Reference for feel (inspiration only, never copy code): dqnamo's "Kitchen" interface studies (tactile button, hold-to-confirm, dynamic button, ticket, stamp, scroll-fade list, receipt printer). Those are web (React) experiments; re-create the interaction ideas natively in Flutter with `CustomPainter`, `CustomClipper`, `AnimatedContainer`, `flutter_animate` and `HapticFeedback`.

Adaptations to build in `core/ui`:
| Idea | Our use |
|---|---|
| Tactile button (pressable depth) | Primary CTA and big mood buttons; shadow shrinks and the face moves down 2-3 px on press, light haptic |
| Hold-to-confirm | Delete child profile, clear history; fills while held, offers undo |
| Dynamic button | Save -> Saving -> Saved with smooth width change |
| Ticket / stamp shapes | Recipe cards shaped like a lunch ticket; "approved by kids" stamp after a "loved" feedback |
| Scroll-fade list | Ingredient lists and chip rows with a soft edge fade |
| Receipt printer motion | Grocery list "prints" in when generated |

Tokens (put in `core/ui/tokens.dart`, never hardcode colors or sizes in screens):
- Colors: warm off-white background, deep warm brown or charcoal text, one confident accent (tomato or turmeric), one fresh secondary (herb green), soft semantic colors for success/warning. Provide light theme first; dark theme in post-MVP. Check contrast (WCAG AA minimum).
- Type: Cairo/Tajawal for Arabic; sizes scale with system text scale; minimum body 16, Cook Mode step text 24+.
- Spacing scale 4/8/12/16/24/32. Radius 16-24 for cards, fully round for chips.
- Touch targets at least 48x48 dp, primary actions 56 dp.
- Motion: 150-300 ms, ease-out, purposeful only; respect "reduce motion".
- Illustrations over stock photos: consistent illustrated food style; generate or commission a small set and reuse. Do not use AI-generated photos that misrepresent the dish.

Components to build once and reuse: `AppButton` (tactile), `HoldButton`, `ChipSelector`, `RecipeCard`, `KidAvatarPicker`, `StepPage`, `TimerPill`, `SkeletonCard`, `EmptyState`, `AiBadge`, `SafeBadge`.

Copy tone: short, kind, practical. Arabic copy is written natively, not machine-translated; keep a glossary in `l10n/GLOSSARY.md`.

## 9. Build plan (phases, each ends with a runnable app and a git commit)

**Phase 0 - Foundation**
- `flutter create`, set org/bundle IDs, flavors (dev/prod), lints, CI (analyze + test).
- Theme + tokens + RTL + ARB setup with Arabic default. Router skeleton.
- Firebase project (dev), Auth anonymous, Firestore rules draft, App Check, Crashlytics.
- Done when: app launches on Android and iOS in Arabic RTL with an empty themed home.

**Phase 1 - Data and safety**
- Canonical ingredient table, drift schema, curated recipe import script (JSON -> drift), `SafetyFilter` with tests.
- Done when: safety test suite green, 30+ curated recipes load offline.

**Phase 2 - Kids and onboarding**
- Kid profiles CRUD, chips for allergies/dislikes, onboarding flow.
- Done when: a profile persists across restarts and drives filtering.

**Phase 3 - Suggest flow (rule-based first)**
- Request sheet, filtering and scoring on the curated corpus with no AI yet, result cards, recipe detail.
- Done when: the full loop works offline with zero AI. This is the fallback path forever.

**Phase 4 - AI layer**
- `AiClient`, schemas, `parseRequest`, `rankAndAdapt`, voice input, caching, error and fallback handling.
- Done when: free-text Arabic request returns safe, ranked cards; airplane mode falls back to Phase 3 cleanly.

**Phase 5 - Cook Mode + feedback + grocery**
- Step pages, timers, wake lock, haptics; feedback loop feeding ranking; grocery list with share.

**Phase 6 - Polish and performance**
- Motion, illustrations, empty/error states, accessibility pass (TalkBack/VoiceOver, text scale 200%), profile and fix jank.

**Phase 7 - Release**
- Store assets (Arabic + English), privacy policy (children's data and AI use), data-deletion flow, App Check production providers, closed testing with real mothers, then staged rollout.

**Phase 8+ (only on request):** fridge scan, weekly planner, reminders, Ramadan mode, premium.

## 10. Performance rules

App runtime:
- Target 60 fps (120 on capable devices), cold start under 2 s on a mid-range Android phone, no frame over 16 ms in lists.
- Use `const` constructors, small widgets, `ListView.builder`/slivers for anything long, stable `Key`s.
- Riverpod: use `select` to limit rebuilds, `autoDispose` for screen-scoped providers, never do work in `build`.
- Move JSON parsing and any CPU work to isolates (`compute`).
- Images: correct size for display, `cacheWidth`/`cacheHeight`, `cached_network_image`, WebP assets, precache hero images.
- Avoid `Opacity`/`ClipRRect` on large animated trees; prefer `FadeTransition`, `RepaintBoundary` where profiling shows need.
- Defer non-critical init (analytics, remote config fetch) until after first frame.
- App size: remove unused assets/fonts, enable R8 and tree-shaking, build with `--split-debug-info --obfuscate` for release.
- Always profile in `--profile` mode on a real mid-range device with DevTools before claiming a fix. Do not optimize blindly.

AI latency:
- Cheapest/fastest model that passes the eval set; short prompts; send IDs not prose.
- Show skeletons immediately, stream where possible, cache by constraint hash, prefetch the likely next screen's data.

## 11. Testing and quality gates

A task is not done until all of these pass:
- `dart format --set-exit-if-changed .`, `flutter analyze` with zero warnings.
- Unit tests for domain, SafetyFilter, parsers (with recorded AI JSON fixtures, including malformed ones).
- Widget/golden tests for `AppButton`, `RecipeCard`, `StepPage` in RTL and LTR, at text scale 1.0 and 2.0.
- One integration test per MVP flow: onboarding, suggest -> recipe -> cook -> feedback, grocery share.
- Manual check on one small Android phone and one iPhone-size simulator.
- An AI eval set of 40+ Arabic and English requests (with allergy traps) run before any prompt or model change; results recorded in `docs/ai-evals.md`.

## 12. How to work in Antigravity

1. Start every task by writing a short plan (Planning mode): files you will touch, models, providers, tests. Wait for approval on plans that touch architecture, data models or safety.
2. One agent per independent feature or layer; do not let two agents edit the same file. Foundation, data and safety are sequential; UI components and screens can run in parallel after tokens exist.
3. Keep tasks small: one screen, one repository, or one AI function at a time.
4. Use the Firebase and Dart/Flutter MCP servers when available instead of guessing APIs. Check docs for any package before using it.
5. Run the app on an emulator/simulator and verify visually in RTL before reporting done. Provide screenshots or recordings as artifacts.
6. After each phase: run all gates in section 11, commit with a conventional message (`feat:`, `fix:`, `test:`), update `docs/CHANGELOG.md`.
7. If requirements are unclear, ask one concrete question and propose a default. Do not invent product decisions.
8. Never delete or rewrite files outside the task scope. Never disable lints or tests to make something pass.

## 13. Do not

- Do not use a WebView wrapper of the old website.
- Do not call Gemini from widgets, or embed any API key.
- Do not let the LLM decide allergen safety.
- Do not store children's photos or full names in AI requests.
- Do not add ads, trackers, or dark patterns; this app serves children's parents.
- Do not use `left`/`right`, hardcoded colors, or hardcoded strings in widgets.
- Do not add packages casually; justify each in the PR description.
- Do not copy code or assets from third-party sites or libraries without checking their license. Inspiration is fine, copying is not.

## 14. Open decisions (ask the product owner, do not guess)

- Final app name and brand colors.
- Target countries and units (metric only?) and local ingredient availability.
- Monetization (free, premium, none).
- Who reviews the age/allergy rule table before launch.
- Whether recipes will be crowdsourced from mothers later (needs moderation).
