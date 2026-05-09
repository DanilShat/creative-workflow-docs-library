# Workflows

## 1. Static workflow

### Кроки
1. intake_task
2. normalize_brief
3. select_route
4. build_initial_prompt
5. generate_static_candidate
6. review_static_candidate
7. repair_prompt за потреби
8. regenerate
9. approve
10. export

## 2. Video workflow

### Кроки
1. intake_task
2. normalize_brief
3. split_scenario_into_scenes
4. для кожної сцени:
   - build_scene_static_prompt
   - generate_scene_keyframe
   - review_scene_keyframe
   - build_scene_video_prompt
   - generate_scene_video
   - review_scene_video
5. continuity_review
6. export_video_package

## 3. Repair loop

Repair повинен брати:
- старий промпт;
- старий результат;
- причини відхилення;
- початковий brief;

і робити:
- цільову правку;
- короткий changelog;
- нову версію промпта.
