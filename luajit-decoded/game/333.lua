local var_0_0 = 300

ReviewCommon = ReviewCommon or {}

function ReviewCommon.pageScrollViewItem(arg_1_0, arg_1_1)
	local var_1_0 = load_dlg("hero_vote_item", true, "wnd")
	
	if_set_visible(var_1_0, "page_next", true)
	if_set_visible(var_1_0, "card", false)
	table.push(arg_1_0.ScrollViewItems, {
		item = {
			page = arg_1_1
		},
		control = var_1_0
	})
	arg_1_0.scrollview:addChild(var_1_0)
	arg_1_0:arrangeScrollViewItems(nil, nil, true)
end

function ReviewCommon.insertScrollViewItems(arg_2_0, arg_2_1, arg_2_2)
	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		item = {
			id = tostring(#arg_2_0.ScrollViewItems + 1)
		}
		
		local var_2_0 = arg_2_0:getScrollViewItem(iter_2_1)
		
		table.push(arg_2_0.ScrollViewItems, {
			item = iter_2_1,
			control = var_2_0
		})
		arg_2_0.scrollview:addChild(var_2_0)
	end
	
	arg_2_0:arrangeScrollViewItems(nil, nil, arg_2_2)
end

function ReviewCommon.getScrollViewItem(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.comment or ""
	
	if arg_3_1.user_id == 0 then
		var_3_0 = json.decode(arg_3_1.comment)[getUserLanguage()]
		
		if var_3_0 == "" then
			return 
		end
	end
	
	local var_3_1 = load_dlg("hero_vote_item", true, "wnd")
	
	if_set_visible(var_3_1, "page_next", false)
	if_set_visible(var_3_1, "card", true)
	if_set_visible(var_3_1, "n_gm", false)
	if_set_visible(var_3_1, "n_best", false)
	
	local var_3_2 = arg_3_1.user_id == Account:getUserId() and not arg_3_0.vars.is_popup
	
	if arg_3_1.user_id == 0 and arg_3_0.vars.page == 1 then
		local var_3_3 = {
			DB("gm_info", getUserLanguage(), {
				"name",
				"face"
			})
		}
		local var_3_4 = var_3_1:getChildByName("n_gm")
		
		if_set_visible(var_3_1, "n_common", false)
		if_set_visible(var_3_1, "n_gm", true)
		if_set(var_3_4, "txt_name", T(var_3_3[1]))
		if_set(var_3_4, "txt_date", T("time_dot_y_m_d", timeToStringDef({
			preceding_with_zeros = true,
			time = arg_3_1.created
		})))
		
		local var_3_5 = var_3_4:getChildByName("mob_icon")
		
		if_set_visible(var_3_4, "mob_icon", true)
		if_set_visible(var_3_5, "frame_bg", true)
		if_set_visible(var_3_5, "face", true)
		if_set_visible(var_3_5, "frame", true)
		
		if var_3_3[2] then
			if_set_sprite(var_3_5, "face", "face/" .. var_3_3[2] .. "_s.png")
		end
		
		if_set_color(var_3_1, "txt_contents", tocolor("#337ac3"))
		
		if var_3_0 then
			if_set(var_3_1, "txt_contents", urldecode(var_3_0))
		end
	else
		local var_3_6 = false
		
		if arg_3_0.vars.order and arg_3_1.score and arg_3_0.vars.order == 1 and arg_3_1.score >= 500020 then
			arg_3_0.vars.comment_count = arg_3_0.vars.comment_count or 1
			
			if arg_3_0.vars.comment_count < 3 then
				arg_3_0.vars.comment_count = arg_3_0.vars.comment_count + 1
				var_3_6 = true
			end
		end
		
		if_set(var_3_1:getChildByName("card"):getChildByName("n_best"), "txt_name", arg_3_1.name)
		if_set(var_3_1:getChildByName("card"):getChildByName("n_best"), "txt_date", T("time_dot_y_m_d", timeToStringDef({
			preceding_with_zeros = true,
			time = arg_3_1.created
		})))
		if_set_visible(var_3_1, "n_common", not var_3_6)
		if_set_visible(var_3_1:getChildByName("card"), "n_best", var_3_6)
		UIUtil:updateTextWrapMode(var_3_1:getChildByName("txt_contents"), urldecode(var_3_0), 20)
		set_ellipsis_label2(var_3_1:getChildByName("txt_contents"), urldecode(var_3_0), 2, 10)
		if_set_color(var_3_1, "txt_contents", tocolor("#888888"))
		
		arg_3_1.is_best_comment = var_3_6
		
		local var_3_7 = var_3_1:getChildByName("btn_delete")
		
		if get_cocos_refid(var_3_7) then
			var_3_7:setVisible(var_3_2)
			
			var_3_7.comment_id = arg_3_1.comment_id
		end
	end
	
	if_set(var_3_1, "txt_name", arg_3_1.name)
	if_set(var_3_1, "txt_date", T("time_dot_y_m_d", timeToStringDef({
		preceding_with_zeros = true,
		time = arg_3_1.created
	})))
	arg_3_0:updateCommentButtons(var_3_1, arg_3_1.comment_id, arg_3_1.like_count, arg_3_1.dislike_count, arg_3_1.my_like)
	
	local var_3_8 = arg_3_1.unit_info or {}
	local var_3_9 = var_3_8.unit
	
	if not var_3_8.equips then
		local var_3_10 = {}
	end
	
	local var_3_11 = var_3_1:getChildByName("equip_share")
	local var_3_12 = var_3_1:getChildByName("btn_vote_ex")
	
	if var_3_9 and not table.empty(var_3_9) then
		if_set_visible(var_3_11, nil, true)
		
		var_3_12.unit_info = var_3_8
		
		if var_3_2 and not var_3_11.move_pos then
			var_3_11.move_pos = true
			
			var_3_11:setPositionX(var_3_11:getPositionX() - 54)
		end
	else
		if_set_visible(var_3_11, nil, false)
	end
	
	var_3_12.review_data = arg_3_1
	
	return var_3_1
end

function ReviewCommon.updateCommentButtons(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0
	local var_4_1
	
	if_set_visible(arg_4_1, "btn_good_checked", false)
	if_set_visible(arg_4_1, "btn_good_normal", false)
	
	if arg_4_5 == 1 then
		var_4_0 = arg_4_1:getChildByName("btn_good_checked")
	else
		var_4_0 = arg_4_1:getChildByName("btn_good_normal")
	end
	
	arg_4_3 = math.max(0, arg_4_3)
	arg_4_4 = math.max(0, arg_4_4)
	
	var_4_0:setVisible(true)
	
	var_4_0:getChildByName("btn_good").comment_id = arg_4_2
	
	if_set(var_4_0, "label", arg_4_3)
end

function ReviewCommon.onSelectScrollViewItem(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_2.item and arg_5_2.item.page then
		local var_5_0 = tonumber(arg_5_2.item.page)
		
		if var_5_0 > 1 then
			arg_5_0:removeScrollViewItemAt(arg_5_1)
			query("review_comment_list", {
				code = arg_5_0.vars.code or arg_5_0.infos.code,
				p = var_5_0,
				o = arg_5_0.vars.order,
				my = arg_5_0.vars.my,
				r = arg_5_0.vars.review_type
			})
		end
	end
end

function ReviewCommon.updateTabs(arg_6_0, arg_6_1)
	arg_6_0.open_tab = arg_6_1
	
	local var_6_0 = arg_6_0.vars.review_type
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0.tabs) do
		if iter_6_0 == arg_6_0.open_tab then
			if arg_6_0.open_tab == "btn_category_after_update" then
				arg_6_0.vars.review_type = 1
			elseif arg_6_0.open_tab == "btn_category_2week" then
				arg_6_0.vars.review_type = 2
			elseif arg_6_0.open_tab == "btn_category_total" then
				arg_6_0.vars.review_type = 3
			end
			
			local var_6_1 = arg_6_0.tabs[iter_6_0]
			
			if get_cocos_refid(var_6_1) then
				var_6_1:setVisible(true)
				
				if get_cocos_refid(var_6_1.txt) then
					var_6_1.txt:setOpacity(255)
				end
			end
		else
			local var_6_2 = arg_6_0.tabs[iter_6_0]
			
			if get_cocos_refid(var_6_2) then
				var_6_2:setVisible(false)
				
				if get_cocos_refid(var_6_2.txt) then
					var_6_2.txt:setOpacity(76.5)
				end
			end
		end
	end
	
	if arg_6_0.vars.review_type == var_6_0 then
		return 
	end
	
	arg_6_0:clearScrollViewItems()
	
	arg_6_0.vars.comment_count = 1
	arg_6_0.vars.page = 1
	
	query("review_comment_list", {
		code = arg_6_0.vars.code or arg_6_0.infos.code,
		p = arg_6_0.vars.page,
		o = arg_6_0.vars.order,
		r = arg_6_0.vars.review_type,
		my = arg_6_0.show_my_review
	})
end

function ReviewCommon.showCommentList(arg_7_0, arg_7_1)
	arg_7_0.vars.order = arg_7_1.o
	arg_7_0.vars.my = arg_7_1.my
	arg_7_0.vars.page = arg_7_1.p
	
	if tonumber(arg_7_1.my) == 1 then
		if_set(arg_7_0.vars.left_wnd, "txt_my_estimate", T("review_all"))
	else
		if_set(arg_7_0.vars.left_wnd, "txt_my_estimate", T("review_my"))
	end
	
	local var_7_0
	local var_7_1
	
	if #arg_7_1.c > 0 then
		if arg_7_1.p == 1 then
			arg_7_0:createScrollViewItems(arg_7_1.c)
			arg_7_0:pageScrollViewItem(arg_7_1.p + 1)
		else
			local var_7_2, var_7_3 = arg_7_0:getInnerSizeAndPos()
			
			var_7_0 = var_7_2
			
			arg_7_0:insertScrollViewItems(arg_7_1.c, true)
			arg_7_0:pageScrollViewItem(arg_7_1.p + 1)
			
			local var_7_4, var_7_5 = arg_7_0:getInnerSizeAndPos()
			
			var_7_1 = var_7_3.height - var_7_5.height
		end
	elseif #arg_7_1.c == 0 and arg_7_1.p == 1 then
		arg_7_0:createScrollViewItems({})
	end
	
	if arg_7_1.p == 1 then
		arg_7_0.scrollview:scrollToPercentVertical(0, 0.5, false)
	elseif var_7_0 then
		var_7_0.y = var_7_0.y + var_7_1
		
		arg_7_0.scrollview:setInnerContainerPosition(var_7_0)
		arg_7_0.scrollview:forceDoLayout()
		arg_7_0.scrollview:stopAutoScroll()
	else
		arg_7_0.scrollview:scrollToPercentVertical(100, 0.5, false)
	end
end

function ReviewCommon.toggleSortMenus(arg_8_0, arg_8_1)
	if arg_8_1 == nil then
		arg_8_0.vars.sort_menu_find_toggle = not arg_8_0.vars.sort_menu_find_toggle
	else
		arg_8_0.vars.sort_menu_find_toggle = arg_8_1
	end
	
	if_set_visible(arg_8_0.vars.wnd, "layer_sort", arg_8_0.vars.sort_menu_find_toggle)
	
	local var_8_0 = arg_8_0.vars.wnd:getChildByName("btn_sort")
	local var_8_1 = arg_8_0.vars.wnd:getChildByName("layer_sort")
	local var_8_2 = var_8_1:getChildByName("sort_" .. arg_8_0.vars.sort_menu_find_index)
	local var_8_3 = var_8_2:getChildByName("label")
	
	if_set(arg_8_0.vars.wnd, "txt_sort", var_8_3:getString())
	
	if arg_8_0.vars.sort_menu_find_toggle then
		local var_8_4, var_8_5 = var_8_2:getPosition()
		
		var_8_1:getChildByName("sort_cursor"):setPosition(var_8_4, var_8_5)
		var_8_1:getChildByName("icon_order"):setPosition(var_8_4 + 90, var_8_5)
	end
end

function ReviewCommon.selectSortMenu(arg_9_0, arg_9_1)
	arg_9_0.vars.sort_menu_find_index = arg_9_1
	
	arg_9_0:toggleSortMenus(false)
	
	arg_9_0.vars.order = arg_9_1
	
	query("review_comment_list", {
		p = 1,
		code = arg_9_0.vars.code or arg_9_0.infos.code,
		o = arg_9_0.vars.order,
		my = arg_9_0.vars.my,
		r = arg_9_0.vars.review_type
	})
end

Review = Review or {}

copy_functions(ScrollView, Review)
copy_functions(ReviewCommon, Review)

function MsgHandler.review(arg_10_0)
	Review.ready = true
	ReviewPreviewPopup.ready = false
	
	table.merge(Review.infos, arg_10_0)
	
	Review.vars.comment_count = 1
	Review.infos.update_data = DB("character_reference", Review.infos.code, {
		"balance_update"
	})
	
	if Review.infos.update_data then
		Review.vars.review_type = 1
	else
		Review.infos.block_tab = true
		Review.vars.review_type = 2
	end
	
	local var_10_0 = Review.vars.review_type == 2 and 1 or 0
	
	query("review_star_score", {
		code = Review.infos.code,
		b = var_10_0
	})
	
	if Review.open_on_detail and UnitMain.vars and get_cocos_refid(UnitMain.vars.base_wnd) then
		UnitMain:setMode("Review", Review.infos)
	elseif UnitMain:getMode() and UnitMain:getMode() ~= "Review" and UnitMain.vars and get_cocos_refid(UnitMain.vars.base_wnd) then
		UnitInfosReview:onReceive(arg_10_0)
	else
		Review:show(Review.infos)
	end
end

function MsgHandler.review_star(arg_11_0)
	Review:updateStarPopup(arg_11_0)
end

function MsgHandler.review_star_score(arg_12_0)
	Review:updateStarPopup(arg_12_0)
end

function ErrHandler.review_star(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_1 == "already_today_star_review" then
		Review:closeStarPopup()
		Dialog:msgBox(T("hero_vote_cooltime"))
	elseif arg_13_1 == "same_star_review" then
		Review:closeStarPopup()
		Dialog:msgBox(T("same_star_review"))
	else
		on_net_error(arg_13_0, arg_13_1, arg_13_2)
	end
end

function MsgHandler.review_comment_review(arg_14_0)
	Review:updateReviewCommentReview(arg_14_0)
	ShareUnitPopup:refreshCommentButtons(arg_14_0)
	ReviewCommentPopup:refreshCommentButtons(arg_14_0)
end

function ErrHandler.review_comment_review(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_1 == "already_today_review" then
		Dialog:msgBox(T("hero_vote_talk_cooltime"))
	elseif arg_15_1 == "comment_not_found" then
		balloon_message_with_sound("err_msg_hero_review_unavailable")
	else
		on_net_error(arg_15_0, arg_15_1, arg_15_2)
	end
end

function MsgHandler.review_comment_list(arg_16_0)
	if ReviewPreviewPopup.ready then
		ReviewPreviewPopup:showCommentList(arg_16_0)
	else
		Review.vars.comment_count = 1
		
		Review:showCommentList(arg_16_0)
		Review:reUpdateCommentList()
	end
end

function MsgHandler.review_comment(arg_17_0)
	Review:resultWriteComment(arg_17_0, true)
end

function MsgHandler.remove_review_comment(arg_18_0)
	balloon_message_with_sound("msg_hero_review_deleted")
	Review:resultWriteComment(arg_18_0)
end

function ErrHandler.remove_review_comment(arg_19_0, arg_19_1, arg_19_2)
	if arg_19_1 == "comment_not_found" then
		balloon_message_with_sound("err_msg_hero_review_unavailable")
	else
		on_net_error(arg_19_0, arg_19_1, arg_19_2)
	end
end

function Review.getHighZodiac(arg_20_0)
	local var_20_0 = arg_20_0.infos.code
	
	if is_mer_series(var_20_0) then
		var_20_0 = change_mer_code()
	end
	
	local var_20_1 = Account:getUnitsByCode(var_20_0)
	
	if var_20_1 then
		local var_20_2 = 0
		
		for iter_20_0, iter_20_1 in pairs(var_20_1) do
			var_20_2 = math.max(var_20_2, iter_20_1:getZodiacGrade())
		end
		
		return var_20_2
	end
	
	return -1
end

function HANDLER.hero_vote(arg_21_0, arg_21_1)
	if ReviewPreviewPopup.ready then
		return 
	end
	
	local var_21_0 = arg_21_0:getName()
	
	if var_21_0 == "btn_point" then
		if Review.vars.is_moonlight_destiny then
			balloon_message_with_sound("character_mc_cannot_opinion")
			
			return 
		end
		
		if not Review.vars.unit:isPromotionUnit() and Review:getHighZodiac() < 3 then
			balloon_message_with_sound("msg_hero_vote_limit")
			
			return 
		end
		
		Review:openStarPopup()
	elseif var_21_0 == "btn_write" or var_21_0 == "btn_comment" then
		if Review.vars.is_moonlight_destiny then
			balloon_message_with_sound("character_mc_cannot_opinion")
			
			return 
		end
		
		if not Review.vars.unit:isPromotionUnit() and Review:getHighZodiac() < 3 then
			balloon_message_with_sound("msg_hero_vote_limit")
			
			return 
		end
		
		Review:writeComment()
	elseif var_21_0 == "btn_view_my" then
		Review:showMyComments()
	elseif var_21_0 == "btn_back" then
		Review:close()
	elseif var_21_0 == "btn_sort" then
		Review:toggleSortMenus()
	elseif var_21_0 == "btn_close_sort" then
		Review:toggleSortMenus(false)
	elseif var_21_0 == "sort_1" then
		Review:selectSortMenu(1)
	elseif var_21_0 == "sort_2" then
		Review:selectSortMenu(2)
	elseif string.find(var_21_0, "btn_dedi") then
		Review:showDevoteDetail()
	elseif string.starts(var_21_0, "btn_category_") then
		if Review.infos.block_tab and var_21_0 == "btn_category_after_update" then
			balloon_message_with_sound("msg_hero_vote_no_update")
			
			return 
		else
			Review:updateTabs(var_21_0)
		end
	elseif var_21_0 == "check_box_my" or var_21_0 == "btn_view_vote" then
		Review:showMyReview(var_21_0 == "btn_view_vote")
		query("review_comment_list", {
			p = 1,
			code = Review.infos.code,
			o = Review.vars.order,
			my = Review.show_my_review,
			r = Review.vars.review_type
		})
	elseif var_21_0 == "check_box_before" then
		if Review.infos.block_tab then
			arg_21_0:setSelected(false)
			balloon_message_with_sound("msg_hero_vote_no_update")
			
			return 
		else
			query("review_star_score", {
				code = Review.infos.code,
				b = arg_21_0:isSelected() and 1 or 0
			})
		end
	elseif var_21_0 == "btn_equip_arti" then
		if ContentDisable:byAlias("eq_arti_statistics") then
			balloon_message(T("content_disable"))
		elseif Review and Review.vars then
			Stove:openHeroEquipStatisticsPage(Review.vars.unit.db.code, STOVE_HERO_URL_PTYPE.hero_artifact)
		end
	end
end

HANDLER.hero_detail_vote_review = HANDLER.hero_vote
HANDLER.hero_detail_vote = HANDLER.hero_vote

function HANDLER.hero_vote_add(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0:getName()
	
	if var_22_0 == "btn_cancel" then
		Review:closeStarPopup()
	elseif var_22_0 == "btn_ok" then
		Review:reviewStarPopup()
	elseif var_22_0 == "btn_p1" then
		Review:setStarPopup(1)
	elseif var_22_0 == "btn_p2" then
		Review:setStarPopup(2)
	elseif var_22_0 == "btn_p3" then
		Review:setStarPopup(3)
	elseif var_22_0 == "btn_p4" then
		Review:setStarPopup(4)
	elseif var_22_0 == "btn_p5" then
		Review:setStarPopup(5)
	end
end

function HANDLER.hero_vote_item(arg_23_0, arg_23_1)
	if arg_23_1 == "btn_vote_ex" then
		if arg_23_0.unit_info then
			ShareUnitPopup:open(arg_23_0.unit_info.unit, arg_23_0.unit_info.equips, {
				is_review = true,
				review_data = arg_23_0.review_data,
				growth_boost = arg_23_0.unit_info.growth_boost,
				gb_level = arg_23_0.unit_info.gb_level
			})
		elseif arg_23_0.review_data then
			ReviewCommentPopup:open(arg_23_0.review_data)
		end
		
		return 
	elseif arg_23_1 == "btn_delete" and arg_23_0.comment_id then
		Review:deleteMyComment(arg_23_0.comment_id)
		
		return 
	end
	
	if ReviewPreviewPopup.ready then
		balloon_message_with_sound("err_cannot_rate_review_popup")
		
		return 
	end
	
	if arg_23_1 == "btn_good" then
		local var_23_0 = arg_23_0:getName()
		local var_23_1 = arg_23_0.comment_id
		local var_23_2 = 1
		
		Review:reviewComment(var_23_1, var_23_2)
	end
end

function Review.open(arg_24_0, arg_24_1)
	arg_24_0.vars = {}
	
	if arg_24_1.callback then
		arg_24_0.vars.callback = arg_24_1.callback
	end
	
	arg_24_0.ready = nil
	arg_24_0.infos = arg_24_1
	arg_24_0.vars.use_share_unit = arg_24_1 and arg_24_1.open_on_detail
	arg_24_0.vars.use_share_unit_value = false
	
	if is_enhanced_mer(arg_24_1.code) then
		arg_24_1.code = get_origin_mer()
	end
	
	arg_24_0.open_on_detail = arg_24_1.open_on_detail
	
	query("review", {
		code = arg_24_1.code
	})
	
	if SceneManager:getCurrentSceneName() == "collection" then
		TopBarNew:forcedHelp_OnOff(false)
	end
end

function Review.openStarPopup(arg_25_0)
	if Account:getCollectionUnit(arg_25_0.infos.code) == nil then
		balloon_message_with_sound("review_comment.cannot_review_no_unit")
		
		return 
	end
	
	local var_25_0 = load_dlg("hero_vote_add", true, "wnd", function()
		arg_25_0:closeStarPopup()
	end)
	
	SceneManager:getRunningPopupScene():addChild(var_25_0)
	
	arg_25_0.vars.popup = var_25_0
	arg_25_0.infos.review_my = arg_25_0.infos.review_my or {}
	arg_25_0.infos.review_my.rs = arg_25_0.infos.review_my.rs or 0
	arg_25_0.vars.popup.star = arg_25_0.infos.review_my.rs
	
	arg_25_0:setStarPopup(arg_25_0.infos.review_my.rs)
end

function Review.setStarPopup(arg_27_0, arg_27_1)
	if not arg_27_0.vars.popup then
		return 
	end
	
	if_set(arg_27_0.vars.popup, "txt_pointnow", T("rating_score", {
		score = arg_27_1
	}))
	
	for iter_27_0 = 1, 5 do
		local var_27_0 = arg_27_0.vars.popup:getChildByName("btn_p" .. iter_27_0)
		
		if arg_27_1 == iter_27_0 then
			var_27_0:loadTextures("img/_btn_small_white.png", "img/_btn_small_white_p.png")
			var_27_0:setOpacity(255)
			if_set_color(var_27_0, "label", cc.c3b(0, 0, 0))
		else
			var_27_0:loadTextures("img/_btn_small_black.png", "img/_btn_small_black_p.png")
			var_27_0:setOpacity(120)
			if_set_color(var_27_0, "label", cc.c3b(255, 255, 255))
		end
	end
	
	arg_27_0.vars.popup.star = arg_27_1
end

function Review.reviewStarPopup(arg_28_0)
	if not arg_28_0.vars.popup then
		return 
	end
	
	if Account:getCollectionUnit(arg_28_0.infos.code) == nil then
		balloon_message_with_sound("review_comment.cannot_review_no_unit")
		
		return 
	end
	
	local var_28_0 = arg_28_0.vars.popup.star
	
	if var_28_0 > 0 and arg_28_0.infos.review_my.rs ~= var_28_0 then
		query("review_star", {
			code = arg_28_0.infos.code,
			star = var_28_0
		})
	elseif arg_28_0.infos.review_my.rs == var_28_0 then
		Review:updateStarPopup({
			review_my = arg_28_0.infos.review_my
		})
	else
		arg_28_0:closeStarPopup()
	end
end

function Review.updateStarPopup(arg_29_0, arg_29_1)
	arg_29_0:closeStarPopup()
	
	if arg_29_1.review_my then
		arg_29_0.infos.review_my = arg_29_1.review_my
	end
	
	if arg_29_1.review_star then
		arg_29_0.infos.review_star = arg_29_1.review_star
	end
	
	arg_29_0:updateStarReview()
end

function Review.closeStarPopup(arg_30_0)
	if arg_30_0.vars.popup then
		BackButtonManager:pop({
			check_id = "hero_vote_add",
			dlg = arg_30_0.vars.popup
		})
		arg_30_0.vars.popup:removeFromParent()
		
		arg_30_0.vars.popup = nil
	end
end

function Review.setVisibleDefaultBackBtn(arg_31_0, arg_31_1)
	if get_cocos_refid(arg_31_0.vars.wnd) then
		arg_31_0.vars.wnd:getChildByName("btn_back"):setVisible(arg_31_1)
	end
end

function Review.updateStarReview(arg_32_0)
	local var_32_0 = 0
	local var_32_1 = 0
	
	for iter_32_0, iter_32_1 in pairs(arg_32_0.infos.review_star) do
		local var_32_2 = tonumber(iter_32_1)
		
		if iter_32_0 == "s1" then
			var_32_0 = var_32_0 + 1 * var_32_2
			var_32_1 = var_32_1 + var_32_2
		elseif iter_32_0 == "s2" then
			var_32_0 = var_32_0 + 2 * var_32_2
			var_32_1 = var_32_1 + var_32_2
		elseif iter_32_0 == "s3" then
			var_32_0 = var_32_0 + 3 * var_32_2
			var_32_1 = var_32_1 + var_32_2
		elseif iter_32_0 == "s4" then
			var_32_0 = var_32_0 + 4 * var_32_2
			var_32_1 = var_32_1 + var_32_2
		elseif iter_32_0 == "s5" then
			var_32_0 = var_32_0 + 5 * var_32_2
			var_32_1 = var_32_1 + var_32_2
		end
	end
	
	local var_32_3 = 0
	
	if var_32_1 > 0 then
		var_32_3 = var_32_0 / var_32_1
	end
	
	if_set(arg_32_0.vars.left_wnd, "txt_rating", T("rating_score", {
		score = math.round(var_32_3 * 10) / 10
	}))
	if_set(arg_32_0.vars.left_wnd, "txt_rating_count", T("rating_count", {
		count = var_32_1
	}))
end

function Review.writeComment(arg_33_0)
	if ContentDisable:byAlias("hero_review") then
		balloon_message_with_sound("msg_contents_disable_hero_review")
		
		return 
	end
	
	local function var_33_0()
		cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
		
		if Account:getCollectionUnit(arg_33_0.infos.code) == nil then
			balloon_message_with_sound("review_comment.cannot_review_no_unit")
			
			return 
		end
		
		local var_34_0 = string.trim(arg_33_0.vars.noti_info.text)
		
		if var_34_0 == nil or utf8len(var_34_0) == 0 or var_34_0 == "" then
			return 
		end
		
		if UIUtil:checkInvalidCharacter(var_34_0, true) then
			return 
		end
		
		if check_abuse_filter(var_34_0, ABUSE_FILTER.CHAT) then
			balloon_message_with_sound("invalid_input_word")
			
			return 
		end
		
		if utf8len(var_34_0) > var_0_0 then
			balloon_message_with_sound("review_comment_text_over")
			
			return 
		end
		
		local var_34_1 = arg_33_0.vars.use_share_unit_value
		local var_34_2
		local var_34_3
		local var_34_4
		
		if var_34_1 and arg_33_0.infos.uid then
			local var_34_5 = Account:getUnit(arg_33_0.infos.uid)
			
			if var_34_5 and ShareUnitUtil:checkSharableUnit(var_34_5) then
				var_34_2 = var_34_5:getUID()
				var_34_3 = var_34_5:isGrowthBoostRegistered()
				
				local var_34_6 = GrowthBoost:getInfo() or {}
				
				for iter_34_0, iter_34_1 in pairs(var_34_6) do
					if iter_34_1.reg_uid and iter_34_1.reg_uid == var_34_2 then
						var_34_4 = iter_34_1.unlock_level or 0
						
						break
					end
				end
			end
		end
		
		query("review_comment", {
			code = arg_33_0.infos.code,
			comment = urlencode(var_34_0),
			share_unit_uid = var_34_2,
			growth_boost = var_34_3,
			gb_level = var_34_4
		})
	end
	
	arg_33_0.vars.use_share_unit_value = false
	arg_33_0.vars.noti_info = arg_33_0.vars.noti_info or {}
	arg_33_0.vars.noti_info.text = ""
	arg_33_0.vars.noti_info.prev_text = ""
	
	local var_33_1, var_33_2 = Dialog:openInputBox(arg_33_0, var_33_0, {
		max_limit = var_0_0,
		info = arg_33_0.vars.noti_info,
		title = T("hero_vote_write"),
		placeholder = T("ui_chat_input_touch"),
		btn_yes_txt = T("ui_msgbox_ok"),
		use_share_unit = arg_33_0.vars.use_share_unit,
		share_checkbox_callback = function()
			Review:toggleShareBoxValue()
		end
	})
	
	if var_33_1 then
		local var_33_3 = var_33_1:getChildByName("txt_input")
		local var_33_4 = var_33_1:getChildByName("nickname_Bg")
		
		arg_33_0.vars.input = {
			numlines = 1,
			ctrl = var_33_3,
			content_size = var_33_3:getContentSize(),
			bg_ctrl = var_33_4,
			bg_content_size = var_33_4:getContentSize()
		}
	end
	
	var_33_1:setGlobalZOrder(9999)
	
	local var_33_5 = getParentWindow(Review.vars.wnd)
	
	var_33_1:setPositionX(DESIGN_WIDTH / 2)
	var_33_1:setPositionY(DESIGN_HEIGHT * 2)
	var_33_5:addChild(var_33_1)
	UIAction:Add(SEQ(LOG(MOVE_TO(100, DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2))), var_33_1, "block")
	Scheduler:add(arg_33_0.vars.wnd, arg_33_0.updateInputTextFieldSize, arg_33_0)
end

function Review.updateInputTextFieldSize(arg_36_0)
	if not arg_36_0.vars or not arg_36_0.vars.input or not get_cocos_refid(arg_36_0.vars.input.ctrl) then
		return 
	end
	
	if arg_36_0.vars.input and get_cocos_refid(arg_36_0.vars.input.ctrl) then
		local var_36_0 = arg_36_0.vars.input.ctrl
		local var_36_1 = tolua.cast(var_36_0:getVirtualRenderer(), "cc.Label"):getStringNumLines()
		
		if arg_36_0.vars.input.numlines ~= var_36_1 and var_36_1 > 5 then
			arg_36_0.vars.input.numlines = var_36_1
			
			local var_36_2 = var_36_1 - 4
			local var_36_3 = table.clone(arg_36_0.vars.input.content_size)
			
			var_36_3.height = var_36_3.height + (var_36_2 - 1) * 25
			
			arg_36_0.vars.input.ctrl:setContentSize(var_36_3)
			
			local var_36_4 = table.clone(arg_36_0.vars.input.bg_content_size)
			
			var_36_4.height = var_36_4.height + (var_36_2 - 1) * 20
		end
	end
end

function Review.toggleShareBoxValue(arg_37_0)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.vars.wnd) then
		return 
	end
	
	arg_37_0.vars.use_share_unit_value = not arg_37_0.vars.use_share_unit_value
end

function Review.resultWriteComment(arg_38_0, arg_38_1, arg_38_2)
	if arg_38_2 then
		arg_38_0.infos.total_review = arg_38_0.infos.total_review + 1
	else
		arg_38_0.infos.total_review = arg_38_0.infos.total_review - 1
	end
	
	if arg_38_0.vars.page == 1 or not arg_38_2 then
		query("review_comment_list", {
			code = arg_38_0.infos.code,
			p = arg_38_0.vars.page,
			o = arg_38_0.vars.order,
			r = arg_38_0.vars.review_type,
			my = arg_38_0.show_my_review
		})
		
		arg_38_0.vars.reupdate = true
	end
	
	if_set(arg_38_0.vars.wnd, "txt_item_count", T("comment_count", {
		count = arg_38_0.infos.total_review
	}))
end

function Review.reUpdateCommentList(arg_39_0)
	if not arg_39_0.vars or not arg_39_0.vars.reupdate then
		return 
	end
	
	local var_39_0 = arg_39_0.vars.review_type
	
	if arg_39_0.vars.review_type == 1 then
		var_39_0 = "btn_category_after_update"
	elseif arg_39_0.vars.review_type == 2 then
		var_39_0 = "btn_category_2week"
	elseif arg_39_0.vars.review_type == 3 then
		var_39_0 = "btn_category_total"
	end
	
	arg_39_0.vars.review_type = nil
	
	arg_39_0:updateTabs(var_39_0)
	
	arg_39_0.vars.reupdate = false
end

function Review.setLeft(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	arg_40_4 = arg_40_4 or {}
	
	local var_40_0 = arg_40_4.txt_story_name or "txt_contents_0"
	local var_40_1 = {
		tooltip_opts = {
			show_effs = "right"
		}
	}
	local var_40_2 = DB("character", arg_40_2, "grade")
	local var_40_3 = {
		exp = 0,
		z = 6,
		code = arg_40_2,
		g = var_40_2
	}
	local var_40_4 = UnitDetail:getUnit()
	
	arg_40_3 = arg_40_3 or UNIT:create(var_40_3)
	
	UIUtil:setUnitSkillInfo(arg_40_1, arg_40_3, var_40_1)
	
	if not var_40_4 then
		var_40_3.z = 0
		arg_40_3 = UNIT:create(var_40_3)
	end
	
	UIUtil:setUnitAllInfo(arg_40_1, arg_40_3)
	UIUtil:setDevoteDetail_new(arg_40_1, arg_40_3, {
		target = "n_dedi",
		not_my_unit = true
	})
	
	local var_40_5 = arg_40_1:getChildByName("txt_name")
	
	if_call(arg_40_1, "star1", "setPositionX", 10 + var_40_5:getContentSize().width * var_40_5:getScaleX() + var_40_5:getPositionX())
	
	local var_40_6 = arg_40_1:getChildByName("LEFT"):getChildByName(var_40_0)
	
	if var_40_6 then
		var_40_6:setString(T(DB("character", arg_40_2, "2line")))
	end
	
	arg_40_0.vars.left_wnd = arg_40_1
end

function Review.setPortrait(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0, var_41_1 = UIUtil:getPortraitAni(DB("character", arg_41_2, "face_id"), {
		parent_pos_y = arg_41_1:getChildByName("port_pos"):getPositionY()
	})
	
	var_41_0:setAnchorPoint(0.5, 0)
	var_41_0:setScale(0.8)
	
	if not var_41_1 then
		var_41_0:setPositionY(0)
	end
	
	arg_41_1:getChildByName("port_pos"):addChild(var_41_0)
end

function Review.show(arg_42_0, arg_42_1)
	if IS_PUBLISHER_ZLONG then
		return 
	end
	
	arg_42_1 = arg_42_1 or {}
	
	local var_42_0
	
	if arg_42_1.renew then
		var_42_0 = load_dlg("hero_detail_vote_review", true, "wnd")
		arg_42_0.tabs = arg_42_0.tabs or {}
		arg_42_0.tabs.btn_category_after_update = var_42_0:getChildByName("top"):getChildByName("category"):getChildByName("category_after_update"):getChildByName("fg_category_after_update")
		arg_42_0.tabs.btn_category_after_update.txt = var_42_0:getChildByName("top"):getChildByName("category"):getChildByName("category_after_update"):getChildByName("txt")
		
		arg_42_0.tabs.btn_category_after_update.txt:setString(T("ui_hero_detail_vote_review_tab1"))
		
		arg_42_0.tabs.btn_category_2week = var_42_0:getChildByName("top"):getChildByName("category"):getChildByName("category_2week"):getChildByName("fg_category_2week")
		arg_42_0.tabs.btn_category_2week.txt = var_42_0:getChildByName("top"):getChildByName("category"):getChildByName("category_2week"):getChildByName("txt")
		
		arg_42_0.tabs.btn_category_2week.txt:setString(T("ui_hero_detail_vote_review_tab2"))
		
		arg_42_0.tabs.btn_category_total = var_42_0:getChildByName("top"):getChildByName("category"):getChildByName("category_total"):getChildByName("fg_category_total")
		arg_42_0.tabs.btn_category_total.txt = var_42_0:getChildByName("top"):getChildByName("category"):getChildByName("category_total"):getChildByName("txt")
		
		arg_42_0.tabs.btn_category_total.txt:setString(T("ui_hero_detail_vote_review_tab3"))
		arg_42_0.tabs.btn_category_total:setVisible(false)
		arg_42_0.tabs.btn_category_2week:setVisible(false)
		arg_42_0.tabs.btn_category_after_update:setVisible(false)
		
		if Review.vars.review_type == 1 then
			arg_42_0.tabs.btn_category_after_update:setVisible(true)
			arg_42_0.tabs.btn_category_total.txt:setOpacity(76.5)
			arg_42_0.tabs.btn_category_2week.txt:setOpacity(76.5)
			arg_42_0.tabs.btn_category_after_update.txt:setOpacity(255)
		elseif Review.vars.review_type == 2 then
			arg_42_0.tabs.btn_category_2week:setVisible(true)
			arg_42_0.tabs.btn_category_total.txt:setOpacity(76.5)
			arg_42_0.tabs.btn_category_2week.txt:setOpacity(255)
			arg_42_0.tabs.btn_category_after_update.txt:setOpacity(76.5)
		elseif Review.vars.review_type == 3 then
			arg_42_0.tabs.btn_category_total:setVisible(true)
			arg_42_0.tabs.btn_category_total.txt:setOpacity(255)
			arg_42_0.tabs.btn_category_2week.txt:setOpacity(76.5)
			arg_42_0.tabs.btn_category_after_update.txt:setOpacity(76.5)
		end
		
		var_42_0:getChildByName("top"):getChildByName("check_box_my"):setSelected(false)
		
		local var_42_1 = arg_42_0.vars.left_wnd:getChildByName("LEFT")
		
		if get_cocos_refid(var_42_1) then
			if not DB("character_reference", arg_42_0.infos.code, {
				"balance_update"
			}) then
				var_42_1:getChildByName("rating"):getChildByName("check_box_before"):setOpacity(76.5)
			end
			
			var_42_1:getChildByName("rating"):getChildByName("check_box_before"):setSelected(false)
			var_42_1:getChildByName("rating"):getChildByName("check_box_before"):getChildByName("t"):setString(T("ui_hero_detail_vote_rating_before"))
		end
		
		arg_42_0.show_my_review = false
	else
		var_42_0 = load_dlg("hero_vote", true, "wnd")
	end
	
	arg_42_0.vars.sort_menu_find_toggle = false
	arg_42_0.vars.sort_menu_find_index = 1
	
	if_set_visible(var_42_0, "layer_sort", arg_42_0.vars.sort_menu_find_toggle)
	var_42_0:setLocalZOrder(1)
	
	arg_42_0.vars.wnd = var_42_0
	arg_42_0.vars.renew = arg_42_1.renew
	
	local var_42_2 = DB("character", arg_42_1.code, "grade")
	
	arg_42_0.vars.is_moonlight_destiny = MoonlightDestiny:isDestinyCharacter(arg_42_1.code)
	
	local var_42_3 = arg_42_1.code
	
	if arg_42_0.vars.is_moonlight_destiny then
		var_42_3 = MoonlightDestiny:getRelationCharacterCode(var_42_3)
	elseif is_enhanced_mer(var_42_3) then
		arg_42_1.code = get_origin_mer()
		var_42_3 = get_origin_mer()
	end
	
	arg_42_0.vars.unit = arg_42_1.unit or UNIT:create({
		exp = 0,
		z = 6,
		code = var_42_3,
		g = var_42_2
	})
	
	if_set(arg_42_0.vars.wnd, "txt_item_count", T("comment_count", {
		count = arg_42_0.infos.total_review
	}))
	UIUtil:setSubtaskSkill(arg_42_0.vars.wnd, arg_42_0.vars.unit, {
		tooltip_creator = function()
			return UIUtil:getSubtaskSkillTooltip(arg_42_0.vars.unit)
		end
	})
	
	if not arg_42_1.renew then
		print(" not opts.renew? ", not arg_42_1.renew)
		arg_42_0:setLeft(arg_42_0.vars.wnd, arg_42_1.code, arg_42_0.vars.unit)
	end
	
	arg_42_0:updateStarReview()
	
	local var_42_4 = 590
	
	if arg_42_1.renew then
		var_42_4 = 489
	end
	
	arg_42_0:initScrollView(arg_42_0.vars.wnd:getChildByName("scrollview"), var_42_4, 115)
	
	arg_42_0.vars.order = 1
	
	query("review_comment_list", {
		p = 1,
		code = arg_42_1.code,
		o = arg_42_0.vars.order,
		r = arg_42_0.vars.review_type
	})
	
	if not arg_42_1.no_portrait then
		arg_42_0:setPortrait(arg_42_0.vars.wnd, arg_42_1.code)
	end
	
	if arg_42_1.set_pos_x then
		arg_42_0.vars.wnd:setPositionX(arg_42_1.set_pos_x)
	end
	
	if arg_42_1.layer then
		arg_42_1.layer:addChild(arg_42_0.vars.wnd)
	end
	
	if arg_42_1.back_btn_hide then
		arg_42_0:setVisibleDefaultBackBtn(false)
	end
	
	if arg_42_0.vars.callback then
		arg_42_0.vars.callback(true)
	end
	
	return var_42_0
end

function Review.showMyReview(arg_44_0, arg_44_1)
	if not arg_44_0.vars or not get_cocos_refid(arg_44_0.vars.wnd) then
		return 
	end
	
	local var_44_0 = arg_44_0.vars.wnd:getChildByName("check_box_my")
	
	if var_44_0 then
		if arg_44_1 then
			var_44_0:setSelected(not var_44_0:isSelected())
		end
		
		arg_44_0.show_my_review = var_44_0:isSelected() and 1 or 0
	end
	
	arg_44_0:clearScrollViewItems()
end

function Review.showMyComments(arg_45_0)
	local var_45_0 = arg_45_0.vars.my == 1 and 0 or 1
	
	query("review_comment_list", {
		code = arg_45_0.infos.code,
		p = arg_45_0.vars.page,
		o = arg_45_0.vars.order,
		my = var_45_0
	})
end

function Review.reviewComment(arg_46_0, arg_46_1, arg_46_2)
	if Account:getCollectionUnit(arg_46_0.infos.code) == nil then
		balloon_message_with_sound("review_comment.cannot_review_no_unit")
		
		return 
	end
	
	local var_46_0 = 0
	
	for iter_46_0, iter_46_1 in pairs(arg_46_0.ScrollViewItems) do
		if iter_46_1.item.comment_id == arg_46_1 then
			var_46_0 = iter_46_1.item.my_like
			
			break
		end
	end
	
	if var_46_0 == 0 or var_46_0 == nil then
		query("review_comment_review", {
			code = arg_46_0.infos.code,
			cid = arg_46_1,
			like = arg_46_2
		})
	elseif var_46_0 == arg_46_2 then
		Dialog:msgBox(T("review_recommend_cancel_popup_desc"), {
			yesno = true,
			handler = function()
				query("review_comment_review", {
					code = arg_46_0.infos.code,
					cid = arg_46_1,
					like = arg_46_2
				})
			end
		})
	elseif var_46_0 ~= arg_46_2 then
		Dialog:msgBox(T("review_recommend_cancel_popup_desc"), {
			yesno = true,
			handler = function()
				query("review_comment_review", {
					code = arg_46_0.infos.code,
					cid = arg_46_1,
					like = arg_46_2
				})
			end
		})
	end
end

function Review.deleteMyComment(arg_49_0, arg_49_1)
	if not arg_49_1 then
		return 
	end
	
	Dialog:msgBox(T("hero_review_delete_popup_desc"), {
		yesno = true,
		title = T("hero_review_delete_popup_title"),
		handler = function()
			query("remove_review_comment", {
				code = arg_49_0.infos.code,
				comment_id = arg_49_1
			})
		end
	})
end

function Review.updateReviewCommentReview(arg_51_0, arg_51_1)
	for iter_51_0, iter_51_1 in pairs(arg_51_0.ScrollViewItems) do
		if iter_51_1.item.comment_id == tonumber(arg_51_1.cid) then
			iter_51_1.item.my_like = arg_51_1.c.my_like
			iter_51_1.item.like_count = arg_51_1.c.like_count
			
			arg_51_0:updateCommentButtons(iter_51_1.control, arg_51_1.cid, arg_51_1.c.like_count, arg_51_1.c.dislike_count, arg_51_1.c.my_like)
		end
	end
end

function Review.close(arg_52_0)
	if not arg_52_0.vars then
		return 
	end
	
	if arg_52_0.vars.callback then
		arg_52_0.vars.callback(false)
	end
	
	arg_52_0.vars = nil
	arg_52_0.infos = nil
	arg_52_0.tabs = nil
end

function Review.showDevoteDetail(arg_53_0)
	DevoteTooltip:showDevoteDetail(arg_53_0.vars.unit, arg_53_0.vars.wnd, {
		block_button = true
	})
end

ReviewCommentPopup = ReviewCommentPopup or {}

function HANDLER.hero_vote_open_simple(arg_54_0, arg_54_1)
	if arg_54_1 == "btn_close" then
		ReviewCommentPopup:close()
	end
	
	if ReviewPreviewPopup.ready then
		balloon_message_with_sound("err_cannot_rate_review_popup")
		
		return 
	end
	
	if arg_54_1 == "btn_good" then
		local var_54_0 = arg_54_0:getName()
		local var_54_1 = arg_54_0.comment_id
		local var_54_2 = 1
		
		Review:reviewComment(var_54_1, var_54_2)
	end
end

function ReviewCommentPopup.open(arg_55_0, arg_55_1)
	if arg_55_0.vars and get_cocos_refid(arg_55_0.vars.wnd) or not arg_55_1 then
		return 
	end
	
	arg_55_0.vars = {}
	arg_55_0.vars.data = arg_55_1
	arg_55_0.vars.wnd = load_dlg("hero_vote_open_simple", true, "wnd", function()
		arg_55_0:close()
	end)
	
	SceneManager:getRunningPopupScene():addChild(arg_55_0.vars.wnd)
	
	local var_55_0 = arg_55_0.vars.wnd:getChildByName("n_vote")
	local var_55_1 = arg_55_1
	local var_55_2 = var_55_1.comment
	
	if_set(arg_55_0.vars.wnd, "t_review", urldecode(var_55_2))
	if_set(arg_55_0.vars.wnd, "title", T("hero_review_detail_popup_title", {
		name = var_55_1.name
	}))
	
	if var_55_1.user_id == 0 then
		local var_55_3 = {
			DB("gm_info", getUserLanguage(), {
				"name",
				"face"
			})
		}
		
		if_set(arg_55_0.vars.wnd, "title", T(var_55_3[1]))
		
		local var_55_4 = json.decode(var_55_2)[getUserLanguage()]
		
		if var_55_4 == "" then
			return 
		end
		
		if_set(arg_55_0.vars.wnd, "t_review", urldecode(var_55_4))
	end
	
	if_set(arg_55_0.vars.wnd, "txt_date", T("time_dot_y_m_d", timeToStringDef({
		preceding_with_zeros = true,
		time = var_55_1.created
	})))
	arg_55_0:refreshCommentButtons()
end

function ReviewCommentPopup.refreshCommentButtons(arg_57_0, arg_57_1)
	if not arg_57_0.vars or not get_cocos_refid(arg_57_0.vars.wnd) or not arg_57_0.vars.data then
		return 
	end
	
	local var_57_0 = arg_57_0.vars.data
	
	if arg_57_1 and var_57_0.comment_id == tonumber(arg_57_1.cid) then
		var_57_0.my_like = arg_57_1.c.my_like
		arg_57_0.vars.data.my_like = arg_57_1.c.my_like
		var_57_0.like_count = arg_57_1.c.like_count
		arg_57_0.vars.data.like_count = arg_57_1.c.like_count
	end
	
	ReviewCommon:updateCommentButtons(arg_57_0.vars.wnd, var_57_0.comment_id, var_57_0.like_count, var_57_0.dislike_count, var_57_0.my_like)
end

function ReviewCommentPopup.close(arg_58_0, arg_58_1)
	if not arg_58_0.vars or not get_cocos_refid(arg_58_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop({
		check_id = "ReviewCommentPopup",
		dlg = arg_58_0.vars.wnd
	})
	arg_58_0.vars.wnd:removeFromParent()
	
	arg_58_0.vars = nil
end

ReviewPreviewPopup = ReviewPreviewPopup or {}

copy_functions(ReviewCommon, ReviewPreviewPopup)
copy_functions(ScrollView, ReviewPreviewPopup)

function HANDLER.hero_vote_preview(arg_59_0, arg_59_1)
	if arg_59_1 == "btn_close" then
		ReviewPreviewPopup:close()
	elseif arg_59_1 == "check_box_before" then
		if ReviewPreviewPopup.vars.block_tab then
			arg_59_0:setSelected(false)
			balloon_message_with_sound("msg_hero_vote_no_update")
			
			return 
		else
			ReviewPreviewPopup:updateStarReview(arg_59_0:isSelected())
		end
	elseif string.starts(arg_59_1, "btn_category_") then
		if ReviewPreviewPopup.vars.block_tab and arg_59_1 == "btn_category_after_update" then
			balloon_message_with_sound("msg_hero_vote_no_update")
			
			return 
		else
			ReviewPreviewPopup:updateTabs(arg_59_1)
		end
	elseif string.find(arg_59_1, "btn_dedi") then
		ReviewPreviewPopup:showDevoteDetail()
	elseif arg_59_1 == "btn_sort" then
		ReviewPreviewPopup:toggleSortMenus()
	elseif arg_59_1 == "btn_close_sort" then
		ReviewPreviewPopup:toggleSortMenus(false)
	elseif arg_59_1 == "sort_1" then
		ReviewPreviewPopup:selectSortMenu(1)
	elseif arg_59_1 == "sort_2" then
		ReviewPreviewPopup:selectSortMenu(2)
	elseif arg_59_1 == "btn_good" or arg_59_1 == "btn_ng" then
		balloon_message_with_sound("err_cannot_rate_review_popup")
	end
end

function MsgHandler.review_preview(arg_60_0)
	Review.ready = false
	ReviewPreviewPopup.ready = true
	
	ReviewPreviewPopup:show(arg_60_0)
end

function ReviewPreviewPopup.open(arg_61_0, arg_61_1)
	arg_61_0.vars = {}
	arg_61_0.vars.is_moonlight_destiny = MoonlightDestiny:isDestinyCharacter(arg_61_1)
	arg_61_0.vars.code = arg_61_1
	
	if arg_61_0.vars.is_moonlight_destiny then
		arg_61_0.vars.code = MoonlightDestiny:getRelationCharacterCode(arg_61_1)
	elseif is_enhanced_mer(arg_61_1) then
		arg_61_0.vars.code = get_origin_mer()
	end
	
	local var_61_0 = DB("character", arg_61_1, "grade")
	
	arg_61_0.vars.unit = UNIT:create({
		z = 6,
		awake = 6,
		exp = 0,
		code = arg_61_1,
		g = var_61_0
	})
	arg_61_0.vars.update_data = DB("character_reference", arg_61_1, {
		"balance_update"
	})
	
	if arg_61_0.vars.update_data then
		arg_61_0.vars.review_type = 1
	else
		arg_61_0.vars.block_tab = true
		arg_61_0.vars.review_type = 2
	end
	
	local var_61_1 = arg_61_0.vars.review_type == 1 and 1 or 0
	
	query("review_preview", {
		code = arg_61_0.vars.code,
		is_before = var_61_1
	})
end

function ReviewPreviewPopup.close(arg_62_0)
	Dialog:close("hero_vote_preview")
end

function ReviewPreviewPopup.show(arg_63_0, arg_63_1)
	if IS_PUBLISHER_ZLONG then
		return 
	end
	
	arg_63_0.vars.info = arg_63_1
	
	local var_63_0 = Dialog:open("wnd/hero_vote_preview", arg_63_0, {
		modal = true,
		use_backbutton = true
	})
	
	arg_63_0.vars.wnd = var_63_0
	arg_63_0.vars.is_popup = true
	
	SceneManager:getRunningPopupScene():addChild(arg_63_0.vars.wnd)
	
	arg_63_0.vars.left_wnd = arg_63_0.vars.wnd:getChildByName("LEFT")
	arg_63_0.vars.center_wnd = arg_63_0.vars.wnd:getChildByName("CENTER")
	arg_63_0.vars.right_wnd = arg_63_0.vars.wnd:getChildByName("RIGHT")
	
	UIUtil:setUnitAllInfo(arg_63_0.vars.left_wnd, arg_63_0.vars.unit, {
		use_basic_star = true
	})
	UIUtil:setUnitSkillInfo(arg_63_0.vars.left_wnd, arg_63_0.vars.unit, {
		tooltip_opts = {
			show_effs = "right"
		}
	})
	UIUtil:setDevoteDetail_new(arg_63_0.vars.left_wnd, arg_63_0.vars.unit, {
		target = "n_dedi",
		not_my_unit = true
	})
	arg_63_0:updateStarReview(false)
	arg_63_0:initScrollView(arg_63_0.vars.wnd:getChildByName("scrollview"), 489, 115)
	
	local var_63_1 = arg_63_0.vars.center_wnd:getChildByName("portrait")
	local var_63_2, var_63_3 = UIUtil:getPortraitAni(DB("character", arg_63_0.vars.code, "face_id"), {
		parent_pos_y = var_63_1:getPositionY()
	})
	
	var_63_2:setAnchorPoint(0.5, 0)
	var_63_2:setScale(0.8)
	
	if not var_63_3 then
		var_63_2:setPositionY(0)
	end
	
	var_63_1:addChild(var_63_2)
	
	arg_63_0.tabs = arg_63_0.tabs or {}
	
	local var_63_4 = var_63_0:getChildByName("top"):getChildByName("category")
	
	arg_63_0.tabs.btn_category_after_update = var_63_4:getChildByName("category_after_update"):getChildByName("fg_category_after_update")
	arg_63_0.tabs.btn_category_after_update.txt = var_63_4:getChildByName("category_after_update"):getChildByName("txt")
	
	arg_63_0.tabs.btn_category_after_update.txt:setString(T("ui_hero_detail_vote_review_tab1"))
	
	arg_63_0.tabs.btn_category_2week = var_63_4:getChildByName("category_2week"):getChildByName("fg_category_2week")
	arg_63_0.tabs.btn_category_2week.txt = var_63_4:getChildByName("category_2week"):getChildByName("txt")
	
	arg_63_0.tabs.btn_category_2week.txt:setString(T("ui_hero_detail_vote_review_tab2"))
	
	arg_63_0.tabs.btn_category_total = var_63_4:getChildByName("category_total"):getChildByName("fg_category_total")
	arg_63_0.tabs.btn_category_total.txt = var_63_4:getChildByName("category_total"):getChildByName("txt")
	
	arg_63_0.tabs.btn_category_total.txt:setString(T("ui_hero_detail_vote_review_tab3"))
	arg_63_0.tabs.btn_category_total:setVisible(false)
	arg_63_0.tabs.btn_category_2week:setVisible(false)
	arg_63_0.tabs.btn_category_after_update:setVisible(false)
	
	if arg_63_0.vars.review_type == 1 then
		arg_63_0.tabs.btn_category_after_update:setVisible(true)
		arg_63_0.tabs.btn_category_total.txt:setOpacity(76.5)
		arg_63_0.tabs.btn_category_2week.txt:setOpacity(76.5)
		arg_63_0.tabs.btn_category_after_update.txt:setOpacity(255)
	elseif arg_63_0.vars.review_type == 2 then
		arg_63_0.tabs.btn_category_2week:setVisible(true)
		arg_63_0.tabs.btn_category_total.txt:setOpacity(76.5)
		arg_63_0.tabs.btn_category_2week.txt:setOpacity(255)
		arg_63_0.tabs.btn_category_after_update.txt:setOpacity(76.5)
	elseif arg_63_0.vars.review_type == 3 then
		arg_63_0.tabs.btn_category_total:setVisible(true)
		arg_63_0.tabs.btn_category_total.txt:setOpacity(255)
		arg_63_0.tabs.btn_category_2week.txt:setOpacity(76.5)
		arg_63_0.tabs.btn_category_after_update.txt:setOpacity(76.5)
	end
	
	arg_63_0.vars.sort_menu_find_toggle = false
	arg_63_0.vars.sort_menu_find_index = 1
	arg_63_0.vars.page = 1
	arg_63_0.vars.order = 1
	arg_63_0.show_my_review = false
	
	query("review_comment_list", {
		code = arg_63_0.vars.code,
		p = arg_63_0.vars.page,
		o = arg_63_0.vars.order,
		r = arg_63_0.vars.review_type,
		my = arg_63_0.show_my_review
	})
	if_set_visible(arg_63_0.vars.wnd, "layer_sort", false)
end

function ReviewPreviewPopup.updateStarReview(arg_64_0, arg_64_1)
	local var_64_0 = 0
	local var_64_1 = 0
	local var_64_2 = arg_64_0.vars.info.review_star
	
	if arg_64_1 then
		var_64_2 = arg_64_0.vars.info.review_star_before
	end
	
	for iter_64_0, iter_64_1 in pairs(var_64_2 or {}) do
		local var_64_3 = tonumber(iter_64_1)
		
		if iter_64_0 == "s1" then
			var_64_0 = var_64_0 + 1 * var_64_3
			var_64_1 = var_64_1 + var_64_3
		elseif iter_64_0 == "s2" then
			var_64_0 = var_64_0 + 2 * var_64_3
			var_64_1 = var_64_1 + var_64_3
		elseif iter_64_0 == "s3" then
			var_64_0 = var_64_0 + 3 * var_64_3
			var_64_1 = var_64_1 + var_64_3
		elseif iter_64_0 == "s4" then
			var_64_0 = var_64_0 + 4 * var_64_3
			var_64_1 = var_64_1 + var_64_3
		elseif iter_64_0 == "s5" then
			var_64_0 = var_64_0 + 5 * var_64_3
			var_64_1 = var_64_1 + var_64_3
		end
	end
	
	local var_64_4 = 0
	
	if var_64_1 > 0 then
		var_64_4 = var_64_0 / var_64_1
	end
	
	if_set(arg_64_0.vars.left_wnd, "txt_rating", T("rating_score", {
		score = math.round(var_64_4 * 10) / 10
	}))
	if_set(arg_64_0.vars.left_wnd, "txt_rating_count", T("rating_count", {
		count = var_64_1
	}))
end

function ReviewPreviewPopup.showDevoteDetail(arg_65_0)
	if not arg_65_0.vars or not get_cocos_refid(arg_65_0.vars.wnd) then
		return 
	end
	
	DevoteTooltip:showDevoteDetail(arg_65_0.vars.unit, arg_65_0.vars.wnd)
end
