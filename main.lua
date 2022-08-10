-- Physics Impulse

function draw_line(pos_a, pos_b, line_color, vid, vtx_line_layout, line_shader)
	local vtx = hg.Vertices(vtx_line_layout, 2)
	vtx:Begin(0):SetPos(pos_a):SetColor0(line_color):End()
	vtx:Begin(1):SetPos(pos_b):SetColor0(line_color):End()
	hg.DrawLines(vid, vtx, line_shader)
end

function CreateCubeCollision(scene, size, mass)
	local col = scene:CreateCollision()
	col:SetType(hg.CT_Cube)
	col:SetSize(size)
	col:SetMass(mass)
	return col
end

function CreatePhysicCubeWithRBType(scene, size, mtx, model_ref, materials, mass, rb_type)
	local rb_type = rb_type or hg.RBT_Dynamic
	local node = hg.CreateObject(scene, mtx, model_ref, materials)
	node:SetName("Physic Cube")
	local rb = scene:CreateRigidBody()
	rb:SetType(rb_type)
	node:SetRigidBody(rb)
	node:SetCollision(0, CreateCubeCollision(scene, size, mass))
	return node
end

function CreateMaterialPackFromResources(res)
	local pbr_shader = hg.LoadPipelineProgramRefFromAssets('core/shader/pbr.hps', res, hg.GetForwardPipelineInfo())
	local mat_grey = hg.CreateMaterial(pbr_shader, 'uBaseOpacityColor', hg.Vec4(1, 1, 1), 'uOcclusionRoughnessMetalnessColor', hg.Vec4(1, 0.5, 0.05))
	local mat_red = hg.CreateMaterial(pbr_shader, 'uBaseOpacityColor', hg.Vec4(1, 0.2, 0.1), 'uOcclusionRoughnessMetalnessColor', hg.Vec4(1, 0.25, 0.1))
	local mat_yellow = hg.CreateMaterial(pbr_shader, 'uBaseOpacityColor', hg.Vec4(0.8, 0.1, 0.0), 'uOcclusionRoughnessMetalnessColor', hg.Vec4(1, 0.5, 0.1))
	return mat_grey, mat_red, mat_yellow
end

function CreatePhysicsNode(scene, cube_ref, mat_red)
	local cube_node = CreatePhysicCubeWithRBType(scene, hg.Vec3(1, 1, 1), hg.TranslationMat4(hg.Vec3(0, 2.5, 0)), cube_ref, {mat_red}, 2, hg.RBT_Dynamic)
	return cube_node
end

hg = require("harfang")

function main()
	-- assets
	hg.AddAssetsFolder('assets_compiled')

	-- main window
	hg.InputInit()
	hg.WindowSystemInit()

	local res_x, res_y = 1280, 720
	local win = hg.RenderInit('Physics Test', res_x, res_y, hg.RF_VSync | hg.RF_MSAA4X)

	local pipeline = hg.CreateForwardPipeline()
	local res = hg.PipelineResources()

	-- physics debug
	local vtx_line_layout = hg.VertexLayoutPosFloatColorUInt8()
	local line_shader = hg.LoadProgramFromAssets("shaders/pos_rgb")

	-- create material
	local mat_grey, mat_red, mat_yellow = CreateMaterialPackFromResources(res)

	-- create models
	local vtx_layout = hg.VertexLayoutPosFloatNormUInt8()

	local cube_mdl = hg.CreateCubeModel(vtx_layout, 1, 1, 1)
	local cube_ref = res:AddModel('cube', cube_mdl)

	local ground_size = hg.Vec3(4, 0.05, 4)
	local ground_mdl = hg.CreateCubeModel(vtx_layout, ground_size.x, ground_size.y, ground_size.z)
	local ground_ref = res:AddModel('ground', ground_mdl)

	-- setup scene
	local scene = hg.Scene()

	local cam_mat = hg.TransformationMat4(hg.Vec3(0, 1.5, -5), hg.Vec3(hg.Deg(10), 0, 0))
	local cam = hg.CreateCamera(scene, cam_mat, 0.01, 1000)
	local view_matrix = hg.InverseFast(cam_mat)
	local c = cam:GetCamera()
	local projection_matrix = hg.ComputePerspectiveProjectionMatrix(c:GetZNear(), c:GetZFar(), hg.FovToZoomFactor(c:GetFov()), hg.Vec2(res_x / res_y, 1))

	scene:SetCurrentCamera(cam)	

	local lgt = hg.CreateLinearLight(scene, hg.TransformationMat4(hg.Vec3(0, 0, 0), hg.Vec3(hg.Deg(30), hg.Deg(30), 0)), hg.Color(1, 1, 1), hg.Color(1, 1, 1), 10, hg.LST_Map, 0.0001, hg.Vec4(2, 4, 10, 16))

	local cube_node = CreatePhysicsNode(scene, cube_ref, mat_red) -- CreatePhysicCubeWithRBType(scene, hg.Vec3(1, 1, 1), hg.TranslationMat4(hg.Vec3(0, 2.5, 0)), cube_ref, {mat_red}, 2, hg.RBT_Dynamic)
	local ground_node = hg.CreatePhysicCube(scene, ground_size, hg.TranslationMat4(hg.Vec3(0, -0.005, 0)), ground_ref, {mat_grey}, 0)

	local clocks = hg.SceneClocks()

	-- scene physics
	local physics = hg.SceneBullet3Physics()
	physics:SceneCreatePhysicsFromAssets(scene)
	local physics_step = hg.time_from_sec_f(1 / 60)
	local display_physics_debug = true 

	-- imgui
	local imgui_prg = hg.LoadProgramFromAssets('core/shader/imgui')
	local imgui_img_prg = hg.LoadProgramFromAssets('core/shader/imgui_image')
	
	hg.ImGuiInit(10, imgui_prg, imgui_img_prg)

	-- main loop
	local keyboard = hg.Keyboard()

	while not keyboard:Down(hg.K_Escape) and hg.IsWindowOpen(win) do
		keyboard:Update()

		local view_id = 0
		local lines = {}

		local dt = hg.TickClock()
		local world_pos = hg.GetT(cube_node:GetTransform():GetWorld())

		local P = hg.Vec3(0.5,0.5,0.5) -- world pos for linear force/impulse
		local F = hg.Vec3(0,0,0) -- vector for force/impulse
		
		if keyboard:Down(hg.K_Right) then
			F = F + hg.Vec3(1.0,0,0)
		elseif keyboard:Down(hg.K_Left) then
			F = F + hg.Vec3(-1.0,0,0)
		end

		if keyboard:Down(hg.K_Up) then
			F = F + hg.Vec3(0,1.0,0)
		elseif keyboard:Down(hg.K_Down) then
			F = F + hg.Vec3(0,-1.0,0)
		end

		if keyboard:Down(hg.K_LShift) then
			-- impulse
			if keyboard:Down(hg.K_LCtrl) then
				local _p = cube_node:GetTransform():GetWorld() * P
				table.insert(lines, {pos_a = _p, pos_b = _p + F, color = hg.Color.Red})
				physics:NodeAddImpulse(cube_node, F * 0.2, _p)
			else
				local _p = hg.GetTranslation(cube_node:GetTransform():GetWorld())
				table.insert(lines, {pos_a = _p, pos_b = _p + F, color = hg.Color.Red})				
				physics:NodeAddImpulse(cube_node, F * 0.2)
			end
		else
			-- force
			if keyboard:Down(hg.K_LCtrl) then
				local _p = cube_node:GetTransform():GetWorld() * P
				table.insert(lines, {pos_a = _p, pos_b = _p + F, color = hg.Color.Yellow})
				physics:NodeAddForce(cube_node, F * 25.0, _p)
			else
				local _p = hg.GetTranslation(cube_node:GetTransform():GetWorld())
				table.insert(lines, {pos_a = _p, pos_b = _p + F, color = hg.Color.Yellow})
				physics:NodeAddForce(cube_node, F * 25.0)
			end
		end

		if keyboard:Pressed(hg.K_Space) then
			physics:NodeDestroyPhysics(cube_node)
			scene:DestroyNode(cube_node)
            scene:GarbageCollect()	
			cube_node = CreatePhysicsNode(scene, cube_ref, mat_red)
			physics:SceneCreatePhysicsFromAssets(scene)
		end

		physics:NodeWake(cube_node)

		hg.SceneUpdateSystems(scene, clocks, dt, physics, physics_step, 3)
		view_id, pass_id = hg.SubmitSceneToPipeline(view_id, scene, hg.IntRect(0, 0, res_x, res_y), true, pipeline, res)

		-- debug draw lines
		local opaque_view_id = hg.GetSceneForwardPipelinePassViewId(pass_id, hg.SFPP_Opaque)
		for i=1, #lines do
			draw_line(lines[i].pos_a, lines[i].pos_b, lines[i].color, opaque_view_id, vtx_line_layout, line_shader)
		end

		-- -- Debug physics display
		if display_physics_debug then
			hg.SetViewClear(view_id, 0, 0, 1.0, 0)
			hg.SetViewRect(view_id, 0, 0, res_x, res_y)
			hg.SetViewTransform(view_id, view_matrix, projection_matrix)
			local rs = hg.ComputeRenderState(hg.BM_Opaque, hg.DT_Disabled, hg.FC_Disabled)
			physics:RenderCollision(view_id, vtx_line_layout, line_shader, rs, 0)
		end

		-- GUI
		view_id = view_id + 1
		hg.SetView2D(0, 0, 0, res_x, res_y, -1, 0, hg.CF_Color | hg.CF_Depth, hg.Color.Green, 1, 0)
		hg.ImGuiBeginFrame(res_x, res_y, hg.TickClock(), hg.ReadMouse(), hg.ReadKeyboard())

		if hg.ImGuiBegin('Physics Test') then
			_, display_physics_debug = hg.ImGuiCheckbox('Display physics debug', display_physics_debug)
			hg.ImGuiSeparator()
			hg.ImGuiText('Use the Arrow keys (left/right/up/down)')
			hg.ImGuiText('L_Shift = Apply Impulse instead of Force')
			hg.ImGuiText('L_Ctrl = Apply to a corner instead of the center')
		end
		hg.ImGuiEnd()
	
		hg.ImGuiEndFrame(view_id)

		hg.Frame()
		hg.UpdateWindow(win)
	end

	scene:Clear()
	scene:GarbageCollect()

	hg.RenderShutdown()
	hg.DestroyWindow(win)

	hg.WindowSystemShutdown()
	hg.InputShutdown()
end

main()