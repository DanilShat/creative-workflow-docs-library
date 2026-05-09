# Project Structure

```text
lcwo/
  app/
  ui/
  domain/
  application/
  workflows/
  integrations/
  persistence/
  prompts/
  utils/
  tests/
```

## Notes
- keep vendor-specific selectors inside `integrations/browser/providers/`;
- keep workflow nodes vendor-agnostic;
- keep file storage separate from DB persistence;
- prefer explicit service boundaries over “god classes”.
