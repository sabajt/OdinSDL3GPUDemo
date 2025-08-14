# OdinSDL3GPUDemo
Small game engine example using SDL3 GPU and Odin.

## Fixed timestep game loop
To achieve a smooth 60 fps, the update and render loop is controlled with a fixed timestep: see the `AppIterate` function of `main.odin`. The implementation is based on Glenn Fiedler's article: https://gafferongames.com/post/fix_your_timestep/. 

The simulation runs precisely every 16 Milliseconds, via the `update()` function. The rendering (`render(dt)`) is decoupled from the the simulation update so will run as fast as needs to. The delta time is calculated using an accumulator (`lag_time`) and passed into the render function to interpolate everything which is drawn, so animations appear smooth.



