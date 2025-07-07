class_name GABusinessEvent
extends GAEvent

var event_id: String # [itemType]:[itemId], in example: BlueGemPack:blue_gems_50
var amount: int
var currency: String

var cart_type
var receipt_info

func _init(event_id: String, amount: int, currency: String) -> void:
	super._init()
	self.event_id = event_id
	self.amount = amount
	self.currency = currency

func serialize(properties: GALiteProperties) -> Dictionary:
	properties.business_transaction_num += 1
	
	var required_data := {
		CATEGORY: "business",
		"event_id": event_id,
		"amount": amount,
		"currency": currency,
		"transaction_num": properties.business_transaction_num
	}
	
	if cart_type:
		required_data["cart_type"] = cart_type
	
	if receipt_info:
		required_data["receipt_info"] = receipt_info
	
	return required_data

func purchased_from(cart_type: String) -> GABusinessEvent:
	self.cart_type = cart_type
	return self

func with_receipt(store: String, receipt: String, signature: String) -> GABusinessEvent:
	self.receipt_info = {
		"store": store,
		"receipt": receipt,
		"signature": signature
	}
	return self
