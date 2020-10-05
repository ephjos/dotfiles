#!/usr/bin/env python
import numpy as np
from typing import List

def fit_points(ps: List[List[float]]) -> (float, float) :
    if ps == []:
        return
    x, y = zip(*ps)
    A = np.vstack([x,np.ones(len(x))]).T
    m, b = np.linalg.lstsq(A, y, rcond=None)[0]
    return m, b

