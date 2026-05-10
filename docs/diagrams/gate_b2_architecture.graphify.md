# Gate B2 — Architecture Diagram (graphify source)

This file is the **source of truth** for the B2 architecture diagram. Paste the structure below into [graphify](https://graphify.io) (or any node/edge tool you prefer) and export to:

```
creative_workflow_docs_library/docs/diagrams/gate_b2_architecture.svg
```

The exported SVG is referenced from:

- `creative_workflow_docs_library/codex/50_gate_b_b2_photoshop_panel_spec.md`
- `creative_workflow_worker/dcc/photoshop_uxp_plugin/README.md`

Re-export when the architecture changes. Keep the node IDs stable so existing references survive edits.

---

## Nodes

| ID | Label (line 1) | Sub-label (line 2) | Group | Shape |
|---|---|---|---|---|
| `designer` | Designer | (human) | Edge | person |
| `ps` | Photoshop | host app | Designer laptop | rect |
| `panel` | Creative Workflow Assistant | UXP panel | Designer laptop | rect (rounded) |
| `gateway` | Agent Gateway | FastAPI · 127.0.0.1:8765 | Designer laptop | rect (rounded, accent) |
| `ollama` | Ollama | local LLM (~7-13B) | Designer laptop | rect |
| `claude` | Claude API | cloud | External | cloud |
| `operator` | Operator | FastAPI · :8000 | Operator laptop | rect |

## Edges

| From | To | Label | Style |
|---|---|---|---|
| `designer` | `ps` | "edits in" | solid |
| `ps` | `panel` | "hosts" | solid (containment) |
| `designer` | `panel` | "types tweak" | dotted (interaction) |
| `panel` | `gateway` | "POST /chat<br/>POST /health" | solid (HTTP) |
| `gateway` | `ollama` | "1. ask first" | solid (numbered) |
| `gateway` | `claude` | "2. escalate when needed" | dashed (numbered) |
| `panel` | `ps` | "executes action via UXP API" | solid (B2.2+) |
| `gateway` | `operator` | "(B2.3+) audit log" | dashed |

## Groups (containers)

- **Designer laptop** — contains: `ps`, `panel`, `gateway`, `ollama`. Bordered, light-grey fill, label "Designer laptop".
- **External** — contains: `claude`. Bordered with dotted line, label "Cloud".
- **Operator laptop** — contains: `operator`. Bordered, light-grey fill, separate from designer laptop group.

## Annotations (callouts)

Place near `gateway`:

> **Routing logic**
> 1. Send to Ollama with structured-output prompt
> 2. If Ollama returns valid action → return it
> 3. If Ollama returns `needs_claude: true` → escalate
> 4. Validate action against allowlist before returning

Place near `panel`:

> Built with HTML/CSS/JS in UXP runtime. Loaded in Photoshop via UXP Developer Tool (Develop mode).

## Style notes

- Use a 12-column horizontal flow: designer → ps/panel → gateway → ollama/claude.
- Photoshop `ps` should *visually contain* the `panel` node (panel sits inside the PS rectangle).
- Color the `gateway` node accent (e.g. teal) — it's the central decision point.
- Use a different (warmer) color for the `claude` cloud to signal "off the laptop, costs money".
- Numbered edges (1, 2) on the gateway → llm fan-out so the routing order is visually obvious.

## Out of scope for this diagram

- The MCP server / Claude Desktop chat path — that's the B0/B1 surface. Keep it on a separate diagram (`gate_b0_b1_architecture.graphify.md`, not yet written).
- Worker daemon / browser automation. That's Gate A territory.
