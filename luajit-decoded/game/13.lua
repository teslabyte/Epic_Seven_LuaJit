﻿GAME_SHADER_MAP = {
	{
		"@SkeletonRenderer",
		"system/program/sprite_base.vert",
		"system/program/model_base.frag"
	},
	{
		"@Sprite",
		"system/program/sprite_base.vert",
		"system/program/model_base.frag"
	},
	{
		"GraySkeletonRenderer",
		"system/program/sprite_base.vert",
		"system/program/model_gray.frag"
	},
	{
		"ShaderDynamicBatch",
		"system/program/dynbat_def.vert",
		"system/program/dynbat_def.frag"
	},
	{
		"ShaderDynamicBatchGrayscale",
		"system/program/dynbat_def.vert",
		"system/program/dynbat_grayscale.frag"
	},
	{
		"dynbat_blend",
		"system/program/dynbat_def.vert",
		"system/program/dynbat_blend.frag"
	},
	{
		"model_blend",
		"system/program/sprite_base.vert",
		"system/program/model_blend.frag"
	},
	{
		"dreamer_base",
		"system/program/sprite_base.vert",
		"system/program/dreamer_base.frag"
	},
	{
		"dreamer_blend",
		"system/program/sprite_base.vert",
		"system/program/dreamer_blend.frag"
	},
	{
		"sprite_blend",
		"system/program/sprite_base.vert",
		"system/program/model_blend.frag"
	},
	{
		"sprite_mask",
		"system/program/sprite_base.vert",
		"system/program/sprite_mask.frag"
	},
	{
		"sprite_invert",
		"system/program/sprite_base.vert",
		"system/program/sprite_invert.frag"
	},
	{
		"sprite_grayscale",
		"system/program/sprite_base.vert",
		"system/program/sprite_grayscale.frag"
	},
	{
		"pp_color_blend",
		"system/program/sprite_base.vert",
		"system/program/pp_color_blend.frag"
	},
	{
		"sprite_blur_vert",
		"system/program/sprite_base.vert",
		"system/program/sprite_blur_vert.frag"
	},
	{
		"sprite_blur_horz",
		"system/program/sprite_base.vert",
		"system/program/sprite_blur_horz.frag"
	},
	{
		"sprite_blur",
		"system/program/sprite_base.vert",
		"system/program/sprite_blur.frag"
	},
	{
		"sprite_filter",
		"system/program/sprite_base.vert",
		"system/program/sprite_filter.frag"
	},
	{
		"smooth_color",
		"system/program/sprite_base.vert",
		"system/program/smooth_color.frag"
	},
	{
		"story_noise_post",
		"system/program/sprite_base.vert",
		"system/program/story_noise_post.frag"
	},
	{
		"zodiac_gravity_post",
		"system/program/sprite_base.vert",
		"system/program/zodiac_gravity_post.frag"
	}
}
ShaderManager = ShaderManager or {}

function ShaderManager.loadShader()
	for iter_1_0, iter_1_1 in pairs(GAME_SHADER_MAP) do
		cc.GLProgramCache:getInstance():addGLProgramFromFile(iter_1_1[1], iter_1_1[2], iter_1_1[3])
	end
end