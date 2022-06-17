# Adaptive Resonance Theory (ART)
# DDVFA: Distributed Dual Vigilance Fuzzy ART

using AdaptiveResonance
using DataFrames
using CSV

df = CSV.read("efas.csv",DataFrame,header=0)

features0 = Matrix{Float64}(df)

features = transpose(features0)

art = DDVFA(rho_lb=0.7, rho_ub=0.7)

y_hat_train = train!(art, features)

art.n_categories

CSV.write("DDVFA_out.csv",  Tables.table(y_hat_train), header=false)


