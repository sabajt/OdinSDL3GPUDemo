package main

vert_ref_a : Vert_Ref
vert_ref_d : Vert_Ref
vert_ref_e : Vert_Ref
vert_ref_g : Vert_Ref
vert_ref_i : Vert_Ref
vert_ref_m : Vert_Ref
vert_ref_n : Vert_Ref
vert_ref_p : Vert_Ref
vert_ref_r : Vert_Ref
vert_ref_s : Vert_Ref
vert_ref_t : Vert_Ref
vert_ref_u : Vert_Ref
vert_ref_v : Vert_Ref
vert_ref_z : Vert_Ref

Vert_Ref :: struct {
	i: int,
	len: int
}

pack_shared_letter_verts :: proc()
{
	// A

	verts := []Batch_Shape_Vertex {
		// top h
		{position = {0, 57}, color = COL_WHITE},
		{position = {60, 57}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		{position = {60, 57}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// left v
		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 0}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},

		{position = {0, 0}, color = COL_WHITE},
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
	ref := pack_vert_ref(verts[:])
	vert_ref_a = { i = ref, len = len(verts) }

	// D

	verts = []Batch_Shape_Vertex {
		// top left h 
		{position = {0, 57}, color = COL_WHITE},
		{position = {30, 57}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		{position = {30, 57}, color = COL_WHITE},
		{position = {30, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// bottom left h 
		{position = {0, 0}, color = COL_WHITE},
		{position = {30, 0}, color = COL_WHITE},
		{position = {0, 3}, color = COL_WHITE},

		{position = {30, 0}, color = COL_WHITE},
		{position = {30, 3}, color = COL_WHITE},
		{position = {0, 3}, color = COL_WHITE},

		// left v
		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 0}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},

		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// right mid v
		{position = {57, 20}, color = COL_WHITE},
		{position = {60, 20}, color = COL_WHITE},
		{position = {60, 40}, color = COL_WHITE},

		{position = {57, 20}, color = COL_WHITE},
		{position = {60, 40}, color = COL_WHITE},
		{position = {57, 40}, color = COL_WHITE},

		// diag right top corner
		{position = {27, 57}, color = COL_WHITE},
		{position = {57, 37}, color = COL_WHITE},
		{position = {60, 40}, color = COL_WHITE},

		{position = {27, 57}, color = COL_WHITE},
		{position = {60, 40}, color = COL_WHITE},
		{position = {30, 60}, color = COL_WHITE},

		// diag right bottom corner
		{position = {27, 3}, color = COL_WHITE},
		{position = {57, 23}, color = COL_WHITE},
		{position = {60, 20}, color = COL_WHITE},

		{position = {27, 3}, color = COL_WHITE},
		{position = {60, 20}, color = COL_WHITE},
		{position = {30, 0}, color = COL_WHITE},
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_d = { i = ref, len = len(verts) }

	// E

	verts = []Batch_Shape_Vertex {
		// left v
		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 0}, color = COL_WHITE},
		{position = {3, 57}, color = COL_WHITE},

		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 57}, color = COL_WHITE},
		{position = {0, 57}, color = COL_WHITE},

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
	vert_ref_e = { i = ref, len = len(verts) }

	// G

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

		// mid right h
		{position = {28, 29}, color = COL_WHITE},
		{position = {60, 29}, color = COL_WHITE},
		{position = {28, 32}, color = COL_WHITE},

		{position = {60, 29}, color = COL_WHITE},
		{position = {60, 32}, color = COL_WHITE},
		{position = {28, 32}, color = COL_WHITE},

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
	vert_ref_g = { i = ref, len = len(verts) }

	// I

	verts = []Batch_Shape_Vertex {
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

		// mid v
		{position = {28, 0}, color = COL_WHITE},
		{position = {31, 0}, color = COL_WHITE},
		{position = {31, 60}, color = COL_WHITE},

		{position = {28, 0}, color = COL_WHITE},
		{position = {31, 60}, color = COL_WHITE},
		{position = {28, 60}, color = COL_WHITE},
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_i = { i = ref, len = len(verts) }

	// M

	verts = []Batch_Shape_Vertex {

		// top h
		{position = {0, 57}, color = COL_WHITE},
		{position = {60, 57}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		{position = {60, 57}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// left v
		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 0}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},

		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// right v
		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 0}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},

		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {57, 60}, color = COL_WHITE},

		// mid v
		{position = {28, 0}, color = COL_WHITE},
		{position = {31, 0}, color = COL_WHITE},
		{position = {31, 60}, color = COL_WHITE},

		{position = {28, 0}, color = COL_WHITE},
		{position = {31, 60}, color = COL_WHITE},
		{position = {28, 60}, color = COL_WHITE},
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_m = { i = ref, len = len(verts) }

	// N

	verts = []Batch_Shape_Vertex {

		// left v
		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 0}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},

		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// right v
		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 0}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},

		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {57, 60}, color = COL_WHITE},

		// diag tl <> br
		{position = {57, 0}, color = COL_WHITE},
		{position = {59, 3}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},

		{position = {57, 0}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},
		{position = {1, 57}, color = COL_WHITE},
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_n = { i = ref, len = len(verts) }

	// P

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

		// left
		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 0}, color = COL_WHITE},
		{position = {3, 57}, color = COL_WHITE},

		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 57},  color = COL_WHITE},
		{position = {0, 57}, color = COL_WHITE},

		// right
		{position = {57, 32}, color = COL_WHITE},
		{position = {60, 32}, color = COL_WHITE},
		{position = {60, 57}, color = COL_WHITE},

		{position = {57, 32}, color = COL_WHITE},
		{position = {60, 57}, color = COL_WHITE},
		{position = {57, 57}, color = COL_WHITE},
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_p = { i = ref, len = len(verts) }

	// R

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

		// left
		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 0}, color = COL_WHITE},
		{position = {3, 57}, color = COL_WHITE},

		{position = {0, 0}, color = COL_WHITE},
		{position = {3, 57},  color = COL_WHITE},
		{position = {0, 57}, color = COL_WHITE},

		// right
		{position = {57, 32}, color = COL_WHITE},
		{position = {60, 32}, color = COL_WHITE},
		{position = {60, 57}, color = COL_WHITE},

		{position = {57, 32}, color = COL_WHITE},
		{position = {60, 57}, color = COL_WHITE},
		{position = {57, 57}, color = COL_WHITE},

		// tail (bottom right)
		{position = {0, 28}, color =COL_WHITE},
		{position = {56, 0}, color = COL_WHITE},
		{position = {59, 3}, color = COL_WHITE},

		{position = {59, 3}, color = COL_WHITE},
		{position = {3, 31}, color = COL_WHITE},
		{position = {0, 28}, color = COL_WHITE},
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_r = { i = ref, len = len(verts) }

	// S

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

		// top left v
		{position = {0, 32}, color = COL_WHITE},
		{position = {3, 32}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},

		{position = {0, 32}, color = COL_WHITE},
		{position = {3, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// bottom right v
		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 0}, color = COL_WHITE},
		{position = {60, 29}, color = COL_WHITE},

		{position = {57, 0}, color = COL_WHITE},
		{position = {60, 29}, color = COL_WHITE},
		{position = {57, 29}, color = COL_WHITE},
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_s = { i = ref, len = len(verts) }

	// T

	verts = []Batch_Shape_Vertex {
		// top h
		{position = {0, 57}, color = COL_WHITE},
		{position = {60, 57}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		{position = {60, 57}, color = COL_WHITE},
		{position = {60, 60}, color = COL_WHITE},
		{position = {0, 60}, color = COL_WHITE},

		// mid v
		{position = {28, 0}, color = COL_WHITE},
		{position = {31, 0}, color = COL_WHITE},
		{position = {31, 60}, color = COL_WHITE},

		{position = {28, 0}, color = COL_WHITE},
		{position = {31, 60}, color = COL_WHITE},
		{position = {28, 60}, color = COL_WHITE},
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_t = { i = ref, len = len(verts) }

	// U

	verts = []Batch_Shape_Vertex {

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
	vert_ref_u = { i = ref, len = len(verts) }

	// V

	verts = []Batch_Shape_Vertex {

		// diag left half
		{position = {0, 57}, color = COL_WHITE},
		{position = {28, 1}, color = COL_WHITE},
		{position = {32, 2}, color = COL_WHITE},

		{position = {0, 57}, color = COL_WHITE},
		{position = {32, 2}, color = COL_WHITE},
		{position = {4, 58}, color = COL_WHITE},

		// diag right half
		{position = {60, 57}, color = COL_WHITE},
		{position = {32, 1}, color = COL_WHITE},
		{position = {28, 2}, color = COL_WHITE},

		{position = {60, 57}, color = COL_WHITE},
		{position = {28, 2}, color = COL_WHITE},
		{position = {56, 58}, color = COL_WHITE},

	}
	ref = pack_vert_ref(verts[:])
	vert_ref_v = { i = ref, len = len(verts) }

	// Z

	verts = []Batch_Shape_Vertex {

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

		// diag tr <> bl
		{position = {3, 0}, color = COL_WHITE},
		{position = {1, 3}, color = COL_WHITE},
		{position = {57, 60}, color = COL_WHITE},

		{position = {3, 0}, color = COL_WHITE},
		{position = {57, 60}, color = COL_WHITE},
		{position = {59, 57}, color = COL_WHITE},	
	}
	ref = pack_vert_ref(verts[:])
	vert_ref_z = { i = ref, len = len(verts) }

}
