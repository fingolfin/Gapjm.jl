"""
Posets are constructed from one of the two following fields:

  - `incidence`:  a  boolean  matrix  such that `incidence[i,j]==true` iff
    `i<=j` in the poset. This is sometimes called the ζ matrix of `P`.

  - `hasse`:  a list representing  the Hasse diagram  of the poset: the i-th
    entry is the list of indices of elements which are immediate successors
    (covers) of the i-th element, that is the list of j such that `i<j` and
    such that there is no k such that i<k<j.

By  default a `Poset` `P` is a  poset on `1:length(P)` where `length(P)` is
the  cardinality of `P`. To make a  poset with other elements, the elements
should  also be given in the  constructor. There are thus two constructors,
  - `Poset(I::Matrix{Bool}[,elements])` from  the  incidence  matrix  `I`.
    If given one should have `length(elements)==size(I,1)==size(I,2)`.
  - `Poset(H::Vector{<:Vector{<:Integer}}[,elements])` from the Hasse diagram.
    If given one should have `length(elements)==length(H)`.
For convenience there is another constructor
  - `Poset(isless::Function,elements)`;  this  begins  by  constructing  the
    incidence matrix from the `isless` function which may be expensive. For
    isless  one can give  either a function  implementing `<` or a function
    implementing `≤` (it is ored with `=` in any case).


```julia-repl
julia> l=vec(collect(Iterators.product(1:2,1:2)))
4-element Vector{Tuple{Int64, Int64}}:
 (1, 1)
 (2, 1)
 (1, 2)
 (2, 2)

julia> P=Poset((x,y)->all(map(<=,x,y)),l)
1<2,3<4
```
`Poset`s  are printed at  the REPL as  a list of  covering chains. Elements
which  are equivalent  for the  `Poset` are  printed together  separated by
commas.

By default printing shows the index in `1:length(P)` for the elements.
This can be changed by giving the keyword argument `show=:elements`.

```julia-repl
julia> P=Poset((x,y)->all(map(<=,x,y)),l;show=:elements)
(1, 1)<(2, 1),(1, 2)<(2, 2)

julia> length(P) # the number of elements of the `Poset`
4

julia> hasse(P)
4-element Vector{Vector{Int64}}:
 [2, 3]
 [4]
 [4]
 []

julia> incidence(P)
4×4 Matrix{Bool}:
 1  1  1  1
 0  1  0  1
 0  0  1  1
 0  0  0  1
```

More flexibility on printing is obtained by setting a function `show_elements`:
```julia-repl
julia> P.show_element=(io,x,n)->print(io,join(x.elements[n],"."));

julia> P
1.1<2.1,1.2<2.2
```
see the on-line help on `linear_extension, hasse, incidence, partition, 
covering_chains, transitive_closure, is_join_lattice, is_meet_lattice, moebius,
reverse, restricted, minimum, maximum` for more information
"""
module Posets 
# this module has only the 2 dependencies below which could be copied.
using ..Combinat: collectby  # 13 lines
export Poset, linear_extension, hasse, incidence, partition, covering_chains,
transitive_closure, is_join_lattice, is_meet_lattice, moebius
export restricted #needs using_merge to use with Gapjm

struct Poset 
  prop::Dict{Symbol,Any}
end

Base.getproperty(o::Poset,s::Symbol)=hasfield(Poset,s) ? getfield(o,s) : 
         getfield(o,:prop)[s]
Base.setproperty!(o::Poset,s::Symbol,v)=getfield(o,:prop)[s]=v
Base.haskey(o::Poset,s::Symbol)=haskey(getfield(o,:prop),s)
Base.get!(f::Function,o::Poset,s::Symbol)=get!(f,getfield(o,:prop),s)

"""
`transitive_closure(M)`

`M`  should be a  square boolean matrix  representing a relation; returns a
boolean  matrix representing the  transitive closure of  this relation. The
transitive  closure is computed  by the Floyd-Warshall  algorithm, which is
quite fast even for large matrices.

```julia-repl
julia> m=[j-i in [0,1] for i in 1:5, j in 1:5]
5×5 Matrix{Bool}:
 1  1  0  0  0
 0  1  1  0  0
 0  0  1  1  0
 0  0  0  1  1
 0  0  0  0  1

julia>transitive_closure(m)
5×5 Matrix{Bool}:
 1  1  1  1  1
 0  1  1  1  1
 0  0  1  1  1
 0  0  0  1  1
 0  0  0  0  1
```
"""
function transitive_closure(m)
  m=copy(m)
  for k in axes(m,1), i in axes(m,1)
   if m[i,k] m[i,:].|=m[k,:] end
  end
  m
end

"""
`Poset(m::Matrix{Bool})`

Creates a poset from an incidence matrix `m`, that is `m[i,j]==true` if and
only if `i≤j` in the poset,

```julia-repl
julia> Poset(Bool[1 1 1 1 1;0 1 0 1 1;0 0 1 1 1;0 0 0 1 0;0 0 0 0 1])
1<2,3<4,5
```
"""
Poset(m::Matrix{Bool})=Poset(Dict{Symbol,Any}(:incidence=>m))
function Poset(m::Matrix{Bool},e;show=:indices)
  p=Poset(Dict{Symbol,Any}(:incidence=>m,:elements=>e))
  if show==:elements p.show_element=(io,x,n)->print(io,x.elements[n]) end
  p
end

"""
`Poset(h::Vector{<:Vector{<:Integer}})`

Creates a poset from a Hasse diagram given as a `Vector` whose `i`-th entry
is  the list of indices of elements which are immediate successors (covers)
of the `i`-th element, that is `h[i]` is the list of `j` such that `i<j` in
the poset and such that there is no `k` such that `i<k<j`.

```julia-repl
julia> Poset([[2,3],[4,5],[4,5],Int[],Int[]])
1<2,3<4,5
```
"""
Poset(m::Vector{<:Vector{<:Integer}})=Poset(Dict{Symbol,Any}(:hasse=>m))
function Poset(m::Vector{<:Vector{<:Integer}},e;show=:indices)
  p=Poset(Dict{Symbol,Any}(:hasse=>m,:elements=>e))
  if show==:elements p.show_element=(io,x,n)->print(io,x.elements[n]) end
  p
end

Poset(f::Function,e;show=:indices)=
  Poset([(f(x,y)|| x==y) for x in e, y in e],e;show)

Base.length(p::Poset)=haskey(p,:hasse) ? length(hasse(p)) : size(incidence(p),1)

elements(p::Poset)=haskey(p,:elements) ? p.elements : 1:length(p)

function Base.show(io::IO,x::Poset)
  s=hasse(x)
  if !(get(io,:TeX,false) || get(io,:limit,false))
    print(io,"Poset(",s)
    if x.elements!=1:length(x) print(io,",",x.elements) end
    print(io,")")
    return 
  end
  pp=partition(x)
  sh=haskey(x,:show_element) ? x.show_element : (io,x,n)->print(io,n)
  e=elements(x)
  labels=map(y->join(map(n->sprint(sh,x,n;context=io),y),","),pp)
  p=Poset(map(x->unique!(sort(map(y->Int(findfirst(z->y in z,pp)),s[x[1]]))),pp))
  sep=get(io,:Symbol,false)
  TeX=get(io,:TeX,false)
  if sep==false sep=TeX ? "{<}" : "<" end
  ch=map(x->join(labels[x],sep), covering_chains(p)) 
  if TeX print(io,join(map(x->"\$\$$x\$\$\n",ch)))
  else join(io,ch,"\n")
  end
end

"""
`linear_extension(P)`

returns  a  linear  extension  of  the  poset  `P`,  that  is  a vector `l`
containing  a permutation of the integers  `1:length(P)` such that if `i<j`
in `P`, then `findfirst(==(i),l)<findfirst(==(j),l)`. This is also called a
topological sort of `P`.

```julia-repl
julia> p=Poset((i,j)->j%i==0,1:6)
1<5
1<2<4
1<3<6
2<6

julia> linear_extension(p)
6-element Vector{Int64}:
 1
 2
 3
 5
 4
 6
```
"""
function linear_extension(P::Poset)
  ord=hasse(P)
  n=zeros(length(ord))
  for v in ord for x in v n[x] += 1 end end
  Q=filter(x->iszero(n[x]),1:length(n))
  res=Int[]
  while length(Q) > 0
    push!(res, Q[1])
    for x in ord[Q[1]]
      n[x]-=1
      if iszero(n[x]) push!(Q, x) end
    end
    popfirst!(Q)
  end
  if sum(n)>0 error("cycle") end
  res
end

hasse(m::Matrix{Bool})=map(x->filter(y->x[y]==2,1:length(x)),eachrow(m*m))

"""
`hasse(P::Poset)`

the Hasse diagram of `P`.

```julia-repl
julia> p=Poset((i,j)->j%i==0,1:5)
1<3,5
1<2<4

julia> hasse(p)
5-element Vector{Vector{Int64}}:
 [2, 3, 5]
 [4]      
 []       
 []       
 []       
```
"""
hasse(p::Poset)=get!(()->hasse(incidence(p)),p,:hasse)

"""
`incidence(P::Poset)`

returns the incidence matrix (also called the ζ matrix) of `P`.

```julia-repl
julia> p=Poset([i==6 ? Int[] : [i+1] for i in 1:6])
1<2<3<4<5<6

julia> incidence(p)
6×6 Matrix{Bool}:
 1  1  1  1  1  1
 0  1  1  1  1  1
 0  0  1  1  1  1
 0  0  0  1  1  1
 0  0  0  0  1  1
 0  0  0  0  0  1
```
"""
function incidence(p::Poset)::Matrix{Bool}
  get!(p,:incidence)do
    n=linear_extension(p)
    incidence=one(Matrix{Bool}(undef,length(n),length(n)))
    for i in length(n)-1:-1:1
      for x in hasse(p)[n[i]] incidence[n[i],:].|= incidence[x,:] end
    end
    incidence
  end
end

"""
`covering_chains(P::Poset)`

A (greedy: the first is longest possible) list of covering chains for P.
"""
function covering_chains(P::Poset)
  ch=Vector{Int}[]
  h=hasse(P)
  for i in linear_extension(P), j in h[i]
    p=findfirst(c->i==c[end],ch)
    if p===nothing push!(ch,[i,j])
    else push!(ch[p],j)
    end
  end
  ch
end

"""
`reverse(P::Poset)`

the opposed poset to `P`.

```julia-repl
julia> p=Poset((i,j)->i%4<j%4,1:8)
4,8<1,5<2,6<3,7

julia> reverse(p)
3,7<2,6<1,5<4,8
```
"""
function Base.reverse(p::Poset)
  res=deepcopy(p)
  if haskey(p,:incidence) res.incidence=transpose(incidence(p)) end
  if haskey(p,:hasse)
    res.hasse=map(empty,hasse(p))
    for i in 1:length(p), j in hasse(p)[i] push!(hasse(res)[j], i) end
  end
  return res
end

"""
`partition(P::Poset)`

returns  the  partition  of  `1:length(P)`  determined  by  the equivalence
relation  associated to `P`; that  is, `i` and `j`  are in the same part of
the  partition if the `k` such that `i<k` and `j<k` are the same as well as
the `k` such that `k<i` and `k<j`.

```julia-repl
julia> p=Poset([i==j || i%4<j%4 for i in 1:8, j in 1:8])
4,8<1,5<2,6<3,7

julia> partition(p)
4-element Vector{Vector{Int64}}:
 [4, 8]
 [2, 6]
 [3, 7]
 [1, 5]
```
"""
function partition(p::Poset)
  if haskey(p,:hasse)
    l=reverse(p)
    collectby(i->(hasse(l)[i], hasse(p)[i]),1:length(p))
  else
    I=incidence(p)
    ind=1:length(p)
    l=map(i->[map(j->j!=i && I[i,j], ind), map(j->j!=i && I[j,i], ind)], ind)
    map(x->filter(i->l[i] == x,ind), unique!(sort(l)))
  end
end

"""
`restricted(P::Poset,inds::AbstractVector{<:Integer};show=:indices)`

returns  the sub-poset of `P` determined by `inds`, which must be a sublist
of `1:length(P)`. The indices in this sub-poset will be renumbered to their
position in `inds`, but the elements set to `P.elements[inds]`. The keyword
show is transmitted to the constructed poset.

```julia-repl
julia> p=Poset((i,j)->i%4<j%4,1:8)
4,8<1,5<2,6<3,7

julia> restricted(p,2:6)
3<4<1,5<2

julia> restricted(p,2:6;show=:elements)
4<5<2,6<3
```
"""
function restricted(p::Poset,ind::AbstractVector{<:Integer};show=:indices)
  res=Poset(copy(p.prop))
  if length(ind) == length(p) && sort(ind) == 1:length(p)
    if haskey(res,:hasse)
      res.hasse=Vector{Int}.(map(x->map(y->findfirst(==(y),ind),x),res.hasse[ind]))
    end
    if haskey(res, :incidence) res.incidence=incidence(res)[ind,ind] end
  else
    inc=incidence(p)
    res.incidence=[i!=j && ind[i]==ind[j] ? false : inc[ind[i],ind[j]]
                            for i in eachindex(ind), j in eachindex(ind)]
    delete!(res.prop, :hasse)
  end
  res.elements=haskey(p,:elements) ? p.elements[ind] : ind
  if show==:elements res.show_element=(io,x,n)->print(io,x.elements[n]) end
  res
end

function checkl(ord::AbstractMatrix{Bool})
  subl=Set(Vector{Bool}[])
  n=size(ord,1)
  for i in 1:n, j in 1:i-1
    if !ord[j,i] || ord[i,j]
      l=ord[i,:].&ord[j,:]
      if !(l in subl)
        if !any(y->l==l.&y,eachrow(ord[l,:]))
          for k in (1:n)[l]
            ll=copy(ord[k,:])
            ll[k]=false
            l.&=.!ll
          end
          println("# $i  &&  $j have bounds ", (1:n)[l])
          return false
        end
        push!(subl, l)
      end
    end
  end
  true
end

"""
`is_join_lattice(P::Poset)`

returns  `true` if `P` is  a join semilattice, that  is any two elements of
`P` have a unique smallest upper bound; returns `false` otherwise.

```julia-repl
julia> p=Poset((i,j)->j%i==0,1:8)
1<5,7
1<2<4<8
1<3<6
2<6

julia> is_join_lattice(p)
false
```
"""
is_join_lattice(P::Poset)=checkl(incidence(P))

"""
`is_meet_lattice(P)`

returns  `true` if `P` is  a meet semilattice, that  is any two elements of
`P` have a unique highest lower bound; returns `false` otherwise.

```julia-repl
julia> p=Poset((i,j)->j%i==0,1:8)
1<5,7
1<2<4<8
1<3<6
2<6

julia> is_meet_lattice(p)
true
```
"""
is_meet_lattice(P::Poset)=checkl(transpose(incidence(P)))

"""
`moebius(P,y=maximum(P))`

the vector of value `μ(x,y)` of the Moebius function of `P` for `x` varying.
Here is an example giving the ususal Moebius function on integers.
```julia_repl
julia> p=Poset((i,j)->i%j==0,1:8)
5,7<1
6<2<1
6<3<1
8<4<2

julia> moebius(p)
8-element Vector{Int64}:
  1
 -1
 -1
  0
 -1
  1
 -1
  0
```
"""
function moebius(P::Poset,y=0)
  o=linear_extension(P)
  if y==0 y=o[end] end
  mu=zeros(Int,length(P))
  mu[y]=1
  gt(i)=filter(j->j!=i && incidence(P)[i,j], 1:length(P))
  for i in o[findfirst(==(y),o)-1:-1:1] mu[i]=-sum(mu[gt(i)]) end
  mu
end

"`maximum(p::Poset)` the maximum element of `P` if there is one."
function Base.maximum(p::Poset)
  m=incidence(p)
  maxs=findall(i->all(m[:,i]),axes(m,2))
  only(maxs)
end

"`minimum(p::Poset)` the minimum element of `P` if there is one."
function Base.minimum(p::Poset)
  m=incidence(p)
  maxs=findall(i->all(m[i,:]),axes(m,1))
  only(maxs)
end

end
