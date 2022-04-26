"""
This self-contained module (it has no dependencies) is a Julia port of some
GAP combinatorics. The list of functions it exports are:

Classical enumerations:

`combinations, arrangements, partitions, partition_tuples,
 restrictedpartitions,  compositions, submultisets`

functions to count them without computing them:

`ncombinations, narrangements, npartitions, npartition_tuples,
 nrestrictedpartitions`

some functions on partitions and permutations:

`lcm_partitions, gcd_partitions, conjugate_partition, dominates, tableaux,
 robinson_schensted`

counting functions:

`bell, stirling2, catalan, bernoulli`

some structural manipulations not yet in Julia:

`groupby, tally, collectby, unique_sorted!`

matrix blocks:

`blocks, diagblocks`

Have  a  look  at  the  individual  docstrings  and  enjoy (any feedback is
welcome).
"""
module Combinat
export combinations, ncombinations, arrangements, narrangements,
  partitions, npartitions, partition_tuples, npartition_tuples,
   restrictedpartitions, nrestrictedpartitions, compositions, 
   submultisets, nsubmultisets, 
  lcm_partitions, gcd_partitions, conjugate_partition, dominates, tableaux,
    robinson_schensted,
  bell, stirling2, catalan, bernoulli,
  groupby, tally, collectby, unique_sorted!,
  blocks, diagblocks

#--------------------- Structural manipulations -------------------
"""
`groupby(v,l)`

group  elements of collection `l` according  to the corresponding values in
the collection `v` (which should have same length as `l`).

```julia-rep1
julia> groupby([31,28,31,30,31,30,31,31,30,31,30,31],
  [:Jan,:Feb,:Mar,:Apr,:May,:Jun,:Jul,:Aug,:Sep,:Oct,:Nov,:Dec])
Dict{Int64,Vector{Symbol}} with 3 entries:
  31 => Symbol[:Jan, :Mar, :May, :Jul, :Aug, :Oct, :Dec]
  28 => Symbol[:Feb]
  30 => Symbol[:Apr, :Jun, :Sep, :Nov]
```
"""
function groupby(v,l)
  res=Dict{eltype(v),Vector{eltype(l)}}()
  for (k,val) in zip(v,l) push!(get!(res,k,empty(l)),val) end
  res
end

"""
`groupby(f::Function,l)`

group  elements of collection `l` according to the values taken by function
`f` on them. The values of `f` must be hashable.

```julia-repl
julia> groupby(iseven,1:10)
Dict{Bool, Vector{Int64}} with 2 entries:
  0 => [1, 3, 5, 7, 9]
  1 => [2, 4, 6, 8, 10]
```
Note:  keys of the result will  have type `Any` if `l`  is empty since I do
not know how to access the return type of a function
"""
function groupby(f::Function,l)
  if isempty(l) return Dict{Any,eltype(l)}() end
  res=Dict(f(l[1])=>[l[1]])
  for val in l[2:end]
    push!(get!(res,f(val),empty(l)),val)
  end
  res
end

function tally_sorted(v)
  res=Pair{eltype(v),Int}[]
  if isempty(v) return res end
  c=1
@inbounds  for j in 2:length(v)
    if v[j]==v[j-1] c+=1
    else push!(res,v[j-1]=>c)
      c=1
    end
  end
  push!(res,v[end]=>c)
end

"""
`tally(v)`

count  how many times  each element of  collection `v` occurs  and return a
sorted  `Vector` of  `elt=>count` (a  variation on  StatsBase.countmap; the
elements of `v` must be sortable).

```julia-repl
julia> tally("a tally test")
7-element Vector{Pair{Char, Int64}}:
 ' ' => 2
 'a' => 2
 'e' => 1
 'l' => 2
 's' => 1
 't' => 3
 'y' => 1
```
"""
tally(v::AbstractArray)=tally_sorted(issorted(v) ? v : sort(v))

tally(v)=tally(collect(v)) # for iterables

"""
`collectby(f,v)`

group  the elements of `v` in packets  (`Vector`s) where `f` takes the same
value.  The resulting `Vector{Vector}` is sorted  by the values of `f` (the
values  of  `f`  must  be  sortable;  otherwise  you  can  use  the  slower
`values(groupby(f,v))`).  Here `f` can  be a function  of one variable or a
collection of same length as `v`.

```julia-repl
julia> l=[:Jan,:Feb,:Mar,:Apr,:May,:Jun,:Jul,:Aug,:Sep,:Oct,:Nov,:Dec];

julia> collectby(x->first(string(x)),l)
8-element Vector{Vector{Symbol}}:
 [:Apr, :Aug]
 [:Dec]
 [:Feb]
 [:Jan, :Jun, :Jul]
 [:Mar, :May]
 [:Nov]
 [:Oct]
 [:Sep]

julia> collectby("JFMAMJJASOND",l)
8-element Vector{Vector{Symbol}}:
 [:Apr, :Aug]
 [:Dec]
 [:Feb]
 [:Jan, :Jun, :Jul]
 [:Mar, :May]
 [:Nov]
 [:Oct]
 [:Sep]
```julia-repl

"""
function collectby(f,v)
  res=Vector{eltype(v)}[]
  if isempty(v) return res end
  l=f isa Function ? [(f(x),x) for x in v] : collect(zip(f,v))
  sort!(l,by=first)
  push!(res,[last(first(l))])
  for i in 2:length(l)
    if first(l[i])==first(l[i-1]) push!(res[end],last(l[i]))
    else push!(res,[last(l[i])])
    end
  end
  res
end

if VERSION<=v"1.7.5"
export allequal

" `allequal(a)` whether all elements in iterable `a` are equal"
function allequal(a) # written so that a can be an iterator
  if isempty(a) return true end
  o=first(a)
  all(==(o),a)
end
end

" faster than unique! for sorted vectors"
function unique_sorted!(v::Vector)
  i=1
@inbounds  for j in 2:length(v)
    if v[j]<v[i] error("not sorted:",v)
    elseif v[j]==v[i]
    else i+=1; v[i]=v[j]
    end
  end
  resize!(v,i)
end

#--------------------- Classical enumerations -------------------

"""
`Combinat.Combinations(s[,k])`   is  an   iterator  which   enumerates  the
combinations  of  the  multiset  `s`  (with  `k`  elements  if `k`given) in
lexicographic order.
```julia-repl
julia> a=Combinat.Combinations(1:4);

julia> collect(a)
16-element Vector{Vector{Int64}}:
 []
 [1]
 [2]
 [3]
 [4]
 [1, 2]
 [1, 3]
 [1, 4]
 [2, 3]
 [2, 4]
 [3, 4]
 [1, 2, 3]
 [1, 2, 4]
 [1, 3, 4]
 [2, 3, 4]
 [1, 2, 3, 4]

julia> a=Combinat.Combinations([1,2,2,3,4,4],3)
Combinations([1, 2, 2, 3, 4, 4],3)

julia> collect(a)
10-element Vector{Vector{Int64}}:
 [1, 2, 2]
 [1, 2, 3]
 [1, 2, 4]
 [1, 3, 4]
 [1, 4, 4]
 [2, 2, 3]
 [2, 2, 4]
 [2, 3, 4]
 [2, 4, 4]
 [3, 4, 4]
```
"""
struct Combinations{T}
  t::Vector{Int}
  k::Int
  s::Vector{T}
end

function Base.iterate(S::Combinations)
  t=S.t
  k=S.k
  n=sum(t)
  if k>n return nothing end
  v=fill(0,k)
  u=1
  j=0
  for l in 1:k
    if j<t[u] j+=1 
    else u+=1;j=1
    end
    v[l]=u
  end
  S.s[v], v
end

Base.eltype(x::Combinations)=Vector{Int}
Base.IteratorSize(::Type{Combinations{T}}) where T=Base.SizeUnknown()
Base.show(io::IO,x::Combinations)=print(io,"Combinations(",vcat(fill.(x.s,x.t)...),",",x.k,")")

function Base.iterate(S::Combinations,v)
  i=length(v)
  t=S.t
  k=S.k
  while i>0
    if (i==k && v[i]<length(t)) || (i<k && v[i]<v[i+1])
      u=v[i]+1
      j=0
      for l in i+1:k if v[l]==u j+=1 else break end end
      if j>=t[u] i-=1;continue end
      j=0
      for l in i:k
        if j<t[u] j+=1 
        else u+=1;j=1
        end
        v[l]=u
      end
      return S.s[v],v
      i=k;continue
    else i-=1;continue 
    end
  end
end

function Combinations(mset,k)
  t=tally(mset)
  Combinations(last.(t),k,first.(t))
end

function Combinations(mset)
  tly=tally(mset)
  s=first.(tly)
  t=last.(tly)
  Iterators.flatten(Combinations(t,k,s) for k in 0:length(s))
end


"""
`combinations(mset[,k])`

`ncombinations(mset[,k])`

`combinations`  returns  all  combinations  of  the  multiset `mset` (a not
necessarily  sorted  collection  with  possible  repetitions).  If a second
argument  `k`  is  given,  it  returns  the combinations with `k` elements.
`ncombinations` returns the number of combinations.

A  *combination* is an unordered subsequence and is represented by a sorted
`Vector`  (the  elements  of  `mset`  must  be  sortable). If `mset` has no
repetitions, the list of all combinations is just the *powerset* of `mset`.

```julia-repl
julia> ncombinations([1,2,2,3])
12

julia> combinations([1,2,2,3])
12-element Vector{Vector{Int64}}:
 []
 [1]
 [2]
 [3]
 [1, 2]
 [1, 3]
 [2, 2]
 [2, 3]
 [1, 2, 2]
 [1, 2, 3]
 [2, 2, 3]
 [1, 2, 2, 3]
```
The  combinations  are  implemented  by an iterator `Combinat.Combinations`
which can be used to enumerate the partitions of a large number.
"""
combinations(mset)=collect(Combinations(mset))
combinations(mset,k)=collect(Combinations(mset,k))

@doc (@doc combinations) ncombinations
ncombinations(mset)=prod(1 .+last.(tally(mset)))

ncombinations(mset,k)=ncombinations(sort(last.(tally(mset)),rev=true),1,k)

function ncombinations(mul,m,k)
  if k==0 return 1 end
  if m>length(mul) return 0 end
  if mul[1]==1 return binomial(length(mul),k) end
  sum(i->ncombinations(mul,m+1,k-i),0:min(mul[m],k))
end

"""
`arrangements(mset[,k])`

`narrangements(mset[,k])`

`arrangements`  returns  the  arrangements  of  the  multiset `mset` (a not
necessarily  sorted  collection  with  possible  repetitions).  If a second
argument   `k`  is  given,  it  returns  arrangements  with  `k`  elements.
`narrangements` returns the number of arrangements.

An  *arrangement*  of  `mset`  is  a  subsequence taken in arbitrary order,
representated as a `Vector`.

As  an example of arrangements  of a multiset, think  of the game Scrabble.
Suppose  you have the six  characters of the word  'settle' and you have to
make a four letter word. Then the possibilities are given by

```julia-repl
julia> narrangements(collect("settle"),4)
102
```
while all possible words (including the empty one) are:

```julia-repl
julia> narrangements(collect("settle"))
523
```
The  result returned  by 'arrangements'  is sorted  (the elements of `mset`
must  be sortable), which means in  this example that the possibilities are
listed  in the same  order as they  appear in the  dictionary. Here are the
two-letter words:

```julia-repl
julia> String.(arrangements(collect("settle"),2))
14-element Vector{String}:
 "ee"
 "el"
 "es"
 "et"
 "le"
 "ls"
 "lt"
 "se"
 "sl"
 "st"
 "te"
 "tl"
 "ts"
 "tt"
```
"""
function arrangements(mset,k)
  blist=trues(length(mset))
  function arr(mset,k)
    if iszero(k) return [empty(mset)] end
    combs=Vector{eltype(mset)}[]
    for i in eachindex(blist)
      if blist[i] && (i==length(blist) || mset[i+1]!=mset[i] || !blist[i+1])
        blist[i]=false
        append!(combs,pushfirst!.(arr(mset,k-1)::Vector{Vector{eltype(mset)}},
                                   Ref(mset[i])))
        blist[i]=true
      end
    end
    combs
  end
  arr(sort(mset),k)
end

arrangements(mset)=vcat(arrangements.(Ref(mset),0:length(mset))...)

function NrArrangementsA( mset, m, n, i )
  if i==n+1 return 1 end
  combs=1
  for l in 1:n
    if m[l] && (l==1 || m[l-1]==false || mset[l]!=mset[l-1])
      m[l]=false
      combs+=NrArrangementsA(mset,m,n,i+1)
      m[l]=true
    end
  end
  combs
end

function NrArrangementsK( mset, m, n, k )
  if k==0 return 1 end
  combs=0
  for l in 1:n
    if m[l] && (l==1 || m[l-1]==false || mset[l]!=mset[l-1])
      m[l]=false
      combs+=NrArrangementsK(mset,m,n,k-1)
      m[l]=true
    end
  end
  combs
end 

@doc (@doc arrangements) narrangements
function narrangements(mset)
  mset=copy(mset)
  sort!(mset)
  if allunique(mset)
    nr=0
    for i in 0:length(mset)
      nr+=prod(length(mset):-1:length(mset)-i+1)
    end
  else
    m=trues(length(mset))
    nr=NrArrangementsA(mset,m,length(mset),1)
  end
end

function narrangements(mset,k)
  mset=copy(mset)
  sort!(mset)
  if allunique(mset)
    if k <= length(mset)
      nr=prod(length(mset):-1:length(mset)-k+1)
    else
      nr=0
    end
  else
    m=trues(length(mset))
    nr=NrArrangementsK(mset,m,length(mset),k)
  end
  nr
end

"""
`Combinat.Partitions(n[,k])` is an iterator which enumerates the partitions
of `n` (with `k`part if `k`given) in lexicographic order.
```julia-repl
julia> a=Combinat.Partitions(5)
Partitions(5)

julia> collect(a)
7-element Vector{Vector{Int64}}:
 [1, 1, 1, 1, 1]
 [2, 1, 1, 1]
 [2, 2, 1]
 [3, 1, 1]
 [3, 2]
 [4, 1]
 [5]

julia> a=Combinat.Partitions(10,3)
Partitions(10,3)

julia> collect(a)
8-element Vector{Vector{Int64}}:
 [4, 3, 3]
 [4, 4, 2]
 [5, 3, 2]
 [5, 4, 1]
 [6, 2, 2]
 [6, 3, 1]
 [7, 2, 1]
 [8, 1, 1]
```
"""
struct Partitions
  n::Int
end

Partitions(n::Integer)=Partitions(n)

Base.eltype(x::Partitions)=Vector{Int}
Base.IteratorSize(::Type{Partitions})=Base.SizeUnknown()
Base.show(io::IO,x::Partitions)=print(io,"Partitions(",x.n,")")

function Base.iterate(s::Partitions)
  v=fill(1,s.n)
  copy(v),v
end

function Base.iterate(s::Partitions,v)
  ss=0
  for i in length(v):-1:1
    if ss>0 && (i==1 || v[i]<v[i-1])
       v[i]+=1
       for j in i+1:i+ss-1 v[j]=1 end
       for j in i+ss:length(v) v[j]=0 end
       return v[1:i+ss-1],v
    else ss+=v[i]
    end
  end
end

struct PartitionsK
  n::Int
  k::Int
end

Partitions(n,k)=PartitionsK(n,k)
Base.eltype(x::PartitionsK)=Vector{Int}
Base.IteratorSize(::Type{PartitionsK})=Base.SizeUnknown()
Base.show(io::IO,x::PartitionsK)=print(io,"Partitions(",x.n,",",x.k,")")

function Base.iterate(s::PartitionsK)
  if s.k>s.n || s.k<=0 return nothing end
  q,r=divrem(s.n,s.k)
  v=fill(q,s.k)
  for i in 1:r v[i]=q+1 end
  copy(v),v
end

function Base.iterate(s::PartitionsK,v)
  ss=0
  for i in s.k:-1:1
    if ss>s.k-i && (i==1 || v[i]<v[i-1])
       v[i]+=1
       q,r=divrem(ss-1,s.k-i)
       for j in i+1:i+r v[j]=q+1 end
       for j in i+r+1:s.k v[j]=q end
       return copy(v),v
    else ss+=v[i]
    end
  end
end
"""
`partitions(n::Integer[,k])`

`npartitions(n::Integer[,k])`

`partitions`  returns in lexicographic  order the set  of all partitions of
the  positive integer `n` (the partitions with  `k` parts if `k` is given).
`npartitions` returns (faster) the number of partitions.

There are approximately `exp(π√(2n/3))/(4√3 n)` partitions of `n`.

A  *partition*  is  a  decomposition  `n=p₁+p₂+…+pₖ`  in integers such that
`p₁≥p₂≥…≥pₖ>0`, and is represented by the vector `p=[p₁,p₂,…,pₖ]`. We write
`p⊢n`.

```julia-repl
julia> npartitions(7)
15

julia> partitions(7)
15-element Vector{Vector{Int64}}:
 [1, 1, 1, 1, 1, 1, 1]
 [2, 1, 1, 1, 1, 1]
 [2, 2, 1, 1, 1]
 [2, 2, 2, 1]
 [3, 1, 1, 1, 1]
 [3, 2, 1, 1]
 [3, 2, 2]
 [3, 3, 1]
 [4, 1, 1, 1]
 [4, 2, 1]
 [4, 3]
 [5, 1, 1]
 [5, 2]
 [6, 1]
 [7]

julia> npartitions(7,3)
4

julia> partitions(7,3)
4-element Vector{Vector{Int64}}:
 [3, 2, 2]
 [3, 3, 1]
 [4, 2, 1]
 [5, 1, 1]
```

The partitions are implemented by an iterator `Combinat.Partitions` which
can be used to enumerate the partitions of a large number.
"""
partitions(n::Integer)=collect(Partitions(n))
partitions(n::Integer,k::Integer)=collect(Partitions(n,k))

@doc (@doc partitions) npartitions
function npartitions(n)
  s=one(n)
  p=fill(s,n+1)
  for m in 1:n
    s=zero(n)
    k=1
    l=1
    while 0<=m-(l+k)
      s-=(-1)^k*(p[m-l+1]+p[m-(l+k)+1])
      k+=1
      l+=3*k-2
    end
    if l<=m s-=(-1)^k*p[m-l+1] end
    p[m+1]=s
  end
  s
end

function npartitions(n,k)
  if n==k return 1
  elseif n<k || k==0 return 0
  end
  p=fill(1,n)
  for l  in 2:k
    for m  in l+1:n-l+1 p[m]+=p[m-l] end
  end
  p[n-k+1]
end

"""
`restrictedpartitions(n,set[,k])`   
    
`restrictedpartitions`  returns the list of partitions of `n` restricted to
have  parts  in  `set`  (the  partitions  with  `k` parts if `k` is given).
`nrestrictedpartitions`  with the same arguments  gives (faster) the number
of restricted partitions.

The next example shows how many ways there are to pay 17 cents using coins
of 2,5 and 10 cents.
```julia-repl
julia> nrestrictedpartitions(17,[10,5,2])
3

julia> restrictedpartitions(17,[10,5,2])
3-element Vector{Vector{Int64}}:
 [5, 2, 2, 2, 2, 2, 2]
 [5, 5, 5, 2]
 [10, 5, 2]

julia> restrictedpartitions(17,[10,5,2],3)
1-element Vector{Vector{Int64}}:
 [10, 5, 2]

julia> nrestrictedpartitions(17,[10,5,2],3)
1
```
"""
restrictedpartitions(n,set)=restrictedpartitions(n,sort(set),length(set),Int[],1)

function restrictedpartitions(n,set,m,part,i)
  if n==0 return [part] end
  if mod(n,set[1])==0 parts=[part]
  else parts=Vector{Int}[]
  end
  for l in 2:m
    if set[l]<=n
      if length(part)<i push!(part,set[l]) else part[i]=set[l] end
      append!(parts,restrictedpartitions(n-set[l],set,l,copy(part),i+1))
    end
  end
  if mod(n,set[1])==0
    for l in i:length(part) part[l]=set[1] end
    append!(part,fill(set[1],i+div(n,set[1])-length(part)-1))
  end
  parts
end

function restrictedpartitions(n,set,k)
  if n==0
    k==0 ? [Int[]] : Vector{Int}[]
  else
    if k==0 Vector{Int}[]
    else restrictedpartitions(n,sort(set),length(set),k,Int[],1)
    end
  end
end

#  'restrictedpartitions(n,set,m,k,part,i)'   returns   the   set   of  all
#  partitions  of 'n+sum(part[1:i-1])' that contain only elements of `set`,
#  that have length 'k+i-1', and that begin with 'part[1:i-1]'. To do so it
#  finds  all elements of `set`  that can go at  'part[i]' and calls itself
#  recursively  for each candidate.  `m` is the  position of `part[i-1]` in
#  `set`,  so the candidates  for `part[i]` are  the elements of `set[1:m]`
#  that   are  less  than  `n`,  since   we  require  that  partitions  are
#  nonincreasing.
function restrictedpartitions(n,set,m,k,part,i)
  if k==1
    if n in set part=copy(part)
      if length(part)<i push!(part,n) else part[i]=n end
      parts=[part]
    else parts=Vector{Int}[]
    end
  else
    part=copy(part)
    parts=Vector{Int}[]
    for l in 1:m
      if set[l]+(k-1)*set[1]<= n && n<=k*set[l]
        if length(part)<i push!(part,set[l]) else part[i]=set[l] end
        part[i]=set[l]
        append!(parts,restrictedpartitions(n-set[l],set,l,k-1,part,i+1))
      end
    end
  end
  parts
end

@doc (@doc restrictedpartitions) nrestrictedpartitions
function nrestrictedpartitions(n,set)
  p=map(m->Int(iszero(mod(m-1,set[1]))),1:n+1)
  for l in set[2:end], m in l+1:n+1 p[m]+=p[m-l] end
  p[n+1]
end

function nrestrictedpartitions(n,set,k)
  if n==0 && k==0  1
  elseif n<k || k==0 0
  else nrestrictedpartitions(n,sort(set),length(set),k,fill(0,n),1)
  end
end

function nrestrictedpartitions(n,set,m,k,part,i)
  if k==1 return n in set end
  parts=0
  for l in 1:m
    if set[l]+(k-1)*set[1]<=n && n<=k*set[l]
      part[i]=set[l]
      parts+=nrestrictedpartitions(n-set[l],set,l,k-1,copy(part),i+1)
    end
  end
  parts
end

# add to list partitions_tuples(n,r) using l[i] list of partitions of i
function partition_tuples(list,n,r,l)
  k=length(list[end])
  start=true
  for i in (r==1 ? n : 0):n, p in l[i+1]
    if !start push!(list,list[end][1:k]) end
    start=false
    push!(list[end],p)
    if r>1 partition_tuples(list,n-i,r-1,l) end
  end
end

# decent implementation
function partition_tuples2(n,r)
  if r==1 return map(x->[x],partitions(n)) end
  list=[Vector{Int}[]]
  if iszero(r) return  n>0 ? empty(list) : list end
  partition_tuples(list,n,r,partitions.(0:n))
  list
end

# bad implementation but which is ordered as GAP3; needed for
# compatibility with Chevie data library (specially type B2)
"""
`partition_tuples(n,r)`

`npartition_tuples(n,r)`

the `r`-tuples of partitions that together partition `n`.
`npartition_tuples` is the number of partition tuples.

```julia-repl
julia> npartition_tuples(3,2)
10

julia> partition_tuples(3,2)
10-element Vector{Vector{Vector{Int64}}}:
 [[1, 1, 1], []]
 [[1, 1], [1]]
 [[1], [1, 1]]
 [[], [1, 1, 1]]
 [[2, 1], []]
 [[1], [2]]
 [[2], [1]]
 [[], [2, 1]]
 [[3], []]
 [[], [3]]
```
"""
function partition_tuples(n, r)
   if n==0 return [fill(Int[],r)] end
   empty=(tup=[Int[] for i in 1:r], pos=fill(1,n-1))
   pm=[typeof(empty)[] for i in 1:n-1]
   for m in 1:div(n,2)
      for i in 1:r # the m-cycle in all possible places.
        t=map(copy,empty)
        t.tup[i]=[m]
        t.pos[m]=i
        push!(pm[m],t)
      end
       # add the m-cycle to everything you know.
      for k in m+1:n-m, t in pm[k-m], i in t.pos[m]:r
        t1=map(copy,t)
        t1.tup[i]=copy(t1.tup[i])
        pushfirst!(t1.tup[i],m)
        t1.pos[m]=i
        push!(pm[k], t1)
      end
   end
   res= Vector{Vector{Int}}[]
   for k in 1:n-1, t in pm[n-k], i in t.pos[k]:r # collect
     s=copy(t.tup)
     s[i]=copy(s[i])
     pushfirst!(s[i],k)
     push!(res,s)
   end
   for i in 1:r
     s=copy(empty.tup)
     s[i]=[n]
     push!(res,s)
   end
   res
end

@doc (@doc partition_tuples) npartition_tuples
function npartition_tuples(n,k)
  res=0
  for l in 1:min(n,k)
    r=binomial(k,l)
    res+=r*sum(a->narrangements(a,l)*prod(npartitions.(a)),partitions(n,l))
  end
  res
end

"""
`compositions(n[,k];min=1)`

This  function returns the compositions of  `n` (the compositions of length
`k`  if a second argument `k` is given), where a composition of the integer
`n` is a decomposition `n=p₁+…+pₖ` in integers `≥min`, represented as the
vector  `[p₁,…,pₖ]`. Unless `k`  is given, `min`  must be `>0`. There are
``2^{n-1}``  compositions of `n` in  integers `≥1`, and `binomial(n-1,k-1)`
compositions  of `n` in  `k` parts `≥1`.  Compositions are sometimes called
ordered partitions.

```julia-repl
julia> compositions(4)
8-element Vector{Vector{Int64}}:
 [1, 1, 1, 1]
 [2, 1, 1]
 [1, 2, 1]
 [3, 1]
 [1, 1, 2]
 [2, 2]
 [1, 3]
 [4]

julia> compositions(4,2)
3-element Vector{Vector{Int64}}:
 [3, 1]
 [2, 2]
 [1, 3]

julia> compositions(4,2;min=0)
5-element Vector{Vector{Int64}}:
 [4, 0]
 [3, 1]
 [2, 2]
 [1, 3]
 [0, 4]
```
"""
function compositions(n;min=1)
  if iszero(n) return [Int[]] end
  if min<=0 error("min must be ≥1") end
  vcat(map(i->map(c->push!(c,i),compositions(n-i;min)),min:n)...)
end

function compositions(n,k;min=1)
  if isone(k) return [[n]] end
  vcat(map(i->map(c->push!(c,i),compositions(n-i,k-1;min)),min:n-min)...)
end

"""
`submultisets(set,k)`

`nsubmultisets(set,k)`

`submultisets`  returns  the  set  of  all  multisets of length `k` made of
elements   of   the   set   `set`   (a   collection  without  repetitions).
`nsubmultisets` returns the number of multisets.

An  *multiset* of length `k` is  an unordered selection with repetitions of
length  `k` from `set` and is represented  by a sorted vector of length `k`
made of elements from `set` (it is also sometimes called "combinations with
replacement").

```julia-repl
julia> submultisets(1:4,3)
20-element Vector{Vector{Int64}}:
 [1, 1, 1]
 [1, 1, 2]
 [1, 1, 3]
 [1, 1, 4]
 [1, 2, 2]
 [1, 2, 3]
 [1, 2, 4]
 [1, 3, 3]
 [1, 3, 4]
 [1, 4, 4]
 [2, 2, 2]
 [2, 2, 3]
 [2, 2, 4]
 [2, 3, 3]
 [2, 3, 4]
 [2, 4, 4]
 [3, 3, 3]
 [3, 3, 4]
 [3, 4, 4]
 [4, 4, 4]
```
"""
function submultisets(A,i)
  if i==1 return map(x->[x],A) end
  vcat(map(j->map(v->pushfirst!(v,A[j]),submultisets(A[j:end],i-1)),
           eachindex(A))...)
end

@doc (@doc submultisets) nsubmultisets
nsubmultisets(set,k)=binomial(length(set)+k-1,k)

function symdiffmset(a,b)
  res=eltype(a)[]
  la=length(a)
  lb=length(b)
  ai=bi=1
  ri=0
  while ai<=la || bi<=lb
    if     ai>la res[ri+=1]=b[bi]; bi+=1
    elseif bi>lb res[ri+=1]=a[ai]; ai+=1
    else c=cmp(a[ai],b[bi])
      if     c>0 res[ri+=1]=b[bi]; bi+=1
      elseif c<0 res[ri+=1]=a[ai]; ai+=1
      else
        ai+=1; bi+=1
      end
    end
  end
  res
end

function diffmset(a,b)
  res=eltype(a)[]
  la=length(a)
  lb=length(b)
  ai=bi=1
  ri=0
  while ai<=la || bi<=lb
    if     ai>la break
    elseif bi>lb push!(res,a[ai]); ai+=1
    else c=cmp(a[ai],b[bi])
      if     c>0 bi+=1
      elseif c<0 push!(res,a[ai]); ai+=1
      else
        ai+=1; bi+=1
      end
    end
  end
  res
end

"""
`partitions(set::AbstractVector[,k])`

`npartitions(set::AbstractVector[,k])`

the  set of all unordered partitions of the multiset `set`; if `k` is given
the  unordered partitions in `k` sets.  `npartitions` returns the number of
unordered partitions.

An *unordered partition* of `set` is  a set of pairwise disjoint nonempty
sets with union `set`  and is represented by  a sorted Vector of Vectors.

```julia-repl
julia> npartitions(1:3)
5

julia> partitions(1:3)
5-element Vector{Vector{Vector{Int64}}}:
 [[1, 2, 3]]
 [[1, 2], [3]]
 [[1, 3], [2]]
 [[1], [2, 3]]
 [[1], [2], [3]]

julia> npartitions(1:4,2)
7

julia> partitions(1:4,2)
7-element Vector{Vector{Vector{Int64}}}:
 [[1, 2, 3], [4]]
 [[1, 2, 4], [3]]
 [[1, 2], [3, 4]]
 [[1, 3, 4], [2]]
 [[1, 3], [2, 4]]
 [[1, 4], [2, 3]]
 [[1], [2, 3, 4]]
```
Note  that there is currently no ordered counterpart.
"""
function partitions(set::AbstractVector,k)
  sort!(set)
  res=Vector{Vector{eltype(set)}}[]
  if length(set)<k return res end
  if k==1 return [[collect(set)]] end
  for p in partitions(set[1:end-1],k-1) push!(res,vcat(p,[[set[end]]])) end
  for p in partitions(set[1:end-1],k)
    for i in eachindex(p)
      u=copy(p)
      u[i]=vcat(u[i],[set[end]])
      push!(res,u)
    end
  end
  res
end

function partitions(set::AbstractVector)
  vcat((partitions(set,i) for i in eachindex(set))...)
end

@doc (@doc partitions) npartitions
npartitions(set::AbstractVector,k)=stirling2(length(set),k)

npartitions(set::AbstractVector)=bell(length(set))

"""
`lcm_partitions(p1,…,pn)`

each  argument is  a partition  of the  same set  `S`, given  as a  list of
disjoint  vectors whose  union is  `S`. Equivalently  each argument  can be
interpreted as an equivalence relation on `S`.

The result is the finest partition of `S` such that each argument partition
refines it. It represents the 'or' of the equivalence relations represented
by the arguments.

```julia-repl
julia> lcm_partitions([[1,2],[3,4],[5,6]],[[1],[2,5],[3],[4],[6]])
2-element Vector{Vector{Int64}}:
 [1, 2, 5, 6]
 [3, 4]      
```
"""
function lcm_partitions(arg...)
  function lcm2(a,b)
    res = Set(Vector{Int}[])
    for p in b
     push!(res, sort(union(filter(x->!isempty(intersect(x, p)),a)...)))
    end
    b = Set(Vector{Int}[])
    for p in res
     push!(b, sort(union(filter(x->!isempty(intersect(x, p)),res)...)))
    end
    b
  end
  sort(collect(reduce(lcm2,arg)))
end

"""
`gcd_partitions(p1,…,pn)`

Each  argument is  a partition  of the  same set  `S`, given  as a  list of
disjoint  vectors whose  union is  `S`. Equivalently  each argument  can be
interpreted as an equivalence relation on `S`.

The result is the coarsest partition which refines all argument partitions.
It  represents the  'and' of  the equivalence  relations represented by the
arguments.

```julia-repl
julia> gcd_partitions([[1,2],[3,4],[5,6]],[[1],[2,5],[3],[4],[6]])
6-element Vector{Vector{Int64}}:
 [1]
 [2]
 [3]
 [4]
 [5]
 [6]
```
"""
function gcd_partitions(arg...)
  sort(collect(reduce(arg)do a,b
    res = map(x->map(y->intersect(x, y), b), a)
    sort(unique(filter(!isempty,reduce(vcat,res))))
  end))
end

"""
'bell(n)'

The  Bell numbers are  defined by `bell(0)=1`  and ``bell(n+1)=∑_{k=0}^n {n
\\choose  k}bell(k)``, or by the fact  that `bell(n)/n!` is the coefficient
of `xⁿ` in the formal series `e^(eˣ-1)`.

```julia-repl
julia> bell.(0:6)
7-element Vector{Int64}:
   1
   1
   2
   5
  15
  52
 203

julia> bell(14)
190899322

julia> bell(big(30))
846749014511809332450147
```julia-repl
"""
function bell(n)
  bell_=[one(n)]
  for i in 1:n-1
    push!(bell_,bell_[1])
    for k in 0:i-1 bell_[i-k]+=bell_[i-k+1] end
  end
  bell_[1]
end

"""
`stirling2(n,k)`

the   *Stirling  number   of  the   second  kind*.   They  are  defined  by
`stirling2(0,0)=1`,  `stirling2(n,0)=stirling2(0,k)=0`  if  `n,  k!=0`  and
`stirling2(n,k)=k   stirling2(n-1,k)+stirling2(n-1,k-1)`,   and   also   as
coefficients of the generating function ``x^n=\\sum_{k=0}^{n}stirling2(n,k)
k!{x\\choose k}``.

```julia-repl
julia> stirling2.(4,0:4)
5-element Vector{Int64}:  # Knuth calls this the trademark of stirling2
 0
 1
 7
 6
 1

julia> [stirling2(i,j) for i in 0:6, j in 0:6]
7×7 Matrix{Int64}:
 1  0   0   0   0   0  0 # Note the similarity with Pascal's triangle
 0  1   0   0   0   0  0
 0  1   1   0   0   0  0
 0  1   3   1   0   0  0
 0  1   7   6   1   0  0
 0  1  15  25  10   1  0
 0  1  31  90  65  15  1

julia> stirling2(50,big(10))
26154716515862881292012777396577993781727011
```
"""
function stirling2( n, k )
  if n<k return 0
  elseif n==k return 1
  elseif n<0 && k<0 return stirling1(-k,-n)
  elseif k<=0 return 0
  end
  bin,sti,fib=1,0,1
  for i in 1:k
    bin=div(bin*(k-i+1),i)
    sti=bin*i^n-sti
    fib*=i
  end
  div(sti,fib)
end

const bern=Rational{BigInt}[-1//2]

"""
`bernoulli(n)` the `n`-th *Bernoulli number*  `Bₙ` as a `Rational{BigInt}`

`Bₙ` is defined by ``B₀=1, B_n=-\\sum_{k=0}^{n-1}((n+1\\choose k)B_k)/(n+1)``.
`Bₙ/n!` is the coefficient of  `xⁿ` in the power series of  `x/(eˣ-1)`.
Except for `B₁=-1/2`  the Bernoulli numbers for odd indices are zero.
    
```julia_repl
julia> Combinat.bernoulli(4)
-1//30

julia> Combinat.bernoulli(10)
5//66

julia> Combinat.bernoulli(12) # there is no simple pattern in Bernoulli numbers
-691//2730

julia> Combinat.bernoulli(50) # and they grow fairly fast
495057205241079648212477525//66
```
"""
function bernoulli(n::Integer)
  if n<0 error("bernoulli: $n must be ≥0")
  elseif n==0 return 1//1
  end
  for i in length(bern)+1:n
    if isodd(i) push!(bern,0)
    else
      bin=1
      brn=1
      for j in 1:i-1
        bin=(i+2-j)//j*bin
        brn+=bin*bern[j]
      end
      push!(bern,-brn//(i+1))
    end
  end
  return bern[n]
end

"""
`Catalan(n)` `n`-th Catalan Number

```julia-repl
julia> catalan(8)
1430

julia> catalan(big(50))
1978261657756160653623774456
```
"""
catalan(n::Integer)=Integer(prod(i->(n+i)//i,2:n))

"""
`diagblocks(M::Matrix)`

`M`  should  be  a  square  matrix.  Define  a  graph  `G`  with vertices
`1:size(M,1)` and with an edge between `i`  and `j` if either `M[i,j]` or
`M[j,i]` is not zero or `false`. `diagblocks` returns a vector of vectors
`I`  such that  `I[1]`,`I[2]`, etc..  are the  vertices in each connected
component  of `G`.  In other  words, `M[I[1],I[1]]`,`M[I[2],I[2]]`,etc...
are diagonal blocks of `M`.

```julia-repl
julia> m=[0 0 0 1;0 0 1 0;0 1 0 0;1 0 0 0]
4×4 Matrix{Int64}:
 0  0  0  1
 0  0  1  0
 0  1  0  0
 1  0  0  0

julia> diagblocks(m)
2-element Vector{Vector{Int64}}:
 [1, 4]
 [2, 3]

julia> m[[1,4],[1,4]]
2×2 Matrix{Int64}:
 0  1
 1  0
```
"""
function diagblocks(M::AbstractMatrix)::Vector{Vector{Int}}
  l=size(M,1)
  if l==0 return Vector{Int}[] end
  cc=collect(1:l) # cc[i]: in which block is i, initialized to different blocks
  for i in 1:l, j in i+1:l
    # if new relation i~j then merge components:
    if !(iszero(M[i,j]) && iszero(M[j,i])) && cc[i]!=cc[j]
      cj=cc[j]
      for k in 1:l
         if cc[k]==cj cc[k]=cc[i] end
      end
    end
  end
  sort(collectby(cc,collect(1:l)))
end

"""
`blocks(M:AbstractMatrix)`

Finds  if the  matrix  `M` admits a block decomposition.

Define  a bipartite  graph `G`  with vertices  `axes(M,1)`, `axes(M,2)` and
with an edge between `i` and `j` if `M[i,j]` is not zero. BlocksMat returns
a  list of pairs of  lists `I` such that  `I[i]`, etc.. are the vertices in
the `i`-th connected component of `G`. In other words, `M[I[1][1],I[1][2]],
M[I[2][1],I[2][2]]`,etc... are blocks of `M`.

This  function may  also be  applied to  boolean matrices.

```julia-repl
julia> m=[1 0 0 0;0 1 0 0;1 0 1 0;0 0 0 1;0 0 1 0]
5×4 Matrix{Int64}:
 1  0  0  0
 0  1  0  0
 1  0  1  0
 0  0  0  1
 0  0  1  0

julia> blocks(m)
3-element Vector{Tuple{Vector{Int64}, Vector{Int64}}}:
 ([1, 3, 5], [1, 3])
 ([2], [2])
 ([4], [4])

julia> m[[1,3,5,2,4],[1,3,2,4]]
5×4 Matrix{Int64}:
 1  0  0  0
 1  1  0  0
 0  1  0  0
 0  0  1  0
 0  0  0  1
```
"""
function blocks(M::AbstractMatrix)
  comps=Tuple{Vector{Int},Vector{Int}}[]
  for l in axes(M,1), c in axes(M,2)
    if !iszero(M[l,c])
      p=findfirst(x->l in x[1],comps)
      q=findfirst(x->c in x[2],comps)
      if p===nothing
        if q===nothing  push!(comps, ([l], [c]))
        else union!(comps[q][1], l)
        end
      elseif q===nothing union!(comps[p][2], c)
      elseif p==q 
        union!(comps[p][1], l)
        union!(comps[p][2], c)
      else 
        union!(comps[p][1],comps[q][1])
        union!(comps[p][2],comps[q][2])
        deleteat!(comps,q)
      end
    end
  end
  sort!(comps)
end

"""
`conjugate_partition(λ)`

returns  the  conjugate  partition  of  the  partition  `λ`,  that  is, the
partition having the transposed of the Young diagram of `λ`.

```julia-repl
julia> conjugate_partition([4,2,1])
4-element Vector{Int64}:
 3
 2
 1
 1

julia> conjugate_partition([6])
6-element Vector{Int64}:
 1
 1
 1
 1
 1
 1
```
"""
function conjugate_partition(p)
  if isempty(p) return p end
  res=zeros(eltype(p),maximum(p))
  for i in p, j in 1:i res[j]+=1 end
  res
end

"""
`dominates(λ,μ)`

The  dominance  order  on  partitions  is  an  important  partial  order in
representation theory. `λ` dominates `μ` if and only if for all `i` we have
`sum(λ[1:i])≥sum(μ[1:i])`.

```julia-repl
julia> dominates([5,4],[4,4,1])
true
```
"""
function dominates(λ,μ)
  sλ=sμ=0
  for (l,m) in zip(λ,μ)
    if (sλ+=l)<(sμ+=m) return false end
  end
  true
end

"""
`tableaux(S)`

if  `S`  is  a  partition  tuple,  returns  the  list  of standard tableaux
associated  to the partition tuple `S`, that is a filling of the associated
young  diagrams  with  the  numbers  `1:sum(sum,S)`  such  that the numbers
increase across the rows and down the columns.

If  `S` is a single partition, the standard tableaux for that partition are
returned.

```julia-repl
julia> tableaux([[2,1],[1]])
8-element Vector{Vector{Vector{Vector{Int64}}}}:
 [[[1, 2], [3]], [[4]]]
 [[[1, 2], [4]], [[3]]]
 [[[1, 3], [2]], [[4]]]
 [[[1, 3], [4]], [[2]]]
 [[[1, 4], [2]], [[3]]]
 [[[1, 4], [3]], [[2]]]
 [[[2, 3], [4]], [[1]]]
 [[[2, 4], [3]], [[1]]]

julia> tableaux([2,2])
2-element Vector{Vector{Vector{Int64}}}:
 [[1, 2], [3, 4]]
 [[1, 3], [2, 4]]
```
"""
function tableaux(S)
  if isempty(S) return S end
  w=sum(sum,S)
  if iszero(w) return [map(x->map(y->Int[],x),S)] end
  res=Vector{Vector{Vector{Int}}}[]
  for i in eachindex(S), p in eachindex(S[i])
    if iszero(S[i][p]) || (p<length(S[i]) && S[i][p+1]==S[i][p]) continue end
    S[i][p]-=1; tt=tableaux(S); S[i][p]+=1
    for t in tt push!(t[i][p], w) end
    append!(res,tt)
  end
  sort(res)
end

tableaux(S::Vector{<:Integer})=first.(tableaux([S]))

"""
`robinson_schensted(p::AbstractVector{<:Integer})`

returns  the pair of standard tableaux associated to the permutation `p` by
the Robinson-Schensted correspondence.

```julia-repl
julia> robinson_schensted([2,3,4,1])
([[1, 3, 4], [2]], [[1, 2, 3], [4]])
```
"""
function robinson_schensted(p::AbstractVector{<:Integer})
  P=Vector{Int}[]
  Q=Vector{Int}[]
  for (i,j) in enumerate(p)
    z=1
    while true
      if z>length(P)
        push!(P,[j])
        push!(Q,[i])
        break
      else
        pos=findfirst(>=(j),P[z])
        if isnothing(pos)
          push!(P[z],j)
          push!(Q[z],i)
          break
        else
          (P[z][pos],j)=(j,P[z][pos])
          z+=1
        end
      end
    end
  end
  (P,Q)
end

end
