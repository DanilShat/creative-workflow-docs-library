# Browser Worker Skills

The worker must support these browser execution skills.

## Prompt-related skills
- `browser.gemini_build_prompt`
- `browser.gemini_repair_prompt`
- `browser.gemini_scene_prompt_builder`

## Image generation skills
- `browser.freepik_generate_image`
- `browser.freepik_download_selected_output`
- Optional later: `browser.higgsfield_generate_image`

## Video generation skills
- `browser.freepik_generate_video`
- `browser.kling_generate_video`
- Optional later: `browser.flow_generate_scene_video`
- Optional later: `browser.higgsfield_generate_video`

## Browser operational skills
- login/session reuse with persistent profile
- file upload
- download capture
- popup dismissal
- timeout handling
- `needs_reauth` signaling
- screenshots and traces on failure
