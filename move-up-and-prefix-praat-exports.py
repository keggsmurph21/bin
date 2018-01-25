"""
Kevin Murphy
1/17/2018

move-and-rename.py
Takes a directory containing files (possibly without extensions) and moves the files up one directory,
prepending the name of the current directory and appending an optional extension
"""

import os, sys

def main():

    # require at least one argument
    if len(sys.argv) == 1:
        print 'usage: python move-and-rename.py ${path/to/dir} (${.extension}) (${DEBUG})'
        exit(1)
    inpath = sys.argv[1]

    # make sure this exists
    if os.path.exists( inpath ) == False:
        print 'unable to find input directory (%s)' % inpath
        exit(1)

    # move here to make the os.rename()s resolve easier
    os.chdir( inpath )

    # resolve relative links to get the name of the directory
    inpath = os.path.abspath( inpath )
    prepend = os.path.basename( inpath.rstrip('/') )

    # check if we want to specify an extension
    if len(sys.argv) > 2:
        extension = '.' + sys.argv[2]
        extension = extension.replace( '..', '.' )
    else:
        extension = ''

    # move everything in the directory
    for f in os.listdir( inpath ):

        # except for some files defined here
        if os.path.basename(f) not in { '.DS_Store' }:

            origFilename, origExtension = os.path.splitext( f )
            filename = prepend + origFilename
            extension = extension if len(extension) else origExtension
            destFilepath = os.path.join( '..', filename + extension )

            src = os.path.abspath(f)
            tar = os.path.abspath(destFilepath)

            # don't overwrite anything
            if os.path.exists( tar ):
                print 'abort: file already exists (%s)' % tar
                print '       (all previous files have been written)'
                exit()

            print 'moving %s\n    to %s' % ( src, tar )

            # if we're just debugging, don't actually move the files
            if len(sys.argv) > 3:
                if sys.argv[3] == 'DEBUG':
                    continue

            os.rename( src, tar )

    return

if __name__ == "__main__":
    main()
