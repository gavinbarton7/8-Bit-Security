---
name: prompt-injection-filter
description: "Scan inbound messages for prompt-injection patterns; flag, annotate, and log"
metadata:
  {
    "openclaw":
      {
        "emoji": "🛡️",
        "events": ["message:received"]
      }
  }
---

# Prompt Injection Filter Hook

Scans every inbound message for seven categories of prompt-injection / jailbreak patterns before the LLM sees the content. Implements a **flag + annotate** strategy:

- **All matches are logged** as JSON lines to `~/.openclaw/logs/injection-flags.jsonl`
- **Annotation is prepended** to the message body so the LLM receives a heightened-skepticism header along with the original user text
- **User is notified** in the channel if 3+ pattern categories fire on one message

## Detected patterns

1. **Instruction override** — `ignore previous/all/above instructions`, `disregard your instructions`
2. **Persona switch** — `you are now`, `pretend to be`, `act as`, `roleplay as` when combined with identity phrases
3. **Fake role prefix** — `system:`, `admin:`, `developer:`, `[INST]`, `<|im_start|>`
4. **Safety bypass** — `bypass`/`disable`/`override` combined with `safety`/`guidelines`/`rules`/`restrictions`
5. **Encoded payload** — long (≥80-char) base64 or hex blocks
6. **Unicode tag steganography** — characters in the U+E0000–U+E007F range (hidden ASCII)
7. **Tool-call spoof** — attempts to inject synthetic tool-call JSON/XML (`<tool_call>`, `"function_call":`)

## Evidence

Every flag writes a JSONL record:

```json
{"timestamp":"2026-04-22T10:30:00.000Z","sessionKey":"agent:main:main","senderId":"<id>","channelId":"<id>","patterns":["instruction_override","persona_switch"],"contentPreview":"ignore previous instructions and..."}
```

## Disabling

```bash
openclaw hooks disable prompt-injection-filter
```
