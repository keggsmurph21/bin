"""
Kevin Murphy
1/18/2018

rename-files.py
Takes a text file mapping a series of filename replacements delimited by newlines
and `=`s and executes those replacements
"""

import os, sys

def main():

    # require at least one argument
    if len(sys.argv) == 1:
        print 'usage: python rename-files.py ${mapping.txt}'
        exit(1)
    mapping = sys.argv[1]

    # make sure this exists
    if os.path.exists( mapping ) == False:
        print 'unable to find input mapping (%s)' % mapping
        exit(1)

    # read in the mapping
    with open( mapping, 'r' ) as f:
        lines = f.read().splitlines()

    # separate out into orig and dest strings
    swaps = {}
    for line in lines:
        orig, dest = line.split( '=' )

        # change all `orig` to `dest` in the directory
        for f in os.listdir( os.getcwd() ):

            # except for some files defined here
            if os.path.basename(f) not in { '.DS_Store' }:
                if orig in f:

                    newname = f.replace( orig, dest )
                    print 'moving %s\n    to %s' % ( f, newname )

                    # if we're just debugging, don't actually move the files
                    if len(sys.argv) > 2:
                        if sys.argv[2] == 'DEBUG':
                            continue

                    os.rename( f, newname )

    return

if __name__ == "__main__":
    main()
