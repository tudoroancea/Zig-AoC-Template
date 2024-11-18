import numpy as np

patterns = np.ones((27750, 2500))
weights = np.ones((2500, 2500))
# np.einsum("ij,ik,jk -> ij", patterns, patterns, weights)
# -0.5*np.einsum("ij,ik,jk -> i", patterns, patterns, weights)
