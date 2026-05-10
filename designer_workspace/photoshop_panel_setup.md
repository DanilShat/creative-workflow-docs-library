# Photoshop panel — designer setup

This walks you through getting the **Creative Workflow Assistant** panel running inside Photoshop. The panel is the in-app chat surface; you ask for small tweaks while editing and the agent answers.

> **Status:** The panel talks to a local gateway that routes to Ollama first and escalates to Claude when needed. The panel can display typed actions, but real Photoshop document editing still needs validation on a real Photoshop install before we call it live.

## What you need

- Windows 10/11
- **Photoshop 2024 (24.0+)** or newer
- The **UXP Developer Tool** — free download from Adobe Creative Cloud (search "UXP" in the app marketplace)
- The `creative-workflow-worker` repo cloned and installed (see worker repo README)
- 5 minutes

## Step 1 — Start the gateway

The gateway is a small local HTTP service. The panel calls it on `127.0.0.1:8765`.

```powershell
cd <worker-repo-root>
.\scripts\start_agent_gateway.ps1
```

Leave that terminal open. Open a second one and verify:

```powershell
curl http://127.0.0.1:8765/health
# Expected: {"status":"ok","stage":"B2.2"}
```

## Step 2 — Enable Photoshop Develop mode

Photoshop only loads unsigned plugins (which we have during development) when Develop mode is on.

1. Open **Photoshop**
2. **Edit → Preferences → Plugins** (Windows) — check **Enable Developer Mode for Plugins**
3. Restart Photoshop

## Step 3 — Load the panel via UXP Developer Tool

1. Open **UXP Developer Tool**
2. Click **Add Plugin**
3. Browse to:
   ```
   <worker-repo-root>\dcc\photoshop_uxp_plugin\manifest.json
   ```
4. Select it. The plugin appears in the UDT list as "Creative Workflow Assistant".
5. Click **Load** (the play-button icon next to the plugin)
6. Switch to Photoshop. Open **Plugins → Creative Workflow Assistant**.

The panel docks on the right by default. You can drag it anywhere.

## Step 4 — Smoke test

In the panel:

1. Top-right pill should say **online** (green). If it says **gateway offline**, your gateway isn't running — go back to Step 1.
2. The strip below the header should show your active document name. If you have no document open it'll say "no document open".
3. Type something in the box — *"crop tighter on the right"* — and hit **Send**.
4. You should see:
   - Your message in blue (right-aligned)
   - The agent's reply in grey (left-aligned), confirming it received your message and document context
   - A green code-pill when the gateway returns a typed action, plus a routed-to badge (`ollama`, `claude`, or `rejected`)

That confirms the round-trip works. Treat actual document editing as a manual validation step until a real Photoshop action has been exercised safely.

## Troubleshooting

- **"gateway offline" pill won't go green.** The gateway isn't running, or it's running on a different port. Check the terminal from Step 1 for errors. Try `curl http://127.0.0.1:8765/health` — if that fails, the gateway isn't listening.
- **Plugin doesn't load — "manifest version not supported"** — your Photoshop is older than 2024. Upgrade or change `manifest.json`'s `manifestVersion` to match your Photoshop version (older versions used 4 instead of 5).
- **Plugin loads but the panel is blank.** Open UXP Developer Tool, click **Debug** next to the plugin — Chrome DevTools opens, check the console for JS errors.
- **`require("photoshop")` errors in the console.** That's expected if you opened the plugin's HTML in a regular browser. The `photoshop` API only exists inside the UXP runtime. Run it from Photoshop, not from a browser.
- **Network requests fail with "permission denied".** The manifest's `requiredPermissions.network.domains` must list the gateway address. Default is `localhost:8765` and `127.0.0.1:8765`; if you changed the port, edit `manifest.json` and reload the plugin.

## What's next

Next hardening work is to execute validated panel actions through the Photoshop UXP APIs, package the plugin as `.ccx`, and record action results back through the gateway.

If you want to read about how it's all going to fit together, see `codex/50_gate_b_b2_photoshop_panel_spec.md` and the architecture diagram at `docs/diagrams/gate_b2_architecture.svg`.
