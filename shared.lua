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

function CreateMaterialPackFromResources(pbr_shader, res)
	local mat_grey = hg.CreateMaterial(pbr_shader, 'uBaseOpacityColor', hg.Vec4(1, 1, 1), 'uOcclusionRoughnessMetalnessColor', hg.Vec4(1, 0.5, 0.05))
	local mat_red = hg.CreateMaterial(pbr_shader, 'uBaseOpacityColor', hg.Vec4(1, 0.2, 0.1), 'uOcclusionRoughnessMetalnessColor', hg.Vec4(1, 0.25, 0.1))
	local mat_yellow = hg.CreateMaterial(pbr_shader, 'uBaseOpacityColor', hg.Vec4(0.8, 0.1, 0.0), 'uOcclusionRoughnessMetalnessColor', hg.Vec4(1, 0.5, 0.1))
	return mat_grey, mat_red, mat_yellow
end