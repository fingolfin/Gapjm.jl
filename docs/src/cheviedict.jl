const ChevieDict=Dict(
#AbelianGenerators
#Affine
#AffineRootAction
"AlgebraicCentre"=>"algebraic_centre",
"AlmostCharacter"=>"AlmostChar",
"Arrangements"=>"arrangements",
"AsReflection"=>"reflection",
"AsFraction"=>"fraction",
"AsRootOfUnity"=>"Root1",
"AssociatedPartition"=>"conjugate_partition",
#AsymptoticAlgebra
"AsWord"=>"word",
#BadPrimes
"BetaSet"=>"βset",
"BigCellDecomposition"=>"bigcell_decomposition",
"Binomial"=>"binomial",
"BipartiteDecomposition"=>"bipartite_decomposition",
"BlocksMat"=>"blocks",
"Braid"=>"BraidMonoid",
"BraidMonoid"=>"BraidMonoid",
"BraidRelations"=>"braid_relations",
#BrieskornNormalForm
"Bruhat"=>"bruhatless",
"BruhatPoset"=>"Poset",
"BruhatSmaller"=>"bruhatless",
"Catalan"=>"catalan",
"CartanMat(\"A\",5)"=>"cartan(:A,5)",
"CartanMatFromCoxeterMatrix"=>"cartan",
"CentralizerGenerators"=>"centralizer_generators",
#CharName
"CharNames"=>"charnames",
"CharParams(W)"=>"charinfo(W)[:charparams]",
"CharRepresentationWords"=>"traces_words_mats",
"CheckHeckeDefiningRelations"=>"isrepresentation",
"ChevieClassInfo"=>"classinfo",
"ChevieCharInfo"=>"charinfo",
#ClassTypes
"Coefficient(p,i)"=>"p[i]",
"Collected"=>"tally",
"CollectBy"=>"collectby",
"Combinations"=>"combinations",
"ComplexConjugate"=>"conj",
"ComplexReflectionGroup"=>"ComplexReflectionGroup",
"Compositions"=>"compositions",
"ConcatenationString(s...)"=>"prod(s)",
"ConjugacySet(b[,F][,type])"=>"conjcat(b[,F],ss=type).obj",
"ConjugatePartition"=>"conjugate_partition",
"CoxeterCoset"=>"spets",
"CoxeterSubCoset"=>"subspets",
"CoxeterElements(W[,l])"=>"elements(W[,l])",
"CoxeterGroup(\"A\",5)"=>"coxgroup(:A,5)",
"CoxeterGroupByCoxeterMatrix"=>"gencox(cartan(C))",
"CoxeterGroupByCartanMatrix(C)"=>"gencox(C)",
"CoxeterGroupHyperoctaedralGroup(n)"=>"CoxHyperoctaedral(n)",
"CoxeterGroupSymmetricGroup(n)"=>"CoxSym(n)",
"CoxeterLength(W,w)"=>"length(W,w)",
"CoxeterMatrix"=>"coxmat",
"CoxeterMatrixFromCartanMat"=>"coxmat",
"CoxeterWord(W,w)"=>"word(W,w)",
"CoxeterWords(W[,l])"=>"word.(Ref(W),elements(W[,l]))",
"CuspidalUnipotentCharacters"=>"cuspidal_unipotent_characters",
"CyclotomicPolynomial(R,i)"=>"cyclotomic_polynomial(i)",
"Cycle"=>"orbit",
"Cycles"=>"orbits",
"CycPol"=>"CycPol",
"CycPolFakeDegreeSymbol"=>"fegsymbol",
"CycPolGenericDegreeSymbol"=>"gendeg_symbol",
"CycPolUnipotentDegrees"=>"CycPolUnipotentDegrees",
"DecomposedMat"=>"diagblocks",
"DefectSymbol"=>"defectsymbol",
"Degree(p)"=>"degree(p)",
"DeligneLusztigCharacter"=>"DLChar",
"DeligneLusztigLefschetz"=>"DLLeftschetz",
"DescribeInvolution"=>"describe_involution",
#DetPerm
#DifferenceMultiSet
"Digits"=>"digits",
#Discriminant
"Dominates"=>"dominates",
"DrinfeldDouble"=>"drinfeld_double",
"Drop"=>"deleteat!",
#Dual
"DualBraid"=>"DualBraidMonoid",
"DualBraidMonoid"=>"DualBraidMonoid",
"EigenspaceProjector"=>"eigenspace_projector",
#EigenvaluesMat
"Elements"=>"elements",
"ElementWithInversions(W,l)"=>"with_inversions(W,l)",
"EltBraid"=>"image",
"EltWord(W,w)"=>"W(w...)",
"ExteriorPower"=>"exterior_power",
"FactorizedSchurElement"=>"FactorizedSchurElement",
"FactorizedSchurElements"=>"FactorizedSchurElements",
"FakeDegree"=>"fakedegree",
"FakeDegrees"=>"fakedegrees",
"FamiliesClassical"=>"FamiliesClassical",
"Family"=>"Family",
"FamilyImprimitive"=>"family_imprimitive",
"FiniteCoxeterTypeFromCartanMat(m)"=>"type_cartan(m)",
"FirstLeftDescending(W,w)"=>"firstleftdescent(W,w)",
"ForEachCoxeterWord(W,f)"=>"for w in W f(word(W,w)) end",
"ForEachElement(W,f)"=>"for w in W f(w) end",
#FormatTable
#Frobenius
"FullSymbol"=>"fullsymbol",
"FundamentalGroup"=>"fundamental_group",
#FusionAlgebra
"GaloisCyc"=>"galois",
"GarsideAlpha"=>"α",
"GarsideWords"=>"elements",
"GcdPartitions"=>"gcd_partitions",
"GcdRepresentation(x,y)"=>"gcdx(x,y)[2:3]",
#GenericDegrees
"GenericOrder"=>"generic_order",
"GenericSign"=>"generic_sign",
"GetRoot"=>"root",
#GoodCoxeterWord
#GraphAutomorphisms
"Hasse"=>"hasse",
"HeckeCharValues"=>"char_values",
#HeckeCharValuesGood
"HeckeCentralMonomials"=>"central_monomials",
"HeckeClassPolynomials"=>"class_polynomials",
"HeckeReflectionRepresentation"=>"refrep",
#HeckeSubAlgebra
#HighestPowerFakeDegrees
"HighestPowerFakeDegreeSymbol"=>"degree_feg_symbol",
#HighestPowerGenericDegrees
"HighestPowerGenericDegreeSymbol"=>"degree_gendeg_symbol",
#HighestShortRoot
"KazhdanLusztigPolynomial"=>"KLPol",
"HyperplaneOrbits"=>"hyperplane_orbits",
"ICCTable"=>"ICCTable",
"Incidence"=>"incidence",
"IndependentLines(M)"=>"echelon(M)[2]",
"IndependentRoots"=>"independent_roots",
"InducedLinearForm"=>"induced_linear_form",
"InductionTable"=>"InductionTable",
#Inherit
"Intersection"=>"intersect",
#IntermediateGroup
"IntListToString"=>"joindigits",
"InvariantForm"=>"invariant_form",
"Invariants"=>"invariants",
"Inversions"=>"inversions",
"IsAbelian"=>"isabelian",
"IsCycPol(p)"=>"p isa CycPol",
"IsFamily(f)"=>"f isa Family",
"IsIsolated"=>"is_isolated",
"IsJoinLattice"=>"is_join_lattice",
"IsMeetLattice"=>"is_meet_lattice",
"IsLeftDescending(W,w,i)"=>"isleftdescent(W,w,i)",
"IsSubset(a,b)"=>"issubset(b,a)",
#IsNormalizing
#IsQuasiIsolated
"IsomorphismType"=>"IsomorphismType",
#IsUnipotentElement
#jInductionTable
#JInductionTable
"Join"=>"join",
"KroneckerProduct"=>"kron",
"LcmPartitions"=>"lcm_partitions",
"LargestMovedPoint"=>"largest_moved_point",
"LeadingCoefficient(p)"=>"p[end]",
"LeftCell"=>"LeftCell",
"LeftCells"=>"LeftCells",
"LeftDescentSet(W,w)"=>"leftdescents(W,w)",
"LeftDivisorsSimple"=>"left_divisors",
"LeftGcd"=>"leftgcd",
#LeftLcm
"LinearExtension"=>"linear_extension",
"ListPerm(p)"=>"vec(p)",
"List(ConjugacyClasses(G),Representative)"=>"classreps(G)",
"LongestCoxeterElement(W)"=>"longest(W)",
"LongestCoxeterWord(W)"=>"word(W,longest(W))",
#LowestPowerFakeDegrees
"LowestPowerFakeDegreeSymbol"=>"valuation_feg_symbol",
#LowestPowerGenericDegrees
"LowestPowerGenericDegreeSymbol"=>"valuation_gendeg_symbol",
#Lusztigaw
#LusztigAw
"LusztigInduction"=>"LusztigInduce",
"LusztigInductionTable"=>"LusztigInductionTable",
"LusztigRestriction"=>"LusztigRestrict",
"MappingPermListList"=>"mappingPerm",
"MatStab"=>"stab_onmat",
"MatXPerm(W,p)"=>"refrep(W,p)",
"MatYPerm"=>"matY",
"MovedPoints"=>"support",
"NrArrangements"=>"narrangements",
"NrDrinfeldDouble"=>"ndrinfeld_double",
"NrPartitions"=>"npartitions",
"NrPartitionTuples"=>"npartition_tuples",
"OnFamily(f,p::Perm)"=>"f^p",
"OnFamily(f,p::Int)"=>"galois(f,p)",
"OnMatrices(m,p)"=>"^(m,p;dims=(1,2))",
"OnSets(s,g)"=>"unique!(sort(s.^g))",
"OnTuples(l,p)"=>"l.^p",
"OnPolynomials(m,p)"=>"p^m",
"ParabolicRepresentatives"=>"parabolic_representatives",
#ParabolicSubgroups
"PartBeta"=>"partβ",
"Partition"=>"partition",
"Partitions"=>"partitions",
"PartitionTuples"=>"partition_tuples",
#PartitionTupleToString
#PermCosetsSubgroup
"PermListList(l1,l2)"=>"Perm(l1,l2)",
"PermList(v)"=>"Perm(v)",
"PermMatMat"=>"perm_onmat",
"PermMatX"=>"PermX",
#PermMatY
"PermutationMat(p,dim)"=>"Matrix(p,dim)",
"Permuted(v,p)"=>"v^p",
"PermutedByCols(m,p)"=>"^(m,p;dims=2)",
#PoincarePolynomial
"Poset"=>"Poset",
"PositionClass"=>"position_class",
"PositionCartesian(a,b)"=>"LinearIndices(reverse(Tuple(a)))[CartesianIndices(Tuple(b))]",
#PositionDet
#PositionId
"PositionRegularClass"=>"position_regular_class",
#Presentation
"PrintDiagram(W)"=>"Diagram(W)",
"ProportionalityCoefficient(v,w)"=>"ratio(v,w)",
"QuasiIsolatedRepresentatives"=>"QuasiIsolatedRepresentatives",
"Rank"=>"rank",
"RankSymbol"=>"ranksymbol",
"ReducedCoxeterWord(W,w)"=>"word(W,W(w...))",
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
"RegularEigenvalues"=>"regular_eigenvalues",
"RelativeDegrees"=>"relative_degrees",
#Replace
"Representations"=>"representations",
"RepresentativeConjugation(b,b'[,F][,type])"=>"conjugating_elt(b,b'[,F],ss=type)",
"RepresentativeDiagonalConjugation"=>"diagconj_elt",
"RepresentativeOperation"=>"transporting_elt",
"RepresentativeRowColPermutation"=>"perm_rowcolmat",
"Restricted"=>"restricted",
"RestrictedPerm(p,d)"=>"restricted(p,d)",
"Reversed"=>"reverse",
#ReversedWord
"RightDescentSet(W,w)"=>"rightdescents(W,w)",
"RightGcd"=>"rightgcd",
"RightLcm"=>"rightlcm",
"RootDatum"=>"rootdatum",
"RootsCartan(m)"=>"roots(m)",
"Rotation(v,i)"=>"circshift(v,-i)",
"Rotations(v)"=>"circshift.(Ref(a),length(a):-1:1)",
"ScalMvp"=>"scal",
#SchurElement
"SchurElements"=>"schur_elements",
"SchurFunctor"=>"schur_functor",
#SemisimpleCentralizerRepresentatives
"SemisimpleElement"=>"SS",
"SemisimpleRank(W)"=>"coxrank(W)",
"SemisimpleRank"=>"semisimplerank",
"SemisimpleSubgroup"=>"torsion_subgroup",
"ShiftBeta"=>"shiftβ",
"ShrinkGarsideGeneratingSet"=>"shrink",
"SignedMatStab"=>"stab_onsmat",
"SignedPerm"=>"SPerm",
"SignedPermListList"=>"SPerm",
"SignedPermMatMat"=>"perm_onsmat",
"Size(W)"=>"length(W)",
"SmallestMovedPoint"=>"smallest_moved_point",
"SolutionMat"=>"solutionmat",
#SpecialPieces
"Spets"=>"spets",
"SplitLevis"=>"split_levis",
"StandardParabolic"=>"standard_parabolic",
"StandardParabolicClass"=>"standard_parabolic_class",
"StructureRationalPointsConnectedCentre"=>"StructureRationalPointsConnectedCentre",
"SubSpets"=>"subspets",
"SubTorus"=>"SubTorus",
#Symbols
#SymbolsDefect
"SymmetricDifference"=>"symdiff",
"SymmetricPower"=>"symmetric_power",
"Tableaux"=>"tableaux",
"Torus"=>"torus",
#TorusOrder
"TransitiveClosure"=>"transitive_closure",
"Transporter"=>"transporter",
#Transversals
"TriangulizeMat"=>"echelon!",
"Twistings"=>"twistings",
"TwoTree(m)"=>"twotree(m)",
#UnipotentAbelianPart
"UnipotentCharacter"=>"UniChar",
"UnipotentCharacters"=>"UnipotentCharacters",
"UnipotentClasses"=>"UnipotentClasses",
#UnipotentDecompose
"UnipotentDegrees(W,q)"=>"degrees(UnipotentCharacters(W),q)",
#UnipotentGroup
"UnorderedTuples"=>"submultisets",
"Valuation(p)"=>"valuation(p)",
"Value(p,x)"=>"p(x)",
"WeightInfo"=>"weightinfo",
#WGraph
#WGraphToRepresentation
"W.matgens[i]"=>"refrep(W,i)",
"W.N"=>"nref(W)",
"W.orbitRepresentative"=>"simple_representatives(W)",
"W.orbitRepresentativeElements[i]"=>"simple_conjugating_element(W,i)",
"W.rootLengths"=>"rootlengths(W)",
)

function gap(s)
  s=Regex(s,"i")
  kk=filter(x->occursin(s,x),keys(ChevieDict))
  if isempty(kk) 
    println("no match")
    return
  end
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
