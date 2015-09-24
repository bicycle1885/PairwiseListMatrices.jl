module PairwiseListMatrices

  using IndexedArrays

  import Base: size, getindex, setindex!, length, eltype,
  similar, copy, abs, full, zeros, ones, convert,
  transpose, transpose!, ctranspose, ctranspose!, diag, svd,
  -, +, .*, .-, .+, .-, ./, *, /,
  # faster
  mean, sum, varm, var, std, sqrt

  export PairwiseListMatrix,
  labels, labels!, getlabel, setlabel!,
  sum_nodiag, mean_nodiag, zscore!, zscore,
  from_table, to_table


  include("pairwiselistmatrix.jl")

end
