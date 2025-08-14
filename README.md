# OdinSDL3GPUDemo
Small game engine example using SDL3 GPU and Odin. This is a 2 player asteroids-like game featuring screen wrapping, waves of unique enemies and supports thousands of models / particles on the screen at once.

## Fixed timestep game loop
To achieve a smooth 60 fps, the update and render loop is controlled with a fixed timestep: see the `AppIterate` function of `main.odin`. The implementation is based on Glenn Fiedler's article: https://gafferongames.com/post/fix_your_timestep/. 

The simulation runs precisely every 16 Milliseconds, via the `update()` function. The rendering (`render(dt)`) is decoupled from the the simulation update so will run as fast as needs to. The delta time is calculated using an accumulator (`lag_time`) and passed into the render function to interpolate everything which is drawn, so animations appear smooth. Here is an example of interpolating previous and current rendering from `pack_radius_particle`:

```
rad := math.lerp(p.rad_start, p.rad_end, blend_t)
rot := math.lerp(p.rot_start, p.rot_end, blend_t)
col := math.lerp(p.col_start, p.col_end, blend_t)
```

## Geometry based graphics
This example does not include any textures as images rendering, except for TTF text. The models are either hard coded vertices, or generated in code based on points of a circle. See `pack_geo_collider.odin` for how the circle-based vertices are constructed. 

## Batch rendering with arbitrary geometry
Most of the models are drawn in just a couple draw calls for performance. This means that thousands of models can be drawn to the screen at once with no issue. The technique I used is based off of Evan Hemsley's sprite batching article https://moonside.games/posts/sdl-gpu-sprite-batcher/.

The batched draw calls are found in `render.odin`, lines `190` and `205`. In order to prepare the CPU data for transfer to the GPU in this pipeline, the various `pack` functions fill arrays with models and vertices before each render pass.

The shader used for batching is `BatchShape.vert.hlsl`, and uses 2 storage buffers to hold the model and vertex data. Instead of passing in vertex data via `Input`, the input in this case is a pair of model and vertex indexes that can then be read from the storage buffers during shader execution. This allows the geometry to be flexible (we aren't just batching quads here), but still have the benefits of minimal draw calls to the GPU.

## Simple physics
There is no physics library used here, just simple movement based on velocity and acceleration. `update_player_1` is an example of this.

