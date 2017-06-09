"""
The macro `@iteratelist` writes a `for` loop over the `list` but avoiding `getfield` calls inside the loop.
The first argument of the macro is the `PairwiseListMatrix` that is going to be iterated and the second is the body of the loop.
In the body `list` will be the list field of the `PairwiseListMatrix` and `k` the index over that list.
Other variables should be interpolated in a quote. You must not modify the value of `k`.

```
julia> PLM = PairwiseListMatrix([1,2,3], false)
3x3 PairwiseListMatrices.PairwiseListMatrix{Int64,false}:
 0  1  2
 1  0  3
 2  3  0

julia> @iteratelist PLM println(list[k])
1
2
3

```
"""
macro iteratelist(plm, exp)
    quote
        list = $(esc(plm)).list
        for k in 1:length(list)
            $exp
        end
    end
end

"""
The macro `@iteratediag` writes a `for` loop over the `diag` field of a `PairwiseListMatrix{T,false}` but avoiding calls to `getfield` inside the loop.
The first argument of the macro is the `PairwiseListMatrix` that is going to be iterated and the second is the body of the loop.
In the body `diag` will be the diag field of the `PairwiseListMatrix` and `k` the index over that vector.
Other variables should be interpolated in a quote. You must not modify the value of `k`.

```
julia> PLM = PairwiseListMatrix([1,2,3], false)
3x3 PairwiseListMatrices.PairwiseListMatrix{Int64,false}:
 0  1  2
 1  0  3
 2  3  0

julia> @iteratediag PLM diag[k] += 10k

julia> PLM
3x3 PairwiseListMatrices.PairwiseListMatrix{Int64,false}:
 10   1   2
  1  20   3
  2   3  30

```
"""
macro iteratediag(plm, exp)
    quote
        if !hasdiagonal($(esc(plm)))
            diag = $(esc(plm)).diag
            for k in 1:length(diag)
                $(exp)
            end
        end
    end
end

"""
The macro `@iterateupper` iterates over the upper triangular part of the `PairwiseListMatrix` that is given as first argument.
The second argument should be `true` if the diagonal need to be included in the iteration or `false` otherwise.
The last argument is the body of the loop, where `list` is the list and diag fields of the `PairwiseListMatrix` and `k` is the index over that `list`.
You can also use the respective `i` and `j` indexes for that position `k` in the upper triangular part of the matrix. Other variables should be interpolated in a quote.
You must not modify the values of `i`, `j` or `k`.

```
julia> PLM = PairwiseListMatrix([1,2,3], true)
2x2 PairwiseListMatrices.PairwiseListMatrix{Int64,true}:
 1  2
 2  3

julia> mat = zeros(Int, 2, 2)
2x2 Array{Int64,2}:
 0  0
 0  0

julia> @iterateupper PLM true :(\$mat)[i,j] = list[k]

julia> mat
2x2 Array{Int64,2}:
 1  2
 0  3

```
"""
macro iterateupper(plm, use_diag, exp)
    quote
        N = $plm.nelements
        if hasdiagonal($plm)
            if $use_diag
                k = 0
                list = $plm.list
                for i in 1:N
                    for j in i:N
                        k += 1
                        $exp
                    end
                end
            else
                k = 0
                list = $plm.list
                for i in 1:N
                    for j in i:N
                        k += 1
                        if i != j
                            $exp
                        end
                    end
                end
            end
        else
            if $use_diag
                k = 0
                diag = $plm.diag
                list = $plm.list
                for i in 1:N
                    for j in i:N
                        if i != j
                            k += 1
                            $exp
                        else
                            let list = diag, k = i
                                $exp
                            end
                        end
                    end
                end
            else
                k = 0
                list = $plm.list
                for i in 1:(N-1)
                    for j in (i+1):N
                        k += 1
                        $exp
                    end
                end
            end
        end
    end |> esc
end
