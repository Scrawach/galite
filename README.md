> [!WARNING]
> WORK IN PROGRESS

# GALite

Lightweight addon for working with GameAnalytics via REST API written in GDScript.

## Getting Started

```gdscript
var properties := GAProperties.make_default("[GAME_KEY]", "[SECRET_KEY]")
GALite.initialize(properties)

await GALite.request_init()
await GALite.request(GAUserEvent.session_start())
await GALite.request(GAProgressionEvent.start("World05"))
await GALite.request(GAProgressionEvent.fail("World05").with_score(42))
await GALite.request(GAProgressionEvent.complete("World05").with_attempt_number(3))
await GALite.request(GAUserEvent.session_end(5))
```

## Events

### Progression Events Example

```gdscript
await GALite.request(GAProgressionEvent.start("Level01"))

await GALite.request(GAProgressionEvent.fail("Level01").with_score(42))

await GALite.request(GAProgressionEvent.complete("Level01").with_attempt_number(4))
```
