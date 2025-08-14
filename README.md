# OdinSDL3GPUDemo
Small game engine example using SDL3 GPU and Odin. This is a 2 player asteroids-like game featuring screen wrapping, waves of unique enemies and supports thousands of models / particles on the screen at once.

## Fixed timestep game loop
To achieve a smooth 60 fps, the update and render loop is controlled with a fixed timestep: see the [AppIterate](https://github.com/sabajt/OdinSDL3GPUDemo/blob/a42ef477e8316791aea1f4622b25cacd9df50ca8/main.odin#L58) function of `main.odin`. The implementation is based on Glenn Fiedler's article: https://gafferongames.com/post/fix_your_timestep/, and has the nice property of creating deterministic simulations.

The simulation runs precisely every 16 Milliseconds, via the [update](https://github.com/sabajt/OdinSDL3GPUDemo/blob/a42ef477e8316791aea1f4622b25cacd9df50ca8/update.odin#L7) function. The [rendering function](https://github.com/sabajt/OdinSDL3GPUDemo/blob/a42ef477e8316791aea1f4622b25cacd9df50ca8/render.odin#L10C1-L10C7) is decoupled from the the simulation update so will run as frequently as possible. Delta time is calculated using an accumulator, `lag_time`, and passed into the render function to interpolate everything which is drawn, so animations appear smooth. Here is an example of interpolating previous and current rendering from [pack_radius_particle](https://github.com/sabajt/OdinSDL3GPUDemo/blob/a42ef477e8316791aea1f4622b25cacd9df50ca8/pack_particle.odin#L31):

```
blend_t := math.lerp(p.last_t, p.t, dt)

rad := math.lerp(p.rad_start, p.rad_end, blend_t)
rot := math.lerp(p.rot_start, p.rot_end, blend_t)
col := math.lerp(p.col_start, p.col_end, blend_t)
```

## Geometry based graphics
This example does not include any textures as images rendering, except for TTF text. The models are either hard coded vertices, or generated in code based on points of a circle. The [pack_radius_particle](https://github.com/sabajt/OdinSDL3GPUDemo/blob/a42ef477e8316791aea1f4622b25cacd9df50ca8/pack_particle.odin#L31) function is an example of building a circle-based model.   

## Batch rendering with arbitrary geometry
Most of the models are drawn in just a couple draw calls for performance. This means that thousands of models can be drawn to the screen at once with no issue. The technique I used is based off of Evan Hemsley's sprite batching article https://moonside.games/posts/sdl-gpu-sprite-batcher/.

The batched draw calls are found in [render.odin](https://github.com/sabajt/OdinSDL3GPUDemo/blob/main/render.odin), lines [190](https://github.com/sabajt/OdinSDL3GPUDemo/blob/a42ef477e8316791aea1f4622b25cacd9df50ca8/render.odin#L190) and [205](https://github.com/sabajt/OdinSDL3GPUDemo/blob/a42ef477e8316791aea1f4622b25cacd9df50ca8/render.odin#L205). In order to prepare the CPU data for transfer to the GPU in this pipeline, the various [pack](https://github.com/sabajt/OdinSDL3GPUDemo/blob/main/pack.odin) functions fill arrays with models and vertices before each render pass.

The shader used for batching is [BatchShape.vert.hlsl](https://github.com/sabajt/OdinSDL3GPUDemo/blob/main/shaders/source/BatchShape.vert.hlsl), and uses 2 storage buffers to hold the model and vertex data. Instead of passing in vertex data via `Input`, the input in this case is a pair of model and vertex indexes that can then be read from the storage buffers during shader execution. This allows the geometry to be flexible (we aren't just batching quads here), but still have the benefits of minimal draw calls to the GPU.

## SDF rendering pipeline
[SDFQuad.frag.hlsl](https://github.com/sabajt/OdinSDL3GPUDemo/blob/main/shaders/source/SDFQuad.frag.hlsl) shows how circles for particles are rendered using a signed distance field. This rendering pipeline could be extended to support other SDF shapes such as the ones described here: https://iquilezles.org/articles/distfunctions2d/

## Simple physics
There is no physics library used here, just simple movement based on velocity and acceleration. [update_player_1](https://github.com/sabajt/OdinSDL3GPUDemo/blob/main/update_player_1.odin) is an example of this. Note that player 2 has a different control scheme, movement and attack style.

