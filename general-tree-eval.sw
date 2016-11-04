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

# Define the columns for the 5-cycle.
LargePentagon = ["ABCED", "DEACB", "CBDAE", "AEBDC", "DCEAB"]

# Apply that function to a whole tree, given parameters.
def evaluateTree(treeParams,t1,t2,leftNode,middleNode,rightNode):
    # Initialize primitives.
    string = treeParams[0]
    posA = string.index("A")
    valA = treeParams[1]
    posB = string.index("B")
    valB = treeParams[2]
    posC = string.index("C")
    valC = treeParams[3]
    posD = string.index("D")
    valD = treeParams[4]
    posE = string.index("E")
    valE = treeParams[5]
    # Combine them.
    treeVals = [(posA, valA), (posB, valB), (posC, valC), (posD, valD), (posE, valE)]
    treeVals = sorted(treeVals)

    # Evaluate likelihood.
    product = 1
    for i in range(0,5):
        if i == 0 or i == 1:
            product *= evaluateNode(treeVals[i][1],leftNode,1/4)
        elif i == 2:
            product *= evaluateNode(treeVals[i][1],middleNode,1/4)
        else:
            product *= evaluateNode(treeVals[i][1],rightNode,1/4)
    product *= evaluateNode(leftNode,middleNode,t1)
    product *= evaluateNode(middleNode,rightNode,t2)
    return product

# Generate all the characters.
set = [0, 1]
interior = []
collection = [set]*3
for i in itertools.product(*collection):
    interior.append(i)

# Compute the likelihood for all trees on the given internal nodes.
def Likelihood(treeParams,t1,t2):
    sum = 0
    for i in range(len(interior)):
        sum += evaluateTree(treeParams,t1,t2,*interior[i])
    return sum

# Initialize for plotting.
v1 = var('t1')
v2 = var('t2')

topology = "ABCDE"
treeParams1 = [0,1,0,1,0]
treeParams2 = [0,0,1,1,1]
treeParams3 = [1,0,1,1,1]
treeParams4 = [0,1,0,1,1]
treeParams5 = [0,1,1,0,1]

treeParams1.insert(0, topology)
treeParams2.insert(0, topology)
treeParams3.insert(0, topology)
treeParams4.insert(0, topology)
treeParams5.insert(0, topology)

def OverallLikelihood(t1,t2):
    return Likelihood(treeParams1,t1,t2) * Likelihood(treeParams2,t1,t2) * Likelihood(treeParams3,t1,t2) * Likelihood(treeParams4,t1,t2) * Likelihood(treeParams5,t1,t2)

plot3d(OverallLikelihood,(t1,0,30),(t2,0,30))
