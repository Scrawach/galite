> [!WARNING]
> WORK IN PROGRESS

# GALite

Lightweight addon for working with GameAnalytics via REST API written in GDScript.

# Features

# Usage

## Configuration

Download plugin and enable it in ProjectSettings. It's create GALite autoload. Make sure that GALite exist in autoload list.

## Initialization

```gdscript
# Create GALiteProperties and setup these fields:
var properties := GALiteProperties.new()
properties.game_key = "5c6bcb5402204249437fb5a7a80a4959"
properties.secret_key = "16813a12f718bc5c620f56944e1abc3ea13ccbac"
properties.user_id = "test_user_0" # it's should be generated and stored in local db
properties.session_id = "de305d54-75b4-431b-adb2-eb6b9e546014" # it's should be generated
properties.session_num = 1 # it's should be stored in local db
properties.business_transaction_num = 1 # it's should be stored in local db

# Initialize autoload GALite with new properties:
GALite.initialize(properties)
```

If you want to check addon, you can use the [sandbox](https://docs.gameanalytics.com/integrations/api/setup#sandbox) properties.

```gdscript
var properties := GALiteProperties.make_sandbox()
GALite.initialize(properties)
```

## Request

After initialization you can send request. In first, request init packet:

```gdscript
await GALite.request_init_async()
```

Create event and request is as single:

```gdscript
var progression_event := GAProgressionEvent.start("World05")
await GALite.request_async(progression_event)
```

Or as group of events:

```gdscript
var progression_event := GAProgressionEvent.start("World05")
var design_event := GADesignEvent.new("GamePlay:kill:goblin")
await GALite.request_group_async([progression_event, design_event])
```

Other [examples](https://github.com/Scrawach/galite/tree/master/addons/galite/examples)

> [!WARNING]
> Events are sent immediately! If you want to achieve deferred sending, implement proxy with events cache and use request group from GALite API when you need it.

## Events

Many events has builder method. It's a little bit more safety, so use it.

```gdscript
# instead:
var bad_start := GAProgressionEvent.new("start", "world05")

# use
var good_start := GAProgressionEvent.start("World05")
```

### User events

```gdscript
# Start session:
GAUserEvent.session_start()

# End session with 5 seconds duration
GAUserEvent.session_end(5)
```

### Progression events

```gdscript
# Start World05 level event:
GAProgressionEvent.start("World05")

# Failed World05 level with score 42 (not required)
GAProgressionEvent.fail("World05").with_score(42)

# Completed World05 level with attempt numbers (not required)
GAProgressionEvent.complete("World05").with_attempt_number(3)
```

### Business events

```gdscript
# Send default business event:
GABusinessEvent.new("BlueGemsPack:CustomGem0", 50, "USD")

# Setup not required field with place, where it's purchased:
GABusinessEvent.new("BlueGemsPack:CustomGem0", 10, "USD").purchased_from("event_example")

# Setup not required filed with shop receipt:
GABusinessEvent.new("BlueGemsPack:CustomGem1", 50, "USD").with_receipt("google", "[RECEIPT]", "[SIGNATURE]")
```

### Resource events

```gdscript
# Sink item values represent what the virtual currency was spent on.
GAResourceEvent.sink("gold", "boost", "rainbowBoost", 10)

# Source item values represent in what way the virtual currency was earned.
GAResourceEvent.source("gold", "mine", "mineBoost", 15)
```

### Design events

```gdscript
GADesignEvent.new("GamePlay:kill:goblin")
GADesignEvent.new("GamePlay:heal:goblin")
GADesignEvent.new("GamePlay:kill:orc")
```

### Error events

```gdscript
GAErrorEvent.debug("test debug message")
GAErrorEvent.info("test info message")
GAErrorEvent.warning("test warning message")
GAErrorEvent.error("test error message")
GAErrorEvent.critical("test critical message")
```

### Ads events

```gdscript
GAAdEvent.new("sdk_name", "placement", GAAdEvent.Type.VIDEO, GAAdEvent.Action.CLICKED)
GAAdEvent.new("sdk_name", "placement", GAAdEvent.Type.REWARDED_VIDEO, GAAdEvent.Action.SHOW)
```
