#!/usr/bin/env python3
'''
tokenizer.py

Kevin Murphy
March 26, 2018

Takes an input file with sentences delimited by newlines and converts it into
a basic CoNLLU format (no tags or dependencies specified).
'''

import re
import sys

__all__ = [ 'tokenize' ]

def tokenize( f_in=sys.stdin, f_out=sys.stdout ):
    '''
    @param f_in		file-like object to read from
    @param f_out	file-like object to write to
    '''

    if True:
        # doc metadata
        f_out.write( '# newdoc id = km_tokenizer_doc\n' )

        # for each sentence
        lines = [ line.strip() for line in f_in.readlines() ]
        for li, line in enumerate(lines):

            # write the sentence-level metadata
            f_out.write( '# sentence_id = km_tokenizer_sentence_%d\n' % (li+1) )
            f_out.write( '# text = %s\n' % line )

            # separate out punctuation
            line = re.sub( r'([.,;“”"()])', r' \1 ', line )
            # delete redundant spaces
            line = re.sub( r'[ ]+', r' ', line )

            # split into lemmas
            lemmas = [lemma for lemma in line.split(' ') if len(lemma)]

            # conllu dependency skeleton
            skeleton = '\t'.join(['_' for i in range(8)])

            # write lemmas
            for le, lemma in enumerate(lemmas):
                f_out.write( '%d\t%s\t%s\n' % (le+1, lemma, skeleton) )

            f_out.write( '\n' )

if __name__ == '__main__':
    tokenize()

