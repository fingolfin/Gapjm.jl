const ChevieDict=Dict(
#AbelianGenerators
#Affine
#AffineRootAction
"AlgebraicCentre"=>"algebraic_centre",
#AlmostCharacter
"AsReflection"=>"reflection",
"AsFraction"=>"fraction",
"AsRootOfUnity"=>"Root1",
#AsymptoticAlgebra
"AsWord"=>"word",
#BadPrimes
#BigCellDecomposition
"BipartiteDecomposition"=>"bipartite_decomposition",
#BlocksMat
"Braid"=>"BraidMonoid",
"BraidMonoid"=>"BraidMonoid",
"BraidRelations"=>"braid_relations",
#BrieskornNormalForm
"Bruhat"=>"bruhatless",
"BruhatPoset"=>"Poset",
"BruhatSmaller"=>"bruhatless",
"Catalan"=>"catalan",
"CartanMat(\"A\",5)"=>"cartan(:A,5)",
"CentralizerGenerators"=>"centralizer_generators"
#CharName
"CharNames"=>"charnames"
#CharParams
#CharRepresentationWords
"ChevieClassInfo"=>"classinfo",
"ChevieCharInfo"=>"charinfo",
#ClassTypes
"Coefficient(p,i)"=>"p[i]",
"ComplexConjugate"=>"conj",
"ComplexReflectionGroup"=>"ComplexReflectionGroup",
#Compositions
#ConjugacySet
#CoxeterCoset
#CoxeterSubCoset
"CoxeterElements(W[,l])"=>"elements(W[,l])",
"CoxeterGroup(\"A\",5)"=>"coxgroup(:A,5)",
#CoxeterGroupByCoxeterMatrix
#CoxeterGroupByCartanMatrix
"CoxeterGroupHyperoctaedralGroup(n)"=>"CoxHyperoctaedral(n)",
"CoxeterGroupSymmetricGroup(n)"=>"CoxSym(n)",
"CoxeterLength(W,w)"=>"length(W,w)",
"CoxeterMatrix"=>"coxmat",
"CoxeterWord(W,w)"=>"word(W,w)",
"CoxeterWords(W[,l])"=>"word.(Ref(W),elements(W[,l])",
#CuspidalUnipotentCharacters
"CyclotomicPolynomial(R,i)"=>"cyclotomic_polynomial(i)",
#CycPol
#CycPolFakeDegreeSymbol
#CycPolGenericDegreeSymbol
#CycPolUnipotentDegrees
#DecomposedMat
#DefectSymbol
"Degree(p)"=>"degree(p)",
#DeligneLusztigCharacter
#DeligneLusztigLefschetz
#DescribeInvolution
#DetPerm
#Dictionary
#DifferenceMultiSet
#Discriminant
#DrinfeldDouble
#Dual
"DualBraid"=>"DualBraidMonoid",
"DualBraidMonoid"=>"DualBraidMonoid",
#EigenspaceProjector
#EigenvaluesMat
"ElementWithInversions(W,l)"=>"with_inversions(W,l)",
#EltBraid
"EltWord(W,w)"=>"W(w...)",
#ExteriorPower
#FactorizedSchurElement
#FactorizedSchurElements
"FakeDegree"=>"fakedegree",
"FakeDegrees"=>"fakedegrees",
#FamiliesClassical
#Family
#FamilyImprimitive
"FiniteCoxeterTypeFromCartanMat(m)"=>"type_cartan(m)",
"FirstLeftDescending(W,w)"=>"firstleftdescent(W,w)",
"ForEachCoxeterWord(W,f)"=>"for w in W f(word(W,w)) end",
"ForEachElement(W,f)"=>"for w in W f(w) end",
#FormatTable
#Frobenius
#FundamentalGroup
#FusionAlgebra
"GarsideAlpha"=>"α",
"GarsideWords"=>"elements",
#GcdPartitions
#GenericDegrees
#GenericOrder
#GetRoot
#GoodCoxeterWord
#GraphAutomorphisms
#Hasse
#HeckeCharValues
#HeckeCharValuesGood
"HeckeCentralMonomials"=>"central_monomials",
#HeckeClassPolynomials
#HeckeReflectionRepresentation
#HeckeSubAlgebra
#HighestPowerFakeDegrees
#HighestPowerGenericDegrees
#HighestPowerGenericDegreeSymbol
#HighestShortRoot
#KazhdanLusztigPolynomial
"HyperplaneOrbits"=>"hyperplane_orbits",
#ICCTable
#Incidence
#IndependentLines
"IndependentRoots"=>"independent_roots",
#InducedLinearForm
"InductionTable"=>"InductionTable",
#Inherit
#IntermediateGroup
#IntListToString
#InvariantForm
#Invariants
"Inversions"=>"inversions",
#IsCycPol
#IsFamily
#IsIsolated
#IsJoinLattice
#IsMeetLattice
"IsLeftDescending(W,w,i)"=>"isleftdescent(W,w,i)",
#IsNormalizing
#IsQuasiIsolated
#IsomorphismType
#IsUnipotentElement
#jInductionTable
#JInductionTable
"LeadingCoefficient(p)"=>"p[end]",
#LeftCell
#LeftCells
"LeftDescentSet(W,w)"=>"leftdescents(W,w)",
"LeftDivisorsSimple"=>"left_divisors",
"LeftGcd"=>"leftgcd",
#LeftLcm
#LinearExtension
"ListPerm(p)"=>"vec(p)",
"LongestCoxeterElement(W)"=>"longest(W)",
"LongestCoxeterWord(W)"=>"word(W,longest(W))",
#LowestPowerFakeDegrees
#LowestPowerGenericDegrees
#LowestPowerGenericDegreeSymbol
#Lusztigaw
#LusztigAw
#LusztigInduction
#LusztigInductionTable
#LusztigRestriction
#MatStab
"MatXPerm(W,p)"=>"matX(W,p)",
#MatYPerm
#NrDrinfeldDouble
#OnFamily
#OnMatrices
"OnTuples(l,p)"=>"l.^p",
"ParabolicRepresentatives"=>"parabolic_representatives",
#ParabolicSubgroups
#PartBeta
#Partition
#PartitionTupleToString
#PermCosetsSubgroup
"PermListList(l1,l2)"=>"Perm(l1,l2)",
"PermList(v)"=>"Perm(v)",
#PermMatMat
#PermMatX
#PermMatY
#PermmutationMat
"Permuted(v,p)"=>"permuted(v,p)",
#PermutedByCols
#PoincarePolynomial
#Poset
"PositionClass"=>"position_class",
#PositionDet
#PositionId
#PositionRegularClass
#Presentation
"PrintDiagram(W)"=>"Diagram(W)",
"ProportionalityCoefficient(v,w)"=>"ratio(v,w)",
#QuasiIsolatedRepresentatives
"Rank"=>"rank",
#RankSymbol
"ReducedCoxeterWord(W,w)"=>"word(W,W(w...))"
"ReducedExpressions(W,w)"=>"words(W,w)",
"ReducedInRightCoset(W,w)"=>"reduced(W,w)",
"ReducedRightCosetRepresentatives(W,H)"=>"reduced(H,W)",
"Reflection"=>"reflection",
"ReflectionCharacter"=>"reflchar",
#ReflectionCharValue
#ReflectionCoset
"ReflectionDegrees(W)"=>"degrees(W)",
"ReflectionCoDegrees(W)"=>"codegrees(W)",
"ReflectionEigenvalues"=>"refleigen",
"ReflectionLength(W,w)"=>"reflength(W,w)",
#ReflectionWord
#ReflectionName
"Reflections"=>"reflections",
#ReflectionSubCoset
"ReflectionSubgroup"=>"reflection_subgroup",
"ReflectionType"=>"refltype",
#RegularEigenvalues
#RelativeDegrees
#Replace
"Representations"=>"representations",
"RepresentativeConjugation"=>"representative_operation",
#RepresentativeDiagonalConjugaction
#RepresentativeRowColPermutation
#Restricted
"RestrictedPerm(p,d)"=>"restricted(p,d)",
#Reversed
#ReversedWord
"RightDescentSet(W,w)"=>"rightdescents(W,w)",
"RightGcd"=>"rightgcd",
"RightLcm"=>"rightlcm"
"RootDatum"=>"rootdatum",
"RootsCartan(m)"=>"roots(m)",
#Rotation
#Rotations
#SchurElement
#SchurElements
#SchurFunctor
#SemisimpleCentralizerRepresentatives
#SemisimpleElement
"SemisimpleRank(W)"=>"coxrank(W)",
"SemisimpleRank"=>"semisimplerank",
#SemisimpleSubgroup
#ShiftBeta
"ShrinkGarsideGeneratingSet"=>"shrink",
#SignedMatStab
#SignedPerm
#SignedPermListList
#SignedPermMatMat
"Size(W)"=>"length(W)",
#SpecialPieces
#Spets
#SplitLevis
"StandardParabolic"=>"standard_parabolic",
"StandardParabolicClass"=>"standard_parabolic_class",
#StructureRationalPointsConnectedCentre
#SubSpets
#SubTorus
#Symbols
#SymbolsDefect
#SymmetricPower
#Torus
#TorusOrder
#TransitiveClosure
#Transporter
#Transversals
#Twistings
"TwoTree(m)"=>"twotree(m)",
#UnipotentAbelianPart
#UnipotentCharacter
#UnipotentCharacters
#UnipotentClasses
#UnipotentDecompose
#UnipotentDegrees
#UnipotentGroup
"Valuation(p)"=>"valuation(p)",
"Value(p,x)"=>"p(x)",
#WeightInfo
#WGraph
#WGraphToRepresentation
"W.matgens[i]"=>"matX(W,i)",
"W.N"=>"nref(W)",
"W.orbitRepresentative[i]"=>"simple_representative(W,i)",
"W.orbitRepresentativeElement"=>"simple_conjugating_element(W,i)",
)

function chevie(s)
  kk=filter(x->occursin(s,x),keys(ChevieDict))
  pad=maximum(length(k) for k in kk)+2
  for k in kk
    println(rpad(k,pad),"=>  ",ChevieDict[k])
  end
end

function fixdoc()
  s=read("index.md",String)
  pad=maximum(length(k) for k in keys(ChevieDict))+2
  u=[rpad(k,pad)*"→ "*v*"\n" for (k,v) in ChevieDict]
  u=join(sort(u),"")
  s=replace(s,r"The dictionary from GAP3/Chevie is as follows:\n```(.*)```"s=>
           "The dictionary from GAP3/Chevie is as follows:\n```\n"*u*"```")
  open("index.md","w")do f
    write(f,s)
  end
end