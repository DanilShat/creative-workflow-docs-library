# Каталог host actions і skills агента

## Навіщо потрібен каталог

Каталог потрібен, щоб:
- людина знала, що агент реально вміє;
- Codex не вигадував зайві можливості;
- система була керованою і безпечною.

Host action = конкретна дія в хост-програмі.
Skill = здатність агента використати одну або кілька дій правильно.

## Photoshop: host actions

### 1. `photoshop.get_active_document_context`
Повертає:
- назву документа;
- розміри;
- color mode, якщо доступно;
- кількість шарів або базову інформацію про активний шар;
- шлях до файлу, якщо документ уже збережений.

### 2. `photoshop.crop_canvas`
Призначення:
- обрізати canvas під формат.

Аргументи:
- width
- height
- anchor

### 3. `photoshop.resize_image`
Призначення:
- змінити розмір зображення.

Аргументи:
- width
- height
- resample_mode

### 4. `photoshop.duplicate_active_layer`
Призначення:
- зробити копію активного шару.

### 5. `photoshop.rename_active_layer`
Призначення:
- перейменувати активний шар.

Аргументи:
- new_name

### 6. `photoshop.export_active_document`
Призначення:
- експортувати активний документ у папку.

Аргументи:
- output_dir
- format
- quality_or_preset

### 7. `photoshop.save_copy_as`
Призначення:
- зберегти копію документа без руйнування оригіналу.

Аргументи:
- output_path
- format

## After Effects: host actions

### 1. `after_effects.get_project_context`
Повертає:
- назву проекту;
- список ключових композицій;
- список selected items, якщо доступно;
- базову інформацію про render queue.

### 2. `after_effects.import_assets`
Призначення:
- імпортувати файли у проект.

Аргументи:
- file_paths[]
- destination_folder_name optional

### 3. `after_effects.create_comp_from_preset`
Призначення:
- створити композицію за preset-ом.

Аргументи:
- name
- width
- height
- duration
- fps

### 4. `after_effects.place_asset_on_timeline`
Призначення:
- покласти ассет у композицію на визначену позицію.

Аргументи:
- comp_name or comp_id
- asset_ref
- start_time
- layer_order

### 5. `after_effects.precompose_selection`
Призначення:
- загорнути вибрані шари в precomp.

Аргументи:
- new_comp_name
- move_all_attributes boolean

### 6. `after_effects.add_to_render_queue`
Призначення:
- додати композицію в render queue.

Аргументи:
- comp_name or comp_id
- output_module_template optional
- render_settings_template optional

### 7. `after_effects.export_render_queue_manifest`
Призначення:
- зберегти manifest для handoff/логування.

## Skills агента

### `skill.read_host_context`
Читає контекст Photoshop або AE перед плануванням.

### `skill.plan_host_action`
Обертає запит людини в одну чи кілька allowlisted дій.

### `skill.validate_action_args`
Перевіряє аргументи до виконання.

### `skill.preview_plan`
Показує людині, що саме зараз буде зроблено.

### `skill.execute_host_action`
Виконує конкретну дію через host bridge.

### `skill.check_result`
Перевіряє, чи дала дія очікуваний результат.

### `skill.summarize_execution`
Готує людині короткий підсумок: що виконано, що не вдалося, які файли створено.

## Які skills НЕ повинні існувати у V1

Не треба додавати:
- `skill.run_arbitrary_photoshop_code`
- `skill.run_arbitrary_afterfx_script`
- `skill.modify_anything_without_confirmation`

## Приклад людського сценарію

Запит:
"Підріж активний документ під 4:5 і експортуй JPG у папку campaign_exports"

План:
1. `photoshop.get_active_document_context`
2. `photoshop.crop_canvas`
3. `photoshop.export_active_document`

Запит:
"Імпортуй усі сценові кліпи в AE, створи вертикальну композицію і поклади їх по порядку"

План:
1. `after_effects.import_assets`
2. `after_effects.create_comp_from_preset`
3. `after_effects.place_asset_on_timeline`
4. `after_effects.add_to_render_queue` optional
