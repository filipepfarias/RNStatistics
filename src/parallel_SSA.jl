using Distributed
nprocs() != 1 ? rmprocs(nprocs()-1) : nothing
addprocs()

@everywhere begin
    using SharedArrays
    using Random, Distributions
end

@everywhere include("../reactions/MichaelisMenten.jl")

@everywhere function Gillespie(K, 𝛎, Re, S₀, T) # Gillespie
    t = 0.0
    iT = 1;
    Sₜ = Vector{Int64}();
    S = copy(S₀);
    M = size(𝛎,1);
    α(𝓘,Re,m) = binomial.(𝓘,Re[m,:]') .* factorial.(Re[m,:]');

    while t <= T[end]
        if t >= T[iT]
            for s in S
                push!(Sₜ,s)
            end
            iT += 1;
        end

        𝛂 = [K[m] * prod(α(S,Re,m)) for m in 1:M]
        α₀ = sum(𝛂);
        α₀ == 0.0 ? break : nothing

        r = rand(Uniform(),1)
        τ = log(1 / r[1]) / α₀;
        t += τ
        S += 𝛎[rand(Multinomial(1,vec(𝛂/α₀))) .!= 0,:];
    end

    if length(T)-iT > 0
        for s in repeat(vec(S),length(T)-iT+1)
            push!(Sₜ,s)
        end
    end

    Sₜ = reshape(Sₜ,length(S₀),length(T));
    return Sₜ
end

max_sim = 10_000_000;
pS = SharedArray{Int64,3}(length(𝗻ₖ),length(T),max_sim);
@distributed for ip in 1:max_sim
    𝒮 = [rand(ℰ),ℰ𝒜,rand(𝒜),ℬ]' .-1;
    pS[:,:,ip] = Gillespie(K, 𝛎, Re, S₀, T);
end


