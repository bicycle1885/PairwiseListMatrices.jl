module PairwiseListMatrices

  using IndexedArrays

  import Base: size, getindex, setindex!, length, eltype, similar, copy, abs, full,
  transpose, transpose!, ctranspose, ctranspose!, diag, -, +, .*, .-, .+, .-, ./

  export PairwiseListMatrix,
  labels, labels!, getlabel, setlabel!

  include("pairwiselistmatrix.jl")

end