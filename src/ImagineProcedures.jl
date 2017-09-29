module ImagineProcedures

using Unitful

using ImagineInterface

using CachedCalls
import CachedCalls.CachedCall

export SignalGenerator,
        ImagineProcedure,
        outputs,
        process

#This is just a CachedCall with a Vector{ImagineSignal} return type
const SignalGenerator{F, A} = CachedCall{F, A, Vector{ImagineSignal}}
SignalGenerator(description::String, f::F, args::A) where {F<:Function, A} = SignalGenerator{F, A}(description, f, args, Nullable{Vector{ImagineSignal}}())
SignalGenerator(f::F, args::A) where {F<:Function, A} = SignalGenerator("", f, args)

#An ImagineProcedure couples a function for generating command signals with a function for analyzing those commands in the context of something else.
#Typically "something else" is one or more results of running those commands on the microscope (analog and digital signal recordings, camera images).
#This design was chosen because currently Imagine can't be operated directly from Julia, but we would still like to store a repeatable set of procedures
#(for example testing and calibration procedures).  It _may_ also prove useful for standardizing storage of scientific experiments and their analyses.
#user-facing api is outputs() for getting a set of output commands and process(args...) for running its analyze function with the outputs as first argument + set of other args
#therefore when creating an ImagineProcedure it is critical that the analyze() function expects a set of output signals as its first argument
struct ImagineProcedure
    description::String
    sig_gen::SignalGenerator #SignalGenerator generates signals to be run with Imagine
    analyze::Function #a function of call!(sig_gen) and one or more args
end

#getters. probably wont' export?
description(ip::ImagineProcedure) = ip.description
signal_generator(ip::ImagineProcedure) = ip.sig_gen
analyze_function(ip::ImagineProcedure) = ip.analyze

outputs(ip::ImagineProcedure) = call!(signal_generator(ip))
process(ip::ImagineProcedure, inputs...) = analyze_function(ip)(outputs(ip), inputs...)

end # module
