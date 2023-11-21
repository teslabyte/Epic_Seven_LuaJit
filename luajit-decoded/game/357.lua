ItemEventSender = {}
ItemEventSender.unique_event_key = 0

function ItemEventSender.dispatchEvent(arg_1_0)
	LuaEventDispatcher:dispatchEvent("item_event_sender.ui_update")
end

function ItemEventSender.addListener(arg_2_0, arg_2_1)
	if not arg_2_1.isValid or not arg_2_1.onUIUpdate then
		error("ITEM Event Sender Listener Must have methods 'isValid', 'onUIUpdate'.")
		
		return 
	end
	
	if arg_2_1.__unique_event_id then
		Log.d("Already Listen.")
		
		return 
	end
	
	if not arg_2_1:isValid() then
		Log.e("Add Listener, But NOT VALID TBL.")
		
		return 
	end
	
	local var_2_0 = "item_event_sender_unique_id_" .. arg_2_0.unique_event_key
	
	arg_2_1.__unique_event_id = var_2_0
	
	LuaEventDispatcher:addEventListener("item_event_sender.ui_update", LISTENER(function(arg_3_0)
		if not arg_3_0.__unique_event_id then
			Log.e("NOT UNIQUE EVENT ID : ", arg_3_0.__unique_event_id)
			
			return 
		end
		
		if not arg_3_0:isValid() then
			LuaEventDispatcher:delayRemoveEventListenerByKey(arg_3_0.__unique_event_id)
			
			arg_3_0.__unique_event_id = nil
			
			return 
		end
		
		arg_3_0:onUIUpdate()
	end, arg_2_1), var_2_0)
	
	arg_2_0.unique_event_key = arg_2_0.unique_event_key + 1
end
