# Import dependencies.
import itertools
import random

# Copy the individual node-node evaluation functions.
def P00(t,alpha = 1): return 0.5 + 0.5*e**(-2*alpha*t)
def P01(t,alpha = 1): return 0.5 - 0.5*e**(-2*alpha*t)
def P11(t,alpha = 1): return P00(t,alpha)
def P10(t,alpha = 1): return P01(t,alpha)

# Create a general function which selects the appropriate case.
def evaluateNode(node1,node2,t):
    if node1 == node2:
        return P11(t)
    elif node1 != node2:
        return P01(t)

# Apply that function to a whole tree, given parameters.
def evaluateTree(topology,treeParams,t1,leftNode,rightNode):
    # Initialize primitives.
    string = topology
    posA = string.index("A")
    valA = treeParams[0]
    posB = string.index("B")
    valB = treeParams[1]
    posC = string.index("C")
    valC = treeParams[2]
    posD = string.index("D")
    valD = treeParams[3]
    # Combine them.
    treeVals = [(posA, valA), (posB, valB), (posC, valC), (posD, valD)]
    treeVals = sorted(treeVals)

    # Evaluate likelihood.
    product = 1
    for i in range(0,4):
        if i == 0 or i == 1:
            product *= evaluateNode(treeVals[i][1],leftNode,1/4)
        else:
            product *= evaluateNode(treeVals[i][1],rightNode,1/4)
    product *= evaluateNode(leftNode,rightNode,t1)
    return product

# Generate all the characters.
set = [0, 1]
interior = []
collection = [set]*2
for i in itertools.product(*collection):
    interior.append(i)

# Define topology.
topology = "ABCD"

# Compute the likelihood for all trees on the given internal nodes.
def Likelihood(topology,treeParams,t1):
    sum = 0
    for i in range(len(interior)):
        sum += evaluateTree(topology,treeParams,t1,*interior[i])
    return sum

# Initialize for plotting.
v1 = var('t1')

treeParams1 = [0,0,1,0]
treeParams2 = [0,0,0,1]
treeParams3 = [1,1,1,0]
treeParams4 = [1,1,0,1]

def OverallLikelihood(t1):
    return Likelihood(topology, treeParams1,t1) * Likelihood(topology, treeParams2,t1) * Likelihood(topology, treeParams3, t1) * Likelihood(topology, treeParams4, t1)

plot(OverallLikelihood,(t1,0,19))
