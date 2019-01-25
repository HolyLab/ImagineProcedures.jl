using ImagineProcedures, ImagineInterface
using Test
    
rt = rigtemplate("ocpi-2")
isigs = rt[1:2]

#returns 2 ImagineSignals
f = x -> isigs
sg = SignalGenerator(f, (0,))

@test isequal(description(sg), "")
@test func(sg) == f
@test func_args(sg) == (0,)
@test call!(sg) == isigs


af = x->x[1]
ip = ImagineProcedure("p", sg, af)
@test isa(repr(ip), AbstractString)
@test isequal(description(ip), "p")
@test ImagineProcedures.signal_generator(ip) == sg
@test ImagineProcedures.analyze_function(ip) == af
@test outputs(ip) == isigs
@test process(ip) == isigs[1]
