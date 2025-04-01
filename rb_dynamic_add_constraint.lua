hg = require("harfang")

function CreatePhysicCubeEx(scene, size, mtx, model_ref, materials, rb_type, mass)
	local rb_type = rb_type or hg.RBT_Dynamic
	local mass = mass or 0
	local node = hg.CreateObject(scene, mtx, model_ref, materials)
	node:SetName("Physic Cube")
	local rb = scene:CreateRigidBody()
	rb:SetType(rb_type)
	node:SetRigidBody(rb)
    -- create custom cube collision
	local col = scene:CreateCollision()
	col:SetType(hg.CT_Cube)
	col:SetSize(size)
	col:SetMass(mass)
    -- set cube as collision shape
	node:SetCollision(0, col)
	return node, rb
end

hg.AddAssetsFolder('assets_compiled')

-- main window
hg.InputInit()
hg.WindowSystemInit()

res_x, res_y = 1280, 720
win = hg.RenderInit('Physics Test', res_x, res_y, hg.RF_VSync | hg.RF_MSAA4X)

pipeline = hg.CreateForwardPipeline()
res = hg.PipelineResources()

-- physics debug
vtx_line_layout = hg.VertexLayoutPosFloatColorUInt8()
line_shader = hg.LoadProgramFromAssets("shaders/pos_rgb")

-- create material
pbr_shader = hg.LoadPipelineProgramRefFromAssets('core/shader/pbr.hps', res, hg.GetForwardPipelineInfo())
mat_grey = hg.CreateMaterial(pbr_shader, 'uBaseOpacityColor', hg.Vec4(1, 1, 1), 'uOcclusionRoughnessMetalnessColor', hg.Vec4(1, 0.5, 0.05))

-- create models
vtx_layout = hg.VertexLayoutPosFloatNormUInt8()

-- cube
-- cubeA_size =  hg.Vec3(1, 1, 1)
-- cubeA_ref = res:AddModel('cubeA', hg.CreateCubeModel(vtx_layout, cubeA_size.x, cubeA_size.y, cubeA_size.z))

-- cubeB_size = hg.Vec3(1, 1, 1)
-- cubeB_ref = res:AddModel('cubeB', hg.CreateCubeModel(vtx_layout, cubeB_size.x, cubeB_size.y, cubeB_size.z))

-- cubeC_size = hg.Vec3(1, 1, 1)
-- cubeC_ref = res:AddModel('cubeB', hg.CreateCubeModel(vtx_layout, cubeC_size.x, cubeC_size.y, cubeC_size.z))

-- -- ground
-- ground_size = hg.Vec3(4, 0.05, 4)
-- ground_ref = res:AddModel('ground', hg.CreateCubeModel(vtx_layout, ground_size.x, ground_size.y, ground_size.z))

-- setup the scene
scene = hg.Scene()
hg.LoadSceneFromAssets("cube/cube_remastered.scn", scene, res, hg.GetForwardPipelineInfo())


cam_mat = hg.TransformationMat4(hg.Vec3(0, 1.5, -5), hg.Vec3(hg.Deg(10), 0, 0))
cam = hg.CreateCamera(scene, cam_mat, 0.01, 1000)
view_matrix = hg.InverseFast(cam_mat)
c = cam:GetCamera()
projection_matrix = hg.ComputePerspectiveProjectionMatrix(c:GetZNear(), c:GetZFar(), hg.FovToZoomFactor(c:GetFov()), hg.Vec2(res_x / res_y, 1))

-- scene:SetCurrentCamera(cam)	

-- lgt = hg.CreateLinearLight(scene, hg.TransformationMat4(hg.Vec3(0, 0, 0), hg.Vec3(hg.Deg(30), hg.Deg(30), 0)), hg.Color(1, 1, 1), hg.Color(1, 1, 1), 10, hg.LST_Map, 0.0001, hg.Vec4(2, 4, 10, 16))

-- cubeA_node, cubeA_rb = CreatePhysicCubeEx(scene, cubeA_size, hg.TranslationMat4(hg.Vec3(0.0, 0.5, 0)), cubeA_ref, {mat_grey}, hg.RBT_Static, 0.0)
-- cubeA_rb:SetFriction(0.0)
-- cubeA_rb:SetLinearDamping(0.0)

-- cubeB_node, cubeB_rb = CreatePhysicCubeEx(scene, cubeB_size, hg.TranslationMat4(hg.Vec3(0.0, 2.5, 0)), cubeB_ref, {mat_grey}, hg.RBT_Dynamic, 0.1)
-- cubeB_rb:SetFriction(0.0)
-- cubeB_rb:SetLinearDamping(0.0)

-- cubeC_node, cubeC_rb = CreatePhysicCubeEx(scene, cubeC_size, hg.TranslationMat4(hg.Vec3(2.5, 0.5, 0)), cubeC_ref, {mat_grey}, hg.RBT_Dynamic, 0.1)
-- cubeC_rb:SetFriction(0.0)
-- cubeC_rb:SetLinearDamping(0.0)

-- ground_node, ground_rb = CreatePhysicCubeEx(scene, ground_size, hg.TranslationMat4(hg.Vec3(0, -0.005, 0)), ground_ref, {mat_grey}, hg.RBT_Static, 0)
-- ground_rb:SetFriction(0.0)



-- scene physics
physics = hg.SceneBullet3Physics()
physics:SceneCreatePhysicsFromAssets(scene)
physics_step = hg.time_from_sec_f(1 / 60)
dt_frame_step = hg.time_from_sec_f(1 / 60)

clocks = hg.SceneClocks()

--NODE A-B

-- nodeA_anchor = hg.TransformationMat4(hg.Vec3(0.0, 0.5, 0.0),  hg.Vec3(0.0, 0.0, 0.0))
-- nodeB_anchor = hg.TransformationMat4(hg.Vec3(0.0, -2.0, 0.0),  hg.Vec3(0.0, 0.0, 0.0))
-- physics:Add6DofConstraint(cubeA_node, cubeB_node, nodeA_anchor, nodeB_anchor)

-- nodeA_anchor = hg.TransformationMat4(hg.Vec3(0.5, 0.5, 0.0),   hg.Vec3(0.0, 0.0, 0.0))
-- nodeB_anchor = hg.TransformationMat4(hg.Vec3(0.5, -2.0, 0.0),   hg.Vec3(0.0, 0.0, 0.0))
-- physics:Add6DofConstraint(cubeA_node, cubeB_node, nodeA_anchor, nodeB_anchor)

-- nodeA_anchor = hg.TransformationMat4(hg.Vec3(0.5, 0.5, 0.5),  hg.Vec3(0.0, 0.0, 0.0))
-- nodeB_anchor = hg.TransformationMat4(hg.Vec3(0.5, -2.0, 0.5),  hg.Vec3(0.0, 0.0, 0.0))
-- physics:Add6DofConstraint(cubeA_node, cubeB_node, nodeA_anchor, nodeB_anchor)

-- --NODE A-C

-- nodeA_anchor = hg.TransformationMat4(hg.Vec3(0.5, -0.5, 0.0),  hg.Vec3(0.0, 0.0, 0.0))
-- nodeC_anchor = hg.TransformationMat4(hg.Vec3(0.0, -2.0, 0.0),  hg.Vec3(0.0, 0.0, 0.0))
-- physics:Add6DofConstraint(cubeA_node, cubeC_node, nodeA_anchor, nodeC_anchor)

-- nodeA_anchor = hg.TransformationMat4(hg.Vec3(0.5, 0.5, 0.5),   hg.Vec3(0.0, 0.0, 0.0))
-- nodeC_anchor = hg.TransformationMat4(hg.Vec3(0.5, -2.0, 0.0),   hg.Vec3(0.0, 0.0, 0.0))
-- physics:Add6DofConstraint(cubeA_node, cubeC_node, nodeA_anchor, nodeC_anchor)

-- nodeA_anchor = hg.TransformationMat4(hg.Vec3(0.5, 0.5, 0.5),  hg.Vec3(0.0, 0.0, 0.0))
-- nodeC_anchor = hg.TransformationMat4(hg.Vec3(0.5, -2.0, 0.5),  hg.Vec3(0.0, 0.0, 0.0))
-- physics:Add6DofConstraint(cubeA_node, cubeC_node, nodeA_anchor, nodeC_anchor)

-- description

-- main loop
keyboard = hg.Keyboard()

local frame_count = 0

while not keyboard:Down(hg.K_Escape) and hg.IsWindowOpen(win) do
    keyboard:Update()

    -- physics:NodeWake(cube_node)

    view_id = 0
    hg.SceneUpdateSystems(scene, clocks, dt_frame_step, physics, physics_step, 3)
    view_id, pass_id = hg.SubmitSceneToPipeline(view_id, scene, hg.IntRect(0, 0, res_x, res_y), true, pipeline, res)

    -- Debug physics display
    hg.SetViewClear(view_id, 0, 0, 1.0, 0)
    hg.SetViewRect(view_id, 0, 0, res_x, res_y)
    hg.SetViewTransform(view_id, view_matrix, projection_matrix)
    rs = hg.ComputeRenderState(hg.BM_Opaque, hg.DT_Disabled, hg.FC_Disabled)
    physics:RenderCollision(view_id, vtx_line_layout, line_shader, rs, 0)

    hg.Frame()
    hg.UpdateWindow(win)
end

scene:Clear()
scene:GarbageCollect()

hg.RenderShutdown()
hg.DestroyWindow(win)

hg.WindowSystemShutdown()
hg.InputShutdown()

