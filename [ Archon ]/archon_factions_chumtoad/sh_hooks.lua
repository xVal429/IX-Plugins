local PLUGIN = PLUGIN

ix.anim.chumtoad = {
    normal = {
        [ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
        [ACT_MP_CROUCH_IDLE] = {ACT_IDLE, ACT_IDLE},
        [ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
        [ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
        [ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
        [ACT_MP_JUMP] = {ACT_DIEVIOLENT, ACT_DIEVIOLENT},
        [ACT_MP_SWIM] = {ACT_SWIM, ACT_SWIM},
    },
}
ix.anim.SetModelClass("models/vj_hlr/hl1/chumtoad.mdl", "chumtoad")