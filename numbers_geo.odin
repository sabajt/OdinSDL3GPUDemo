package main

vert_ref_0 : Vert_Ref
vert_ref_1 : Vert_Ref
vert_ref_2 : Vert_Ref
vert_ref_3 : Vert_Ref
vert_ref_4 : Vert_Ref
// 5 is just S
vert_ref_6 : Vert_Ref
vert_ref_7 : Vert_Ref
vert_ref_8 : Vert_Ref
vert_ref_9 : Vert_Ref

pack_shared_number_verts :: proc()
{
	// 0

	verts := []Batch_Shape_Vertex {
		// top h
		{position = {0, 57}, color = COL_WHITE},
		{position = {60, 57}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		{position = {60, 57}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// bottom h
		{position = {0, 0}, color = COL_WHITE},
		{position = {60, 0}, color = COL_WHITE},
		{position = {0, 3}, color = COL_WHITE},

		{position = {60, 0}, color = COL_WHITE},
		{position = {60, 3}, color = COL_WHITE},
		{position = {0, 3}, color = COL_WHITE},

		// left v
		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 0}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},

		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 60},  color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// right v
		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 0}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},

		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {57, 60}, color = COL_WHITE},
	}
	ref := pack_vert_ref(verts[:])
	vert_ref_0 = { i = ref, len = len(verts) }

	// 1

	verts = []Batch_Shape_Vertex {
		// mid v
		{position = {28, 0}, color = COL_WHITE},
		{position = {31, 0}, color = COL_WHITE},
		{position = {31, 60}, color = COL_WHITE},

		{position = {28, 0}, color = COL_WHITE},
		{position = {31, 60}, color = COL_WHITE},
		{position = {28, 60}, color = COL_WHITE},
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_1 = { i = ref, len = len(verts) }

	// 2

	verts = []Batch_Shape_Vertex {
		// top h
		{position = {0, 57}, color = COL_WHITE},
		{position = {60, 57}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		{position = {60, 57}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// mid h
		{position = {0, 29}, color = COL_WHITE},
		{position = {60, 29}, color = COL_WHITE},
		{position = {0, 32}, color = COL_WHITE},

		{position = {60, 29}, color = COL_WHITE},
		{position = {60, 32}, color = COL_WHITE},
		{position = {0, 32}, color = COL_WHITE},

		// bottom h
		{position = {0, 0}, color = COL_WHITE},
		{position = {60, 0}, color = COL_WHITE},
		{position = {0, 3}, color = COL_WHITE},

		{position = {60, 0}, color = COL_WHITE},
		{position = {60, 3}, color = COL_WHITE},
		{position = {0, 3}, color = COL_WHITE},

		// top right v
		{position = {57, 32}, color = COL_WHITE},
		{position = {60, 32}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},

		{position = {57, 32}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {57, 60}, color = COL_WHITE},

		// bottom left v
		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 0}, color = COL_WHITE},
		{position = {3, 29}, color = COL_WHITE},

		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 29}, color = COL_WHITE},
		{position = {0, 29}, color = COL_WHITE},
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_2 = { i = ref, len = len(verts) }

	// 3

	verts = []Batch_Shape_Vertex {
		// right v
		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 0}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},

		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {57, 60}, color = COL_WHITE},

		// top h
		{position = {0, 57}, color = COL_WHITE},
		{position = {60, 57}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		{position = {60, 57}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// mid h
		{position = {0, 29}, color = COL_WHITE},
		{position = {60, 29}, color = COL_WHITE},
		{position = {0, 32}, color = COL_WHITE},

		{position = {60, 29}, color = COL_WHITE},
		{position = {60, 32}, color = COL_WHITE},
		{position = {0, 32}, color = COL_WHITE},

		// bottom
		{position = {0, 0}, color = COL_WHITE},
		{position = {60, 0}, color = COL_WHITE},
		{position = {0, 3}, color = COL_WHITE},

		{position = {60, 0}, color = COL_WHITE},
		{position = {60, 3}, color = COL_WHITE},
		{position = {0, 3}, color = COL_WHITE},
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_3 = { i = ref, len = len(verts) }

	// 4

	verts = []Batch_Shape_Vertex {
		// top left v
		{position = {0, 32}, color = COL_WHITE},
		{position = {3, 32}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},

		{position = {0, 32}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// right v
		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 0}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},

		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {57, 60}, color = COL_WHITE},

		// mid h
		{position = {0, 29}, color = COL_WHITE},
		{position = {60, 29}, color = COL_WHITE},
		{position = {0, 32}, color = COL_WHITE},

		{position = {60, 29}, color = COL_WHITE},
		{position = {60, 32}, color = COL_WHITE},
		{position = {0, 32}, color = COL_WHITE},
	}

	ref = pack_vert_ref(verts[:])
	vert_ref_4 = { i = ref, len = len(verts) }

	// 6

	verts = []Batch_Shape_Vertex {
		// left v
		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 0}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},

		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 60},  color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// top h
		{position = {0, 57}, color = COL_WHITE},
		{position = {60, 57}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		{position = {60, 57}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// mid h
		{position = {0, 29}, color = COL_WHITE},
		{position = {60, 29}, color = COL_WHITE},
		{position = {0, 32}, color = COL_WHITE},

		{position = {60, 29}, color = COL_WHITE},
		{position = {60, 32}, color = COL_WHITE},
		{position = {0, 32}, color = COL_WHITE},

		// bottom h
		{position = {0, 0}, color = COL_WHITE},
		{position = {60, 0}, color = COL_WHITE},
		{position = {0, 3}, color = COL_WHITE},

		{position = {60, 0}, color = COL_WHITE},
		{position = {60, 3}, color = COL_WHITE},
		{position = {0, 3}, color = COL_WHITE},

		// bottom right v
		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 0}, color = COL_WHITE},
		{position = {60, 29}, color = COL_WHITE},

		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 29}, color = COL_WHITE},
		{position = {57, 29}, color = COL_WHITE},
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_6 = { i = ref, len = len(verts) }

	// 7

	verts = []Batch_Shape_Vertex {
		// top h
		{position = {0, 57}, color = COL_WHITE},
		{position = {60, 57}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		{position = {60, 57}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// diag tr <> bl
		{position = {3, 0}, color = COL_WHITE},
		{position = {1, 3}, color = COL_WHITE},
		{position = {57, 60}, color = COL_WHITE},

		{position = {3, 0}, color = COL_WHITE},
		{position = {57, 60}, color = COL_WHITE},
		{position = {59, 57}, color = COL_WHITE},	
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_7 = { i = ref, len = len(verts) }

	// 8

	verts = []Batch_Shape_Vertex {
		// top h
		{position = {0, 57}, color = COL_WHITE},
		{position = {60, 57}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		{position = {60, 57}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// mid h
		{position = {0, 29}, color = COL_WHITE},
		{position = {60, 29}, color = COL_WHITE},
		{position = {0, 32}, color = COL_WHITE},

		{position = {60, 29}, color = COL_WHITE},
		{position = {60, 32}, color = COL_WHITE},
		{position = {0, 32}, color = COL_WHITE},

		// bottom h
		{position = {0, 0}, color = COL_WHITE},
		{position = {60, 0}, color = COL_WHITE},
		{position = {0, 3}, color = COL_WHITE},

		{position = {60, 0}, color = COL_WHITE},
		{position = {60, 3}, color = COL_WHITE},
		{position = {0, 3}, color = COL_WHITE},

		// left v
		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 0}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},

		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 60},  color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// right v
		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 0}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},

		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {57, 60}, color = COL_WHITE},
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_8 = { i = ref, len = len(verts) }

	// 9

	verts = []Batch_Shape_Vertex {
		// top h
		{position = {0, 57}, color = COL_WHITE},
		{position = {60, 57}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		{position = {60, 57}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// mid h
		{position = {0, 29}, color = COL_WHITE},
		{position = {60, 29}, color = COL_WHITE},
		{position = {0, 32}, color = COL_WHITE},

		{position = {60, 29}, color = COL_WHITE},
		{position = {60, 32}, color = COL_WHITE},
		{position = {0, 32}, color = COL_WHITE},

		// top left v
		{position = {0, 32}, color = COL_WHITE},
		{position = {3, 32}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},

		{position = {0, 32}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// right v
		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 0}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},

		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {57, 60}, color = COL_WHITE},
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_9 = { i = ref, len = len(verts) }
}


