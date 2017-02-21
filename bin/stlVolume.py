#!/usr/bin/python3
# Takes names of STL files and prints their volume in mm^3.

import numpy as np
import stl
import sys

volumes= []
for f in sys.argv[1:]:
    mesh = stl.Mesh.from_file(f)
    volumes= volumes +[mesh.get_mass_properties()[0]]
    # print(f, '\t', "%4d" % mesh.get_mass_properties()[0])
    print('{:<70}{:>10}'.format(f, "%4d" % mesh.get_mass_properties()[0]))

print()
print("N=", len(volumes)+1)
print("mean=", "%4d" % np.mean(volumes))
print("std=", "%4d" % np.std(volumes))
print("min=", "%4d" % min(volumes))
print("max=", "%4d" % max(volumes))
print('total=', "%4d" % sum(volumes))
