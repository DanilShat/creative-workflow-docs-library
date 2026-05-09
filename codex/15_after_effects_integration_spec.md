# After Effects Integration Spec

## Objective
Add a controlled integration path between the server-owned planner, designer worker/bridge and Adobe After Effects for scene assembly, composition setup and basic render preparation.

## Important constraint
Treat After Effects integration as more conservative than Photoshop. Start with a script bridge and optionally add a panel later.

## Recommended V1 mode
Script bridge:
- server creates a typed allowlisted action plan
- designer worker/bridge translates the approved action into a validated AE execution payload
- bridge launches or hands the validated payload to AE
- result files and logs are written to workspace

## Initial action catalog
- `after_effects.get_project_context`
- `after_effects.import_assets`
- `after_effects.create_comp_from_preset`
- `after_effects.place_asset_on_timeline`
- `after_effects.precompose_selection`
- `after_effects.add_to_render_queue`
- `after_effects.export_render_queue_manifest`

## Example scene assembly flow
1. import generated clips
2. create composition from preset
3. place clips in timeline order
4. optionally add transition placeholders
5. add comp to render queue
6. export manifest/log

## Why not full AE automation in V1
Because the object model is large and the error surface is wide. The first version should automate only deterministic repetitive setup tasks.

## V1 success criteria
- import footage reliably
- create comp reliably
- place assets in deterministic order
- hand off to designer for manual polish
