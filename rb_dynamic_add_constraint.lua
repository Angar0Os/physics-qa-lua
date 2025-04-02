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

function GetNodes(scene, paths)
    local nodes = {}
    for key, path in pairs(paths) do
        nodes[key] = scene:GetNodeEx(path)
    end
    return nodes
end

local node_paths = {
    chest = "chest",
    chest_bone = "chest/chest_bone",
    chest_joint_to_head = "chest/chest_joint_to_head",
    chest_joint_to_right_arm_2 = "chest/chest_joint_to_right_arm_2",
    chest_joint_to_right_arm_3 = "chest/chest_joint_to_right_arm_3",
    chest_joint_to_left_arm_2 = "chest/chest_joint_to_left_arm_2",
    chest_joint_to_left_arm_3 = "chest/chest_joint_to_left_arm_3",
    chest_joint_to_right_leg = "chest/chest_joint_to_right_leg",
    chest_joint_to_right_leg_2 = "chest/chest_joint_to_right_leg_2",
    chest_joint_to_right_leg_3 = "chest/chest_joint_to_right_leg_3",
    chest_joint_to_right_leg_4 = "chest/chest_joint_to_right_leg_4",
    chest_joint_to_left_leg = "chest/chest_joint_to_left_leg",
    chest_joint_to_left_leg_2 = "chest/chest_joint_to_left_leg_2",
    chest_joint_to_left_leg_3 = "chest/chest_joint_to_left_leg_3",
    chest_joint_to_left_leg_4 = "chest/chest_joint_to_left_leg_4",
    left_leg_joint_to_chest = "left_leg/left_leg_joint_to_chest",
    left_leg_joint_to_chest_2 = "left_leg/left_leg_joint_to_chest_2",
    left_leg_joint_to_chest_3 = "left_leg/left_leg_joint_to_chest_3",
    left_leg_joint_to_chest_4 = "left_leg/left_leg_joint_to_chest_4",
    right_leg_joint_to_chest = "right_leg/right_leg_joint_to_chest",
    right_leg_joint_to_chest_2 = "right_leg/right_leg_joint_to_chest_2",
    right_leg_joint_to_chest_3 = "right_leg/right_leg_joint_to_chest_3",
    right_leg_joint_to_chest_4 = "right_leg/right_leg_joint_to_chest_4",
    right_arm_joint_to_chest = "right_arm/right_arm_joint_to_chest",
    right_arm_joint_to_chest_2 = "right_arm/right_arm_joint_to_chest_2",
    left_arm_joint_to_chest = "left_arm/left_arm_joint_to_chest",
    left_arm_joint_to_chest_2 = "left_arm/left_arm_joint_to_chest_2",
    head_joint_to_chest = "head/head_joint_to_chest",
    left_leg_joint_to_ground = "left_leg/left_leg_joint_to_ground",
    left_leg_joint_to_ground_2 = "left_leg/left_leg_joint_to_ground_2",
    left_leg_joint_to_ground_3 = "left_leg/left_leg_joint_to_ground_3",
    right_leg_joint_to_ground = "right_leg/right_leg_joint_to_ground",
    right_leg_joint_to_ground_2 = "right_leg/right_leg_joint_to_ground_2",
    right_leg_joint_to_ground_3 = "right_leg/right_leg_joint_to_ground_3",
    ground_joint_to_left_leg = "ground/ground_joint_to_left_leg",
    ground_joint_to_left_leg_2 = "ground/ground_joint_to_left_leg_2",
    ground_joint_to_left_leg_3 = "ground/ground_joint_to_left_leg_3",
    ground_joint_to_right_leg = "ground/ground_joint_to_right_leg",
    ground_joint_to_right_leg_2 = "ground/ground_joint_to_right_leg_2",
    ground_joint_to_right_leg_3 = "ground/ground_joint_to_right_leg_3",
    right_arm = "right_arm",
    right_arm_bone = "right_arm/right_arm_bone",
    left_arm = "left_arm",
    left_arm_bone = "left_arm/left_arm_bone",
    right_leg = "right_leg",
    right_leg_bone = "right_leg/right_leg_bone",
    left_leg = "left_leg",
    left_leg_bone = "left_leg/left_leg_bone",
    head = "head",
    head_bone = "head/head_bone",
    ground = "ground"
}

function CreateAnchors(nodes, joints)
    local anchors = {}
    for key, joint in pairs(joints) do
        anchors[key] = hg.TransformationMat4(nodes[joint]:GetTransform():GetPos(), nodes[joint]:GetTransform():GetRot())
    end
    return anchors
end

local joint_paths = {
    right_arm_joint_anchor = "right_arm_joint_to_chest",
    right_arm_2_joint_anchor = "right_arm_joint_to_chest_2",
    left_arm_joint_anchor = "left_arm_joint_to_chest",
    left_arm_2_joint_anchor = "left_arm_joint_to_chest_2",
    right_leg_joint_anchor = "right_leg_joint_to_chest",
    right_leg_2_joint_anchor = "right_leg_joint_to_chest_2",
    right_leg_3_joint_anchor = "right_leg_joint_to_chest_3",
    right_leg_4_joint_anchor = "right_leg_joint_to_chest_4",
    left_leg_joint_anchor = "left_leg_joint_to_chest",
    left_leg_2_joint_anchor = "left_leg_joint_to_chest_2",
    left_leg_3_joint_anchor = "left_leg_joint_to_chest_3",
    left_leg_4_joint_anchor = "left_leg_joint_to_chest_4",
    head_joint_anchor = "head_joint_to_chest",
    chest_joint_to_head_anchor = "chest_joint_to_head",
    chest_joint_2_to_right_arm_anchor = "chest_joint_to_right_arm_2",
    chest_joint_3_to_right_arm_anchor = "chest_joint_to_right_arm_3",
    chest_joint_2_to_left_arm_anchor = "chest_joint_to_left_arm_2",
    chest_joint_3_to_left_arm_anchor = "chest_joint_to_left_arm_3",
    chest_joint_to_right_leg_anchor = "chest_joint_to_right_leg",
    chest_joint_2_to_right_leg_anchor = "chest_joint_to_right_leg_2",
    chest_joint_3_to_right_leg_anchor = "chest_joint_to_right_leg_3",
    chest_joint_4_to_right_leg_anchor = "chest_joint_to_right_leg_4",
    chest_joint_to_left_leg_anchor = "chest_joint_to_left_leg",
    chest_joint_2_to_left_leg_anchor = "chest_joint_to_left_leg_2",
    chest_joint_3_to_left_leg_anchor = "chest_joint_to_left_leg_3",
    chest_joint_4_to_left_leg_anchor = "chest_joint_to_left_leg_4",
    left_leg_5_joint_anchor = "left_leg_joint_to_ground",
    left_leg_6_joint_anchor = "left_leg_joint_to_ground_2",
    left_leg_7_joint_anchor = "left_leg_joint_to_ground_3",
    right_leg_5_joint_anchor = "right_leg_joint_to_ground",
    right_leg_6_joint_anchor = "right_leg_joint_to_ground_2",
    right_leg_7_joint_anchor = "right_leg_joint_to_ground_3",
    ground_joint_anchor = "ground_joint_to_left_leg",
    ground_joint_2_anchor = "ground_joint_to_left_leg_2",
    ground_joint_3_anchor = "ground_joint_to_left_leg_3",
    ground_joint_4_anchor = "ground_joint_to_right_leg",
    ground_joint_5_anchor = "ground_joint_to_right_leg_2",
    ground_joint_6_anchor = "ground_joint_to_right_leg_3",
}

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


cam_mat = hg.TransformationMat4(hg.Vec3(0, 5, -20), hg.Vec3(hg.Deg(10), 0, 0))
cam = hg.CreateCamera(scene, cam_mat, 0.01, 1000)
view_matrix = hg.InverseFast(cam_mat)
c = cam:GetCamera()
projection_matrix = hg.ComputePerspectiveProjectionMatrix(c:GetZNear(), c:GetZFar(), hg.FovToZoomFactor(c:GetFov()), hg.Vec2(res_x / res_y, 1))

scene:SetCurrentCamera(cam)	

-- scene physics
physics = hg.SceneBullet3Physics()
physics:SceneCreatePhysicsFromAssets(scene)
physics_step = hg.time_from_sec_f(1 / 60)
dt_frame_step = hg.time_from_sec_f(1 / 60)

clocks = hg.SceneClocks()


local nodes = GetNodes(scene, node_paths)
local anchors = CreateAnchors(nodes, joint_paths)

physics:Add6DofConstraint(nodes.chest, nodes.right_arm, anchors.chest_joint_2_to_right_arm_anchor, anchors.right_arm_joint_anchor)
physics:Add6DofConstraint(nodes.chest, nodes.right_arm, anchors.chest_joint_3_to_right_arm_anchor, anchors.right_arm_2_joint_anchor)
physics:Add6DofConstraint(nodes.chest, nodes.left_arm, anchors.chest_joint_2_to_left_arm_anchor, anchors.left_arm_joint_anchor)
physics:Add6DofConstraint(nodes.chest, nodes.left_arm, anchors.chest_joint_3_to_left_arm_anchor, anchors.left_arm_2_joint_anchor)
physics:Add6DofConstraint(nodes.chest, nodes.right_leg, anchors.chest_joint_to_right_leg_anchor, anchors.right_leg_joint_anchor)
physics:Add6DofConstraint(nodes.chest, nodes.right_leg, anchors.chest_joint_2_to_right_leg_anchor, anchors.right_leg_2_joint_anchor)
physics:Add6DofConstraint(nodes.chest, nodes.right_leg, anchors.chest_joint_3_to_right_leg_anchor, anchors.right_leg_3_joint_anchor)
physics:Add6DofConstraint(nodes.chest, nodes.left_leg, anchors.chest_joint_to_left_leg_anchor, anchors.left_leg_joint_anchor)
physics:Add6DofConstraint(nodes.chest, nodes.left_leg, anchors.chest_joint_2_to_left_leg_anchor, anchors.left_leg_2_joint_anchor)
physics:Add6DofConstraint(nodes.chest, nodes.left_leg, anchors.chest_joint_3_to_left_leg_anchor, anchors.left_leg_3_joint_anchor)
physics:Add6DofConstraint(nodes.chest, nodes.head, anchors.chest_joint_to_head_anchor, anchors.head_joint_anchor)

physics:Add6DofConstraint(nodes.left_leg, nodes.ground, anchors.left_leg_5_joint_anchor, anchors.ground_joint_anchor)
physics:Add6DofConstraint(nodes.left_leg, nodes.ground, anchors.left_leg_6_joint_anchor, anchors.ground_joint_2_anchor)
physics:Add6DofConstraint(nodes.left_leg, nodes.ground, anchors.left_leg_7_joint_anchor, anchors.ground_joint_3_anchor)
physics:Add6DofConstraint(nodes.right_leg, nodes.ground, anchors.right_leg_5_joint_anchor, anchors.ground_joint_4_anchor)
physics:Add6DofConstraint(nodes.right_leg, nodes.ground, anchors.right_leg_6_joint_anchor, anchors.ground_joint_5_anchor)
physics:Add6DofConstraint(nodes.right_leg, nodes.ground, anchors.right_leg_7_joint_anchor, anchors.ground_joint_6_anchor)


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

    physics:NodeWake(nodes.chest)

    view_id = 0
    hg.SceneUpdateSystems(scene, clocks, dt_frame_step, physics, physics_step, 3)
    view_id, pass_id = hg.SubmitSceneToPipeline(view_id, scene, hg.IntRect(0, 0, res_x, res_y), true, pipeline, res)

    -- -- Debug physics display
    -- hg.SetViewClear(view_id, 0, 0, 1.0, 0)
    -- hg.SetViewRect(view_id, 0, 0, res_x, res_y)
    -- hg.SetViewTransform(view_id, view_matrix, projection_matrix)
    -- rs = hg.ComputeRenderState(hg.BM_Opaque, hg.DT_Disabled, hg.FC_Disabled)
    -- physics:RenderCollision(view_id, vtx_line_layout, line_shader, rs, 0)

    hg.Frame()
    hg.UpdateWindow(win)
end

scene:Clear()
scene:GarbageCollect()

hg.RenderShutdown()
hg.DestroyWindow(win)

hg.WindowSystemShutdown()
hg.InputShutdown()

