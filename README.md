### WORK IN PROGRESS

# GALite

Lightweight addon for working with GameAnalytics via REST API written in GDScript.

## Events

### Progression Events Example

```gdscript
await GALite.request(GAProgressionEvent.start("Level01"))

await GALite.request(GAProgressionEvent.fail("Level01").with_score(42))

await GALite.request(GAProgressionEvent.complete("Level01").with_attempt_number(4))
```
