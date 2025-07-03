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

### User events

```gdscript
# Start session:
await GALite.request_async(GAUserEvent.session_start())

# End session with 5 seconds duration
await GALite.request_async(GAUserEvent.session_end(5))
```

### Business events

```gdscript
# Send default business event:
await GALite.request_async(GABusinessEvent.new("BlueGemsPack:CustomGem0", 50, "USD"))

# Setup not required field with place, where it's purchased:
await GALite.request_async(GABusinessEvent.new("BlueGemsPack:CustomGem0", 10, "USD").purchased_from("event_example"))

# Setup not required filed with shop receipt:
await GALite.request_async(GABusinessEvent.new("BlueGemsPack:CustomGem1", 50, "USD").with_receipt("google", "[RECEIPT]", "[SIGNATURE]"))
```

### Resource events

```gdscript
# Sink item values represent what the virtual currency was spent on.
await GALite.request_async(GAResourceEvent.sink("gold", "boost", "rainbowBoost", 10))

# Source item values represent in what way the virtual currency was earned.
await GALite.request_async(GAResourceEvent.source("gold", "mine", "mineBoost", 15))
```

### Design events

```gdscript
await GALite.request_async(GADesignEvent.new("GamePlay:kill:goblin"))
await GALite.request_async(GADesignEvent.new("GamePlay:heal:goblin"))
await GALite.request_async(GADesignEvent.new("GamePlay:kill:orc"))
```

### Error events

```gdscript
await GALite.request_async(GAErrorEvent.debug("test debug message"))
await GALite.request_async(GAErrorEvent.info("test info message"))
await GALite.request_async(GAErrorEvent.warning("test warning message"))
await GALite.request_async(GAErrorEvent.error("test error message"))
await GALite.request_async(GAErrorEvent.critical("test critical message"))
```

### Ads events

```gdscript
await GALite.request_async(GAAdEvent.new("sdk_name", "placement", GAAdEvent.Type.VIDEO, GAAdEvent.Action.CLICKED))
await GALite.request_async(GAAdEvent.new("sdk_name", "placement", GAAdEvent.Type.REWARDED_VIDEO, GAAdEvent.Action.SHOW))
```
