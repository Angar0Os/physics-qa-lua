hg = require("harfang")

-- helpers

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

-- sample

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
local pbr_shader = hg.LoadPipelineProgramRefFromAssets('core/shader/pbr.hps', res, hg.GetForwardPipelineInfo())
local mat_grey = hg.CreateMaterial(pbr_shader, 'uBaseOpacityColor', hg.Vec4(1, 1, 1), 'uOcclusionRoughnessMetalnessColor', hg.Vec4(1, 0.5, 0.05))

-- create models
local vtx_layout = hg.VertexLayoutPosFloatNormUInt8()

local cube_size =  hg.Vec3(1, 1, 1)
local cube_ref = res:AddModel('cube', hg.CreateCubeModel(vtx_layout, cube_size.x, cube_size.y, cube_size.z))

local ground_size = hg.Vec3(4, 0.05, 4)
local ground_ref = res:AddModel('ground', hg.CreateCubeModel(vtx_layout, ground_size.x, ground_size.y, ground_size.z))

-- setup scene
local scene = hg.Scene()

local cam_mat = hg.TransformationMat4(hg.Vec3(0, 1.5, -5), hg.Vec3(hg.Deg(10), 0, 0))
local cam = hg.CreateCamera(scene, cam_mat, 0.01, 1000)
local view_matrix = hg.InverseFast(cam_mat)
local c = cam:GetCamera()
local projection_matrix = hg.ComputePerspectiveProjectionMatrix(c:GetZNear(), c:GetZFar(), hg.FovToZoomFactor(c:GetFov()), hg.Vec2(res_x / res_y, 1))

scene:SetCurrentCamera(cam)	

local lgt = hg.CreateLinearLight(scene, hg.TransformationMat4(hg.Vec3(0, 0, 0), hg.Vec3(hg.Deg(30), hg.Deg(30), 0)), hg.Color(1, 1, 1), hg.Color(1, 1, 1), 10, hg.LST_Map, 0.0001, hg.Vec4(2, 4, 10, 16))

local cube_node, cube_rb = CreatePhysicCubeEx(scene, cube_size, hg.TranslationMat4(hg.Vec3(1.5, 0.5, 0)), cube_ref, {mat_grey}, hg.RBT_Dynamic, 1.0)
cube_rb:SetFriction(0.0)
cube_rb:SetLinearDamping(0.0)
local ground_node, ground_rb = CreatePhysicCubeEx(scene, ground_size, hg.TranslationMat4(hg.Vec3(0, -0.005, 0)), ground_ref, {mat_grey}, hg.RBT_Static, 0)
ground_rb:SetFriction(0.0)

local clocks = hg.SceneClocks()

-- scene physics
local physics = hg.SceneBullet3Physics()
physics:SceneCreatePhysicsFromAssets(scene)
local physics_step = hg.time_from_sec_f(1 / 60)
local display_physics_debug = true

-- main loop
local keyboard = hg.Keyboard()

while not keyboard:Down(hg.K_Escape) and hg.IsWindowOpen(win) do
    keyboard:Update()

    local view_id = 0
    local lines = {}

    local dt = hg.TickClock()

    local F = hg.Vec3(-1.0,0,0) -- vector for force/impulse
    local P = hg.GetTranslation(cube_node:GetTransform():GetWorld())
    table.insert(lines, {pos_a = P, pos_b = P + F, color = hg.Color.Red})				
    physics:NodeAddForce(cube_node, F)

    -- if physics_node_wake then
    --     physics:NodeWake(cube_node)
    -- end

    hg.SceneUpdateSystems(scene, clocks, dt, physics, physics_step, 3)
    view_id, pass_id = hg.SubmitSceneToPipeline(view_id, scene, hg.IntRect(0, 0, res_x, res_y), true, pipeline, res)

    -- debug draw lines
    local opaque_view_id = hg.GetSceneForwardPipelinePassViewId(pass_id, hg.SFPP_Opaque)
    for i=1, #lines do
        local vtx = hg.Vertices(vtx_line_layout, 2)
        vtx:Begin(0):SetPos(lines[i].pos_a):SetColor0(lines[i].color):End()
        vtx:Begin(1):SetPos(lines[i].pos_b):SetColor0(lines[i].color):End()
        hg.DrawLines(opaque_view_id, vtx, line_shader)
    end

    -- -- Debug physics display
    if display_physics_debug then
        hg.SetViewClear(view_id, 0, 0, 1.0, 0)
        hg.SetViewRect(view_id, 0, 0, res_x, res_y)
        hg.SetViewTransform(view_id, view_matrix, projection_matrix)
        local rs = hg.ComputeRenderState(hg.BM_Opaque, hg.DT_Disabled, hg.FC_Disabled)
        physics:RenderCollision(view_id, vtx_line_layout, line_shader, rs, 0)
    end

    hg.Frame()
    hg.UpdateWindow(win)
end

scene:Clear()
scene:GarbageCollect()

hg.RenderShutdown()
hg.DestroyWindow(win)

hg.WindowSystemShutdown()
hg.InputShutdown()