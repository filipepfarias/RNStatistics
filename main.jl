using Pkg
Pkg.activate(".")
using ICRN
using Random, Dates


path = "outputs/"*randstring(5)*"_"*Dates.format(now(),"yyyymmdd")
# path = "outputs/Wow2j_20230210"
mkpath(path)

model_nm = "MichaelisMenten"

sol_CME = CMESolver(path*"/CME", model_nm; saveprob=false, savestats=true)

sol_SSA = SSASolver(path*"/SSA", model_nm; saveprob=false, savestats=true)

# sol_Det = DetSolver(path*"/Det", model_nm; molecules=true)