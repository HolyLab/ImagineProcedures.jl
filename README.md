# ImagineProcedures

This package exports the types `SignalGenerator` and `ImagineProcedure`.

A `SignalGenerator` is simply a [CachedCall](https://github.com/HolyLab/CachedCalls.jl) designated to return a vector of ImagineSignals. (ImagineSignals are exported by [ImagineInterface](https://github.com/HolyLab/ImagineInterface) and can be run on microscope hardware using either [Imagine](https://github.com/HolyLab/Imagine.git) or [Imagine.jl](https://github.com/HolyLab/Imagine.jl.git)).  SignalGenerators are useful when one wants to store and regenerate a set of ImagineSignals on demand without having to save a command file.

An `ImagineProcedure` is a formal way of linking a particular set of microscope commands with a function that analyzes the results of running those commands.  ImagineProcedures can make it easier to repeat a particular recording and analysis.  Specific applications include storage of repeatable microscope [calibration](https://github.com/HolyLab/ImagineCalibrate.jl.git) and [test](https://github.com/HolyLab/ImagineOfflineTesting.jl.git) procedures.  They also may be a convenient way to store repeatable scientific experiments that use Imagine.

Currently Imagine runs "offline", meaning that microscope recordings cannot be planned, run, and analyzed within the same script.  Instead we store command file and result files when sending information to and from Imagine, respectively.  Thus running an ImagineProcedure is a three-step process:
 1. Generate commands with `outputs(p::ImagineProcedure)` and save them to a file.
 2. Load the file in Imagine and perform the recording.
 3. Load the recording files from Imagine and run the procedure's analysis function with `process(p::ImagineProcedure, args...)`.  The user need not include microscope commands in `args...` because they are generated from the ImagineProcedure's `SignalGenerator` field and passed automatically as the first argument.  Therefore the analysis function of an ImagineProcedure must take at minimum one argument.  Currently there are no constraints on what _additional_ arguments may be passed to the procedure's analysis function via `args...`, but typically they will include acquired images and/or other hardware signals recorded by Imagine.
